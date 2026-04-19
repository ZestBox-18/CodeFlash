import { Github, Shield, Wifi } from 'lucide-react'

export default function Footer() {
  return (
    <footer className="border-t border-slate-200/70 px-4 py-10">
      <div className="cf-container flex flex-col gap-8 text-[15px]">
        <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
          <div className="flex flex-wrap items-center gap-x-6 gap-y-2 text-slate-600">
            <span className="inline-flex items-center gap-2">
              <Wifi className="h-4 w-4" />
              <span>局域网直连</span>
            </span>
            <span className="inline-flex items-center gap-2">
              <Shield className="h-4 w-4" />
              <span>无需登录</span>
            </span>
          </div>
          <a
            className="inline-flex items-center gap-2 text-slate-700 transition hover:text-slate-900"
            href="#"
            onClick={(e) => e.preventDefault()}
          >
            <Github className="h-4 w-4" />
            <span>GitHub（即将提供）</span>
          </a>
        </div>
        
        <div className="flex flex-wrap items-center justify-center gap-x-4 gap-y-2 border-t border-slate-100 pt-8 text-sm text-slate-500">
          <span>© 2026 ZestBox.</span>
          <a
            className="transition hover:text-slate-700"
            href="http://beian.miit.gov.cn/"
            target="_blank"
            rel="noopener noreferrer"
          >
            粤ICP备2024282649号-2A
          </a>
        </div>
      </div>
    </footer>
  )
}
