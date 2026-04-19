class Codeflash < Formula
  desc "Local network clipboard sync tool for HarmonyOS, iOS, and macOS"
  homepage "https://github.com/ZestBox-18/homebrew-codeflash"
  version "1.0.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ZestBox-18/homebrew-codeflash/releases/download/v1.0.2/codeflash-server-macos-arm64.tar.gz"
      sha256 "c2eab2c2c037138e36843a288fe33d52451d6386d16f30f5347b0d4c29faf23a"

      def install
        bin.install "codeflash-server-arm64" => "codeflash-server"
      end
    else
      url "https://github.com/ZestBox-18/homebrew-codeflash/releases/download/v1.0.2/codeflash-server-macos-amd64.tar.gz"
      sha256 "1e31e773e96f59f6924375cce03b270d2305abb9e17be37d6f8b38f14b8b7d43"

      def install
        bin.install "codeflash-server-amd64" => "codeflash-server"
      end
    end
  end

  service do
    run [opt_bin/"codeflash-server"]
    keep_alive true
    log_path var/"log/codeflash.log"
    error_log_path var/"log/codeflash.err"
    run_type :immediate
  end

  def post_install
    return unless $stdout.tty?
    return if ENV["TERM"] == "dumb" || ENV.key?("NO_COLOR")

    color_reset = "\e[0m"
    color_a = "\e[38;5;45m"
    color_b = "\e[38;5;213m"

    lines_a = [
      "   _____          _      ______ _           _     ",
      "  / ____|        | |    |  ____| |         | |    ",
      " | |     ___   __| | ___| |__  | | __ _ ___| |__  ",
    ]
    lines_b = [
      " | |    / _ \\ / _` |/ _ \\  __| | |/ _` / __| '_ \\ ",
      " | |___| (_) | (_| |  __/ |    | | (_| \\__ \\ | | |",
      "  \\_____\\___/ \\__,_|\\___|_|    |_|\\__,_|___/_| |_|",
    ]

    puts color_a + lines_a.join("\n") + "\n" + color_b + lines_b.join("\n") + color_reset
  end

  def caveats
    <<~EOS
      启动后台服务：
        brew services start codeflash

      查看日志：
        tail -n 200 "#{var}/log/codeflash.log"

      停止服务：
        brew services stop codeflash
    EOS
  end

  test do
    assert_predicate bin/"codeflash-server", :exist?
  end
end
