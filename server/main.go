package main

import (
	"fmt"
	"io"
	"log"
	"net"
	"net/http"
	"os/exec"
	"runtime"
	"strings"
)

// 配置端口 (HTTP: 56669, UDP: 56670)
// 使用高位动态端口范围 (49152-65535)，避免与常用服务冲突
const PORT = "56669"
const UDP_PORT = "56670"

func main() {
	// 获取本机局域网 IP
	ip := getLocalIP()
	fmt.Printf("CodeFlash Server is running on \nhttp://%s:%s\n", ip, PORT)

	http.HandleFunc("/", handleRoot)
	http.HandleFunc("/send-to-computer", handleSendToComputer)
	http.HandleFunc("/get-from-computer", handleGetFromComputer)

	// 启动 UDP 广播监听
	go startUDPListener()

	// 启动服务
	if err := http.ListenAndServe(":"+PORT, nil); err != nil {
		log.Fatal("Server failed to start:", err)
	}
}

func handleRoot(w http.ResponseWriter, r *http.Request) {
	if r.URL.Path != "/" {
		http.NotFound(w, r)
		return
	}
	w.Header().Set("Content-Type", "text/plain; charset=utf-8")
	_, _ = w.Write([]byte("CodeFlash Server\n\n" +
		"GET  /get-from-computer\n" +
		"POST /send-to-computer\n" +
		"\n" +
		"UDP discovery port: " + UDP_PORT + "\n" +
		"HTTP port: " + PORT + "\n"))
}

// 启动 UDP 监听，用于设备发现
func startUDPListener() {
	addr, err := net.ResolveUDPAddr("udp4", ":"+UDP_PORT)
	if err != nil {
		log.Println("UDP ResolveUDPAddr Error:", err)
		return
	}

	conn, err := net.ListenUDP("udp4", addr)
	if err != nil {
		log.Println("UDP ListenUDP Error:", err)
		return
	}
	defer conn.Close()

	fmt.Println("UDP Discovery Service is running on :" + UDP_PORT)

	buf := make([]byte, 1024)
	for {
		n, remoteAddr, err := conn.ReadFromUDP(buf)
		if err != nil {
			log.Println("UDP Read Error:", err)
			continue
		}

		msg := string(buf[:n])
		if strings.TrimSpace(msg) == "CODEFLASH_DISCOVER" {
			localIP := getLocalIPForRemote(remoteAddr)
			response := fmt.Sprintf(`{"ip": "%s", "port": "%s"}`, localIP, PORT)

			_, err := conn.WriteToUDP([]byte(response), remoteAddr)
			if err != nil {
				log.Println("UDP Write Error:", err)
			} else {
				fmt.Printf("Discovery request from %s, replied with %s\n", remoteAddr, localIP)
			}
		}
	}
}

func getLocalIPForRemote(remoteAddr *net.UDPAddr) string {
	if remoteAddr == nil {
		return getLocalIP()
	}

	network := "udp4"
	if remoteAddr.IP != nil && remoteAddr.IP.To4() == nil {
		network = "udp6"
	}

	c, err := net.DialUDP(network, nil, remoteAddr)
	if err != nil {
		return getLocalIP()
	}
	defer c.Close()

	localAddr, ok := c.LocalAddr().(*net.UDPAddr)
	if !ok || localAddr.IP == nil || localAddr.IP.IsUnspecified() {
		return getLocalIP()
	}
	return localAddr.IP.String()
}

// 处理手机发送过来的剪贴板内容
func handleSendToComputer(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	body, err := io.ReadAll(r.Body)
	if err != nil {
		http.Error(w, "Failed to read body", http.StatusInternalServerError)
		return
	}
	defer r.Body.Close()

	content := string(body)
	if content == "" {
		http.Error(w, "Content is empty", http.StatusBadRequest)
		return
	}

	fmt.Printf("Received from phone: %s\n", content)

	// 异步处理剪贴板写入和通知
	go func(text string) {
		if err := writeToClipboard(text); err != nil {
			log.Printf("Failed to write to clipboard: %v\n", err)
			return
		}
		fmt.Println("Content copied to clipboard automatically.")

		if runtime.GOOS == "darwin" {
			_ = showMacNotification("已复制到剪贴板", "CodeFlash")
		} else if runtime.GOOS == "windows" {
			// Windows 也可以添加通知逻辑，目前先保持静默写入
			fmt.Println("Notification skipped on Windows (silent copy).")
		}
	}(content)

	w.WriteHeader(http.StatusOK)
	w.Write([]byte("Notification sent to computer"))
}

func showMacNotification(message string, title string) error {
	if runtime.GOOS != "darwin" {
		return nil
	}
	message = escapeAppleScriptString(message)
	title = escapeAppleScriptString(title)
	cmdStr := fmt.Sprintf(`display notification "%s" with title "%s"`, message, title)
	cmd := exec.Command("/usr/bin/osascript", "-e", cmdStr)
	_, err := cmd.CombinedOutput()
	return err
}

// 处理手机获取电脑剪贴板的请求
func handleGetFromComputer(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	content, err := readFromClipboard()
	if err != nil {
		log.Printf("Failed to read clipboard: %v\n", err)
		http.Error(w, "Failed to read clipboard", http.StatusInternalServerError)
		return
	}

	fmt.Printf("Sent to phone: %s\n", content)
	w.Header().Set("Content-Type", "text/plain; charset=utf-8")
	w.Write([]byte(content))
}

// 写入系统剪贴板
func writeToClipboard(text string) error {
	if runtime.GOOS == "darwin" {
		s := escapeAppleScriptString(text)
		as := exec.Command("/usr/bin/osascript", "-e", fmt.Sprintf(`set the clipboard to "%s"`, s))
		if out, err := as.CombinedOutput(); err == nil {
			return nil
		} else {
			log.Printf("osascript set clipboard failed: %v, output: %s\n", err, string(out))
		}

		cmd := exec.Command("/usr/bin/pbcopy")
		in, err := cmd.StdinPipe()
		if err != nil {
			return err
		}
		if err := cmd.Start(); err != nil {
			return err
		}
		if _, err := in.Write([]byte(text)); err != nil {
			return err
		}
		if err := in.Close(); err != nil {
			return err
		}
		return cmd.Wait()
	} else if runtime.GOOS == "windows" {
		// 使用 PowerShell 设置剪贴板
		// 注意：Set-Clipboard 在 PowerShell 5.0+ 可用
		// 为了处理特殊字符，可能需要更复杂的转义，或者使用 clip 命令
		// clip 命令会将输出流写入剪贴板，注意它会追加换行
		// 更好的方式是使用 PowerShell 脚本
		cmd := exec.Command("powershell", "-command", "Set-Clipboard", "-Value", fmt.Sprintf("'%s'", strings.ReplaceAll(text, "'", "''")))
		return cmd.Run()
	}
	return fmt.Errorf("unsupported platform")
}

// 读取系统剪贴板
func readFromClipboard() (string, error) {
	if runtime.GOOS == "darwin" {
		as := exec.Command("/usr/bin/osascript", "-e", "the clipboard as text")
		out2, err2 := as.CombinedOutput()
		if err2 == nil {
			return strings.TrimRight(string(out2), "\n"), nil
		}

		cmd := exec.Command("/usr/bin/pbpaste", "-Prefer", "txt")
		out, err := cmd.CombinedOutput()
		if err == nil {
			return string(out), nil
		}

		return "", fmt.Errorf("osascript failed: %w, output: %s; pbpaste failed: %w, output: %s", err2, string(out2), err, string(out))
	} else if runtime.GOOS == "windows" {
		// 使用 PowerShell 读取剪贴板
		cmd := exec.Command("powershell", "-command", "Get-Clipboard")
		out, err := cmd.Output()
		if err != nil {
			return "", err
		}
		return strings.TrimSpace(string(out)), nil
	}
	return "", fmt.Errorf("unsupported platform")
}

// 获取本机局域网 IP
func getLocalIP() string {
	preferredNames := []string{"en0", "en1"}
	ifaces, err := net.Interfaces()
	if err == nil {
		for _, preferred := range preferredNames {
			for _, iface := range ifaces {
				if iface.Name != preferred {
					continue
				}
				addrs, err := iface.Addrs()
				if err != nil {
					continue
				}
				for _, addr := range addrs {
					ipnet, ok := addr.(*net.IPNet)
					if !ok || ipnet.IP == nil {
						continue
					}
					ip := ipnet.IP.To4()
					if ip == nil || ip.IsLoopback() {
						continue
					}
					if ip[0] == 169 && ip[1] == 254 {
						continue
					}
					return ip.String()
				}
			}
		}
	}

	addrs, err := net.InterfaceAddrs()
	if err != nil {
		return "localhost"
	}
	for _, address := range addrs {
		ipnet, ok := address.(*net.IPNet)
		if !ok || ipnet.IP == nil {
			continue
		}
		ip := ipnet.IP.To4()
		if ip == nil || ip.IsLoopback() {
			continue
		}
		if ip[0] == 169 && ip[1] == 254 {
			continue
		}
		return ip.String()
	}
	return "localhost"
}

// 转义 AppleScript 字符串中的特殊字符
func escapeAppleScriptString(s string) string {
	s = strings.ReplaceAll(s, "\\", "\\\\")
	s = strings.ReplaceAll(s, "\"", "\\\"")
	return s
}
