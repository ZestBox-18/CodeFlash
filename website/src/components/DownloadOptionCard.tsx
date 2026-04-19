import { ArrowRight, Package, Terminal } from 'lucide-react'
import { Link } from 'react-router-dom'
import { cn } from '@/lib/utils'

type Props = {
  title: string
  description: string
  bullets: string[]
  ctaLabel: string
  to: string
  kind: 'zip' | 'brew'
  secondaryAction?: {
    label: string
    href: string
  }
}

export default function DownloadOptionCard({ title, description, bullets, ctaLabel, to, kind, secondaryAction }: Props) {
  const icon = kind === 'zip' ? <Package className="h-4 w-4" /> : <Terminal className="h-4 w-4" />
  const badge = kind === 'zip' ? '推荐' : '开发者偏好'

  return (
    <div className="cf-card cf-card-hover p-6">
      <div className="flex items-start justify-between gap-4">
        <div className="min-w-0">
          <div className="flex items-center gap-2 text-base font-semibold text-slate-900">
            <span className="inline-flex items-center gap-2">
              <span className="grid h-8 w-8 place-items-center rounded-xl border border-slate-200 bg-white">{icon}</span>
              <span>{title}</span>
            </span>
          </div>
          <div className="mt-2 text-base leading-7 text-slate-600">{description}</div>
        </div>
        <span
          className={cn(
            'shrink-0 whitespace-nowrap rounded-full px-2 py-1 text-xs font-semibold',
            kind === 'zip' ? 'bg-[#2FAF49]/10 text-[#1E7A33]' : 'bg-slate-100 text-slate-700',
          )}
        >
          {badge}
        </span>
      </div>

      <ul className="mt-5 space-y-2 text-base text-slate-600">
        {bullets.map((b) => (
          <li key={b} className="flex gap-2">
            <span className="mt-2 h-1.5 w-1.5 flex-none rounded-full bg-slate-300" />
            <span>{b}</span>
          </li>
        ))}
      </ul>

      <div className="mt-5 flex flex-wrap gap-2">
        <Link
          to={to}
          className="inline-flex items-center gap-2 rounded-xl border border-slate-200 bg-white px-4 py-2.5 text-[15px] font-semibold text-slate-900 transition hover:bg-slate-50"
        >
          <span>{ctaLabel}</span>
          <ArrowRight className="h-4 w-4" />
        </Link>

        {secondaryAction && (
          <a
            href={secondaryAction.href}
            target="_blank"
            rel="noreferrer"
            className="inline-flex items-center gap-2 rounded-xl border border-slate-200 bg-white px-4 py-2.5 text-[15px] font-semibold text-slate-900 transition hover:bg-slate-50"
          >
            <span>{secondaryAction.label}</span>
            <ArrowRight className="h-4 w-4" />
          </a>
        )}
      </div>
    </div>
  )
}
