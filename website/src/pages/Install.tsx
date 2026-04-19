import { BookOpen, CheckCircle2, Cog, Terminal } from 'lucide-react'
import { useEffect } from 'react'
import Accordion, { type AccordionItem } from '@/components/Accordion'
import Callout from '@/components/Callout'
import CodeBlock from '@/components/CodeBlock'
import Reveal from '@/components/Reveal'
import SectionTitle from '@/components/SectionTitle'

const toc = [
  { href: '#brew', label: 'Homebrew 安装（开发者推荐）' },
  { href: '#zip', label: 'zip + 安装脚本（推荐）' },
  { href: '#autostart', label: '开机自启（LaunchAgent）' },
  { href: '#windows', label: 'Windows（规划中）' },
  { href: '#upgrade', label: '升级' },
  { href: '#uninstall', label: '卸载' },
  { href: '#faq', label: '常见问题' },
]

export default function Install() {
  useEffect(() => {
    document.title = '安装与开机自启｜CodeFlash'
  }, [])

  const faqs: AccordionItem[] = [
    {
      id: 'gatekeeper',
      question: '首次运行提示“无法打开”或被系统阻止怎么办？',
      answer: (
        <div className="space-y-3">
          <div>如果你是从浏览器/聊天工具下载的二进制，macOS 可能会附加隔离标记。</div>
          <CodeBlock
            label="移除隔离标记（在文件所在目录执行）"
            code={
              '# 解压到 CodeFlash-mac/ 目录后执行\n'
              + 'xattr -dr com.apple.quarantine .\n'
              + '\n'
              + '# 或者仅针对安装目录\n'
              + 'xattr -dr com.apple.quarantine "$HOME/Library/Application Support/CodeFlash"'
            }
          />
          <div>也可以在系统设置的“隐私与安全性”中找到阻止提示并允许。</div>
        </div>
      ),
    },
    {
      id: 'permission-denied',
      question: '复制到别处运行时报：permission denied: ./codeflash-server',
      answer: (
        <div className="space-y-3">
          <div>优先检查可执行权限，然后检查是否存在隔离标记。</div>
          <CodeBlock
            code={
              'chmod +x ./install-mac.sh ./uninstall-mac.sh\n'
              + 'chmod +x ./codeflash-server-*\n'
              + '\n'
              + '# 安装后建议直接使用安装路径的二进制\n'
              + '"$HOME/Library/Application Support/CodeFlash/bin/codeflash-server"'
            }
          />
          <CodeBlock label="仍失败时移除隔离标记" code={'xattr -dr com.apple.quarantine .'} />
        </div>
      ),
    },
    {
      id: 'no-sudo',
      question: '为什么强调不要用 sudo 安装/启动？',
      answer: (
        <div className="space-y-3">
          <div>CodeFlash 需要访问剪贴板/弹窗能力，必须运行在用户会话中（LaunchAgent）。用 sudo 把服务装到 system 域后，通常会导致：</div>
          <div className="space-y-1 text-slate-700">
            <div>1) 电脑剪贴板读写失败</div>
            <div>2) 端口被 root 进程占用，导致用户服务无法启动</div>
          </div>
          <CodeBlock
            label="修复：清理 system 域并重装（需要管理员密码）"
            code={
              'sudo launchctl bootout system "$HOME/Library/LaunchAgents/com.codeflash.server.plist"\n'
              + 'sudo pkill -f "$HOME/Library/Application Support/CodeFlash/bin/codeflash-server" || true\n'
              + './uninstall-mac.sh\n'
              + './install-mac.sh'
            }
          />
        </div>
      ),
    },
    {
      id: 'not-found',
      question: '手机端扫描不到电脑？',
      answer: (
        <div className="space-y-2">
          <div>确认手机与电脑在同一 WiFi，并检查防火墙是否放行端口：</div>
          <div className="cf-code text-slate-800">UDP 56670</div>
          <div className="cf-code text-slate-800">HTTP 56669</div>
        </div>
      ),
    },
    {
      id: 'icon',
      question: '弹窗图标从哪里来？会不会依赖额外文件？',
      answer: (
        <div className="space-y-2">
          <div>图标默认内嵌在可执行文件中。首次需要展示时会写出到缓存目录并复用：</div>
          <div className="cf-code text-slate-800">~/Library/Caches/codeflash/icon.png</div>
          <div>你也可以用环境变量覆盖：</div>
          <div className="cf-code text-slate-800">CODEFLASH_ICON_PATH=/绝对路径/icon.png</div>
        </div>
      ),
    },
  ]

  return (
    <div className="grid gap-10 lg:grid-cols-12">
      <aside className="lg:col-span-3">
        <Reveal y={10}>
          <div className="sticky top-20 cf-card p-5">
            <div className="text-base font-semibold text-slate-900">目录</div>
            <div className="mt-3 space-y-1">
              {toc.map((t) => (
                <a
                  key={t.href}
                  href={t.href}
                  className="block rounded-xl px-3 py-2 text-base text-slate-700 transition hover:bg-slate-900/[0.04] hover:text-slate-900"
                >
                  {t.label}
                </a>
              ))}
            </div>
          </div>
        </Reveal>
      </aside>

      <div className="space-y-12 lg:col-span-9">
        <section>
          <Reveal y={10}>
            <div className="flex items-center gap-2 text-base font-semibold text-slate-700">
              <BookOpen className="h-4 w-4" />
              <span>安装与开机自启指南（macOS）</span>
            </div>
          </Reveal>
          <Reveal y={12} delayMs={40}>
            <h1 className="mt-3 text-3xl font-semibold tracking-tight text-slate-900 md:text-4xl">把电脑端服务装好，并确保开机自启</h1>
          </Reveal>
          <Reveal y={12} delayMs={80}>
            <p className="mt-4 text-base leading-7 text-slate-600 md:text-lg">
              你可以选择 Homebrew（开发者推荐）或 zip + 安装脚本（推荐给普通用户）两种方式。默认服务端口为 HTTP 56669、UDP 56670。
            </p>
          </Reveal>
          <Reveal y={10} delayMs={110}>
            <div className="mt-4">
              <Callout variant="warning">
                电脑端会调用 macOS 的 <span className="font-mono">osascript</span> 弹窗，建议在有 GUI 的用户会话里运行（终端运行或
                LaunchAgent）。
              </Callout>
            </div>
          </Reveal>

          <Reveal y={10} delayMs={125}>
            <div className="mt-4">
              <Callout variant="warning" title="不要用 sudo 安装/启动">
                请直接运行安装脚本（普通用户）。使用 sudo 会把服务装到 system 域，导致剪贴板不可用或端口被占用。
              </Callout>
            </div>
          </Reveal>

          <Reveal y={10} delayMs={140}>
            <div className="mt-4">
              <Callout variant="info" title="平台说明">
                当前页面主要是 macOS 的安装与开机自启教程；Windows 版本正在准备中。我们会在发布 Windows 安装包后补齐对应的步骤与一键自启方案。
              </Callout>
            </div>
          </Reveal>
        </section>

        <section id="brew" className="scroll-mt-24">
          <SectionTitle title="方式 A：Homebrew（开发者推荐）" description="适合开发者：命令行安装、升级更方便，集成 brew 服务管理。" />
          <div className="mt-4 grid gap-4">
            <Reveal y={10}>
              <Callout variant="info" title="前提条件">
                你需要先安装 <a href="https://brew.sh/" target="_blank" rel="noreferrer" className="underline decoration-slate-400 underline-offset-4 hover:decoration-slate-900">Homebrew</a>。
              </Callout>
            </Reveal>

            <Reveal y={10} delayMs={60}>
              <CodeBlock
                label="1. 添加仓库并安装"
                code={'brew tap ZestBox-18/codeflash\nbrew install codeflash'}
              />
            </Reveal>

            <Reveal y={10} delayMs={100}>
              <CodeBlock
                label="2. 启动服务并设置开机自启"
                code={'brew services start codeflash'}
              />
            </Reveal>

            <Reveal y={10} delayMs={140}>
              <CodeBlock
                label="3. 验证服务状态"
                code={'brew services list\n# 应显示 codeflash status 为 started'}
              />
            </Reveal>

            <Reveal y={10} delayMs={180}>
              <Callout variant="warning" title="注意端口占用">
                如果你之前使用过 zip 脚本安装或手动运行过服务，请确保先停止旧服务（端口 56669/56670），否则 brew 启动会失败。
                <div className="mt-2 text-sm text-orange-900">zip 方式建议直接执行解压目录内的 <span className="font-mono">./uninstall-mac.sh</span> 进行卸载/停用。</div>
                <div className="mt-2 font-mono text-xs bg-orange-50 p-2 rounded text-orange-800">
                  lsof -i:56669  # 检查端口占用
                </div>
              </Callout>
            </Reveal>

            <Reveal y={10} delayMs={220}>
              <div className="space-y-4">
                 <h3 className="text-lg font-semibold text-slate-900">常用维护命令</h3>
                 <CodeBlock label="停止服务" code={'brew services stop codeflash'} />
                 <CodeBlock label="重启服务" code={'brew services restart codeflash'} />
                 <CodeBlock label="查看日志" code={'tail -n 200 "$(brew --prefix)/var/log/codeflash.log"'} />
                 <CodeBlock label="升级版本" code={'brew update\nbrew upgrade codeflash\nbrew services restart codeflash'} />
                 <CodeBlock label="卸载" code={'brew services stop codeflash\nbrew uninstall codeflash\nbrew untap ZestBox-18/codeflash'} />
              </div>
            </Reveal>
          </div>
        </section>

        <section id="zip" className="scroll-mt-24">
          <SectionTitle title="方式 B：zip + 安装脚本" description="适合绝大多数用户：下载解压，执行脚本完成安装与自启。" />
          <div className="mt-4 grid gap-4">
            <Reveal y={10}>
              <Callout variant="info" title="离线包下载链接（macOS）">
                <a
                  href="https://codeflash.oss-cn-guangzhou.aliyuncs.com/CodeFlash-mac.zip"
                  target="_blank"
                  rel="noreferrer"
                  className="underline decoration-slate-400 underline-offset-4 hover:decoration-slate-900"
                >
                  https://codeflash.oss-cn-guangzhou.aliyuncs.com/CodeFlash-mac.zip
                </a>
              </Callout>
            </Reveal>

            <Reveal y={10}>
              <Callout variant="info" title="离线包结构">
                <div className="space-y-2">
                  <div>CodeFlash-mac/</div>
                  <div className="pl-4">- codeflash-server-amd64</div>
                  <div className="pl-4">- codeflash-server-arm64</div>
                  <div className="pl-4">- install-mac.sh</div>
                  <div className="pl-4">- uninstall-mac.sh</div>
                  <div className="pl-4">- com.codeflash.server.plist.template</div>
                  <div className="pl-4">- README.txt</div>
                </div>
              </Callout>
            </Reveal>

            <Reveal y={10} delayMs={40}>
              <Callout variant="info" title="安装路径（固定，便于排错）">
                <div className="space-y-2">
                  <div>可执行文件：~/Library/Application Support/CodeFlash/bin/codeflash-server</div>
                  <div>LaunchAgent：~/Library/LaunchAgents/com.codeflash.server.plist</div>
                  <div>日志：~/Library/Logs/CodeFlash/server.log（以及 server.err.log）</div>
                </div>
              </Callout>
            </Reveal>

            <Reveal y={10} delayMs={60}>
              <CodeBlock
                label="下载并解压（示例：以 Downloads 目录为例）"
                code={
                  'cd ~/Downloads\n'
                  + 'curl -L -o CodeFlash-mac.zip "https://codeflash.oss-cn-guangzhou.aliyuncs.com/CodeFlash-mac.zip"\n'
                  + '# 解压后得到 CodeFlash-mac/ 目录\n'
                  + 'unzip -o CodeFlash-mac.zip\n'
                  + 'cd CodeFlash-mac'
                }
              />
            </Reveal>

            <Reveal y={10} delayMs={100}>
              <CodeBlock label="运行安装脚本（示例）" code={'chmod +x ./install-mac.sh\n./install-mac.sh'} />
            </Reveal>

            <Reveal y={10} delayMs={140}>
              <Callout variant="info" title="脚本做什么？">
                <div className="space-y-1">
                  <div>1) 自动识别 CPU（arm64/amd64），安装 codeflash-server 到固定目录（并修复可执行权限/隔离标记）</div>
                  <div>2) 渲染 com.codeflash.server.plist.template（写入正确的绝对路径与日志路径）</div>
                  <div>3) 写入 ~/Library/LaunchAgents 并加载（立即启动 + 开机自启）</div>
                </div>
              </Callout>
            </Reveal>

            <Reveal y={10} delayMs={180}>
              <CodeBlock
                label="验证：服务是否启动（端口监听）"
                code={'lsof -nP -iTCP:56669 -sTCP:LISTEN || true\n# UDP 发现端口\nlsof -nP -iUDP:56670 || true'}
              />
            </Reveal>

            <Reveal y={10} delayMs={220}>
              <CodeBlock
                label="自测：触发电脑端弹窗"
                code={'curl -X POST http://127.0.0.1:56669/send-to-computer --data "hello from curl"'}
              />
            </Reveal>

            <Reveal y={10} delayMs={260}>
              <CodeBlock label="卸载" code={'chmod +x ./uninstall-mac.sh\n./uninstall-mac.sh'} />
            </Reveal>
          </div>
        </section>

        <section id="autostart" className="scroll-mt-24">
          <SectionTitle title="开机自启：LaunchAgent" description="zip 方式默认会帮你完成；此处提供手动启用/禁用/验证。" />
          <div className="mt-4 grid gap-4">
            <CodeBlock
              label="启用（加载 LaunchAgent）"
              code={'launchctl bootstrap "gui/$UID" ~/Library/LaunchAgents/com.codeflash.server.plist'}
            />
            <CodeBlock
              label="禁用（卸载 LaunchAgent）"
              code={'launchctl bootout "gui/$UID" ~/Library/LaunchAgents/com.codeflash.server.plist || true'}
            />
            <CodeBlock label="检查是否已加载" code={'launchctl list | grep -i codeflash || true'} />
            <CodeBlock
              label="验证端口（服务启动后）"
              code={'lsof -nP -iTCP:56669 -sTCP:LISTEN || true'}
            />
          </div>
        </section>

        <section id="windows" className="scroll-mt-24">
          <SectionTitle title="Windows（规划中）" description="先把用户预期说清楚：Windows 版将提供独立安装包与自启指南。" />
          <div className="mt-4 grid gap-4">
            <Callout variant="warning" title="当前状态">
              Windows 端目前尚未提供完整的一键安装与开机自启脚本。本节用于提前说明发布后你会如何引导用户。
            </Callout>

            <CodeBlock
              label="Windows 版发布后（示例步骤）"
              code={
                '1) 下载 codeflash-server.exe 并解压\n'
                + '2) 双击运行（首次可能弹防火墙提示，允许局域网访问）\n'
                + '3) 在手机端进行局域网发现或手动填写 IP\n'
                + '4) 使用 PowerShell 发送测试请求\n'
                + '   curl -X POST http://127.0.0.1:56669/send-to-computer -Body "hello"'
              }
            />

            <Callout variant="info" title="后续会补齐什么？">
              <div className="space-y-1">
                <div>1) Windows 下载包（包含 exe、说明文档、可选开机自启配置）</div>
                <div>2) 常见问题：防火墙、端口占用、权限、启动项</div>
              </div>
            </Callout>
          </div>
        </section>

        <section id="upgrade" className="scroll-mt-24">
          <SectionTitle title="升级" description="zip 与 Homebrew 的升级方式不同。" />
          <div className="mt-4 grid gap-4 lg:grid-cols-2">
            <div className="cf-card cf-card-hover p-6">
              <div className="flex items-center gap-2 text-base font-semibold text-slate-900">
                <Terminal className="h-4 w-4" />
                <span>Homebrew</span>
              </div>
              <div className="mt-2 text-base leading-7 text-slate-600">使用 brew upgrade 升级。</div>
              <div className="mt-3">
                <CodeBlock code={'brew update\nbrew upgrade codeflash\n# 升级后建议重启服务\nbrew services restart codeflash'} />
              </div>
            </div>
            <div className="cf-card cf-card-hover p-6">
              <div className="flex items-center gap-2 text-base font-semibold text-slate-900">
                <CheckCircle2 className="h-4 w-4" />
                <span>zip 方式</span>
              </div>
              <div className="mt-2 text-base leading-7 text-slate-600">下载新 zip 后重新运行安装脚本，覆盖旧版本即可。</div>
              <div className="mt-3">
                <CodeBlock
                  code={
                    'cd ~/Downloads\n'
                    + 'unzip -o CodeFlash-mac.zip\n'
                    + 'cd CodeFlash-mac\n'
                    + 'chmod +x ./install-mac.sh\n'
                    + './install-mac.sh'
                  }
                />
              </div>
            </div>
          </div>
        </section>

        <section id="uninstall" className="scroll-mt-24">
          <SectionTitle title="卸载" description="提供最小可逆步骤，确保不再自启。" />
          <div className="mt-4 grid gap-4">
            <Callout variant="warning" title="卸载前建议">
              先卸载 LaunchAgent，避免开机自动重启服务。
            </Callout>
            <CodeBlock
              label="zip 方式卸载（推荐）"
              code={'cd CodeFlash-mac\nchmod +x ./uninstall-mac.sh\n./uninstall-mac.sh'}
            />
            <CodeBlock
              label="zip 方式卸载（手动方式，用于排错）"
              code={
                'launchctl bootout "gui/$UID" ~/Library/LaunchAgents/com.codeflash.server.plist || true\n'
                + 'rm -f ~/Library/LaunchAgents/com.codeflash.server.plist\n'
                + 'rm -rf "$HOME/Library/Application Support/CodeFlash"\n'
                + '# 日志默认在：~/Library/Logs/CodeFlash/'
              }
            />
            <CodeBlock label="Homebrew 卸载（示例）" code={'brew services stop codeflash\nbrew uninstall codeflash'} />
          </div>
        </section>

        <section id="faq" className="scroll-mt-24">
          <SectionTitle title="常见问题" description="遇到问题先看这里，基本都能自助解决。" icon={<Cog className="h-4 w-4" />} />
          <div className="mt-4">
            <Accordion items={faqs} />
          </div>
        </section>
      </div>
    </div>
  )
}
