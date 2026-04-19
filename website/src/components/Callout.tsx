import { AlertTriangle, Info } from 'lucide-react'
import { type ReactNode } from 'react'
import { cn } from '@/lib/utils'

type Variant = 'info' | 'warning' | 'danger'

const variants: Record<Variant, { wrap: string; icon: ReactNode; title: string }> = {
  info: {
    wrap: 'border-[#2FAF49]/20 bg-[#2FAF49]/10 text-slate-900',
    icon: <Info className="h-4 w-4" />,
    title: '提示',
  },
  warning: {
    wrap: 'border-amber-500/25 bg-amber-400/15 text-slate-900',
    icon: <AlertTriangle className="h-4 w-4" />,
    title: '注意',
  },
  danger: {
    wrap: 'border-rose-500/25 bg-rose-400/15 text-slate-900',
    icon: <AlertTriangle className="h-4 w-4" />,
    title: '风险提示',
  },
}

export default function Callout({
  variant,
  children,
  title,
}: {
  variant: Variant
  children: ReactNode
  title?: string
}) {
  const v = variants[variant]
  return (
    <div className={cn('cf-card border px-5 py-4', v.wrap)}>
      <div className="flex items-center gap-2 text-base font-semibold">
        {v.icon}
        <span>{title ?? v.title}</span>
      </div>
      <div className="mt-2 text-base leading-7 text-slate-700 md:text-lg md:leading-8">{children}</div>
    </div>
  )
}
