import { FileText } from 'lucide-react'
import { NavLink } from 'react-router-dom'
import { cn } from '@/lib/utils'

const linkBase =
  'inline-flex items-center gap-2 rounded-xl px-3 py-2 text-base font-semibold text-slate-700 transition hover:bg-slate-900/[0.04] hover:text-slate-900'

export default function NavBar() {
  return (
    <header className="sticky top-0 z-50 border-b border-slate-200/70 bg-white/75 backdrop-blur">
      <div className="cf-container flex items-center justify-between px-4 py-3">
        <NavLink to="/" className="flex items-center gap-2">
          <img src="/logo.png" alt="CodeFlash" className="h-9 w-9 rounded-xl" />
          <div className="leading-tight">
            <div className="text-base font-semibold text-slate-900">CodeFlash</div>
            <div className="text-xs text-slate-600">局域网剪贴板同步</div>
          </div>
        </NavLink>

        <nav className="flex items-center gap-1">
          <NavLink
            to="/install"
            className={({ isActive }) =>
              cn(
                linkBase,
                isActive && 'bg-[#2FAF49]/10 text-slate-900 ring-1 ring-[#2FAF49]/15',
              )
            }
          >
            <FileText className="h-4 w-4" />
            <span className="hidden sm:inline">安装与自启</span>
            <span className="sm:hidden">安装</span>
          </NavLink>
        </nav>
      </div>
    </header>
  )
}
