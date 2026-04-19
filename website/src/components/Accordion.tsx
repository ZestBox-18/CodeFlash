import { ChevronDown } from 'lucide-react'
import { type ReactNode } from 'react'

export type AccordionItem = {
  id: string
  question: string
  answer: ReactNode
}

export default function Accordion({ items }: { items: AccordionItem[] }) {
  return (
    <div className="space-y-3">
      {items.map((item) => (
        <details
          key={item.id}
          className="group cf-card cf-card-hover px-5 py-4"
        >
          <summary className="flex cursor-pointer list-none items-center justify-between gap-4">
            <span className="text-base font-semibold text-slate-900 md:text-lg">{item.question}</span>
            <ChevronDown className="h-4 w-4 flex-none text-slate-500 transition group-open:rotate-180" />
          </summary>
          <div className="mt-4 text-base leading-7 text-slate-700 md:text-lg md:leading-8">{item.answer}</div>
        </details>
      ))}
    </div>
  )
}
