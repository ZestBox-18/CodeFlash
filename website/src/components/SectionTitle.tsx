import { type ReactNode } from 'react'

export default function SectionTitle({ title, description, icon }: { title: string; description?: string; icon?: ReactNode }) {
  return (
    <div className="flex items-start justify-between gap-6">
      <div>
        <div className="flex items-center gap-2 text-xl font-semibold tracking-tight text-slate-900">
          {icon}
          <span>{title}</span>
        </div>
        {description ? <div className="mt-2 text-base leading-7 text-slate-600">{description}</div> : null}
      </div>
    </div>
  )
}
