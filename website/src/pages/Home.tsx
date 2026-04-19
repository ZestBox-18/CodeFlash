import { ArrowRight, Clipboard, Shield, Wifi } from 'lucide-react'
import { Link } from 'react-router-dom'
import Callout from '@/components/Callout'
import CodeBlock from '@/components/CodeBlock'
import DownloadOptionCard from '@/components/DownloadOptionCard'
import Reveal from '@/components/Reveal'
import SectionTitle from '@/components/SectionTitle'

export default function Home() {
  return (
    <div className="space-y-16">
      <section className="pt-4">
        <div className="grid gap-8 lg:grid-cols-12 lg:items-center">
          <div className="lg:col-span-7">
            <Reveal y={10}>
              <div className="inline-flex items-center gap-2 rounded-full border border-slate-200 bg-white/80 px-3 py-1 text-xs font-semibold text-slate-700">
                <Wifi className="h-3.5 w-3.5" />
                <span>局域网直连 · 秒级同步</span>
              </div>
            </Reveal>
            <Reveal y={14} delayMs={40}>
              <h1 className="mt-5 text-4xl font-semibold tracking-tight text-slate-900 sm:text-5xl">
                CodeFlash
                <span className="block text-slate-600">轻量化剪贴板同步工具</span>
              </h1>
            </Reveal>
            <Reveal y={14} delayMs={80}>
              <p className="mt-4 text-lg leading-8 text-slate-600">
                面向 macOS/Windows 电脑端与 HarmonyOS/iOS 手机端。无需登录，无需公网，在同一 WiFi 下即可完成复制粘贴的跨设备传递。
              </p>
            </Reveal>

            <Reveal y={12} delayMs={110}>
              <div className="mt-4 flex flex-wrap gap-2">
                <span className="inline-flex items-center rounded-full border border-slate-200 bg-white px-3 py-1 text-sm font-semibold text-slate-700">
                  macOS：已支持安装与开机自启
                </span>
                <span className="inline-flex items-center rounded-full border border-slate-200 bg-white px-3 py-1 text-sm font-semibold text-slate-600">
                  Windows：正在准备（教程与安装包将补齐）
                </span>
              </div>
            </Reveal>
            <Reveal y={12} delayMs={140}>
              <div className="mt-6 flex flex-col gap-3 sm:flex-row">
                <Link to="/install" className="cf-btn-primary">
                  <span>查看安装与开机自启</span>
                  <ArrowRight className="h-4 w-4" />
                </Link>
                <a href="#download" className="cf-btn-secondary">
                  选择下载方式
                </a>
              </div>
            </Reveal>

            <div className="mt-6 grid gap-3 sm:grid-cols-3">
              {[{
                icon: <Clipboard className="h-4 w-4" />,
                title: '原生弹窗',
                desc: '收到推送点击即可复制',
              },
              {
                icon: <Shield className="h-4 w-4" />,
                title: '无需账号',
                desc: '只在局域网内通信',
              },
              {
                icon: <Wifi className="h-4 w-4" />,
                title: '自动发现',
                desc: '手机端一键扫描电脑',
              }].map((f, idx) => (
                <Reveal key={f.title} delayMs={idx * 60} y={10}>
                  <div className="cf-card cf-card-hover p-5">
                    <div className="flex items-center gap-2 text-base font-semibold text-slate-900">
                      {f.icon}
                      <span>{f.title}</span>
                    </div>
                    <div className="mt-1 text-base text-slate-600">{f.desc}</div>
                  </div>
                </Reveal>
              ))}
            </div>
          </div>

          <div className="lg:col-span-5">
            <Reveal y={10}>
              <Callout variant="info" title="默认端口">
                <div className="space-y-2">
                  <div>HTTP：56669（剪贴板收发）</div>
                  <div>UDP：56670（设备发现）</div>
                </div>
              </Callout>
            </Reveal>
            <Reveal y={10} delayMs={80}>
              <div className="mt-4">
                <CodeBlock
                  label="快速自测：触发电脑端弹窗"
                  code={'curl -X POST http://127.0.0.1:56669/send-to-computer \\\n+  --data "hello from curl"'}
                />
              </div>
            </Reveal>
          </div>
        </div>
      </section>

      <section id="download" className="scroll-mt-24">
        <SectionTitle title="下载方式" description="两种安装路径：离线包脚本安装，或 Homebrew。" />
        <div className="mt-6 grid gap-4 lg:grid-cols-2">
          <Reveal y={10}>
            <DownloadOptionCard
              kind="brew"
              title="Homebrew（推荐）"
              description="适合开发者（macOS）：命令行安装、升级更方便，集成 brew 服务管理。"
              bullets={["brew 安装/升级", "适合自动化环境", "brew services 一键自启"]}
              ctaLabel="查看 Homebrew 安装步骤"
              to="/install#brew"
            />
          </Reveal>
          <Reveal y={10} delayMs={80}>
            <DownloadOptionCard
              kind="zip"
              title="zip + 安装脚本"
              description="适合大多数用户（macOS）：下载解压后运行脚本，一键安装与开机自启。"
              bullets={["无需 Homebrew", "可开机自启（LaunchAgent）", "安装路径固定，便于排错"]}
              ctaLabel="查看 zip 安装步骤"
              to="/install#zip"
              secondaryAction={{
                label: '直接下载离线包（macOS）',
                href: 'https://codeflash.oss-cn-guangzhou.aliyuncs.com/CodeFlash-mac.zip',
              }}
            />
          </Reveal>
        </div>

        <div className="mt-4">
          <Reveal y={10}>
            <Callout variant="info" title="Windows 说明">
              Windows 版将提供独立下载包与对应的开机自启指南；目前官网页面以 macOS 教程为准。
            </Callout>
          </Reveal>
        </div>
      </section>

      <section>
        <SectionTitle title="快速开始" description="用 4 步完成安装与验证。" />
        <div className="mt-6 grid gap-4 lg:grid-cols-4">
          {[
            { k: '1', t: '下载', d: '选择 zip 或 Homebrew' },
            { k: '2', t: '安装', d: '运行脚本或 brew install' },
            { k: '3', t: '启用自启', d: 'LaunchAgent 或 brew services' },
            { k: '4', t: '验证', d: 'curl 触发弹窗/检查端口' },
          ].map((s) => (
            <div key={s.k} className="cf-card cf-card-hover p-6">
              <div className="text-xs font-semibold text-slate-500">STEP {s.k}</div>
              <div className="mt-2 text-base font-semibold text-slate-900">{s.t}</div>
              <div className="mt-1 text-base text-slate-600">{s.d}</div>
            </div>
          ))}
        </div>
        <div className="mt-6">
          <Link
            to="/install"
            className="inline-flex items-center gap-2 rounded-xl border border-slate-200 bg-white px-5 py-3 text-[15px] font-semibold text-slate-900 transition hover:bg-slate-50"
          >
            <span>进入完整安装指南</span>
            <ArrowRight className="h-4 w-4" />
          </Link>
        </div>
      </section>

      <section>
        <SectionTitle title="版本与校验" description="下载产物上线后，你可以在这里对照校验值。" />
        <div className="mt-4 grid gap-4 lg:grid-cols-2">
          <div className="cf-card cf-card-hover p-6">
            <div className="text-base font-semibold text-slate-900">当前推荐版本</div>
            <div className="mt-2 text-base text-slate-600">v1.0.1（2026 年 3 月 17 日发布）</div>
          </div>
          <CodeBlock
            label="校验 zip 文件 SHA256（示例）"
            code={'shasum -a 256 CodeFlash-mac.zip'}
            className="lg:self-start"
          />
        </div>
      </section>
    </div>
  )
}
