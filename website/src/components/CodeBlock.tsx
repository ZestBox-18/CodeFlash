import { Check, Copy } from 'lucide-react'
import { useMemo, useState } from 'react'
import { cn } from '@/lib/utils'

type Props = {
  code: string
  label?: string
  className?: string
}

export default function CodeBlock({ code, label, className }: Props) {
  const [copied, setCopied] = useState(false)
  const normalized = useMemo(() => code.replace(/\n+$/g, ''), [code])

  async function onCopy() {
    try {
      await navigator.clipboard.writeText(normalized)
      setCopied(true)
      window.setTimeout(() => setCopied(false), 1200)
    } catch {
      const el = document.createElement('textarea')
      el.value = normalized
      el.setAttribute('readonly', 'true')
      el.style.position = 'fixed'
      el.style.left = '-9999px'
      document.body.appendChild(el)
      el.select()
      document.execCommand('copy')
      document.body.removeChild(el)
      setCopied(true)
      window.setTimeout(() => setCopied(false), 1200)
    }
  }

  return (
    <div className={cn('cf-card overflow-hidden', className)}>
      <div className="flex items-center justify-between gap-3 border-b border-slate-200/70 bg-slate-50 px-4 py-3">
        <div className="min-w-0 text-[13px] font-semibold uppercase tracking-wide text-slate-500">
          {label ?? '在终端执行'}
        </div>
        <button
          type="button"
          onClick={onCopy}
          className="inline-flex items-center gap-2 rounded-lg border border-slate-200 bg-white px-3 py-1.5 text-xs font-semibold text-slate-700 transition hover:bg-slate-50"
        >
          {copied ? <Check className="h-3.5 w-3.5" /> : <Copy className="h-3.5 w-3.5" />}
          <span>{copied ? '已复制' : '复制'}</span>
        </button>
      </div>
      <pre className="overflow-x-auto px-4 py-3 text-slate-900">
        <code className="cf-code">{normalized}</code>
      </pre>
    </div>
  )
}
