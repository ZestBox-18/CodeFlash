import { type ReactNode, useMemo, useRef } from 'react'
import { cn } from '@/lib/utils'
import useInView from '@/hooks/useInView'

type Props = {
  children: ReactNode
  className?: string
  delayMs?: number
  y?: number
}

export default function Reveal({ children, className, delayMs = 0, y = 12 }: Props) {
  const ref = useRef<HTMLDivElement | null>(null)
  const inView = useInView(ref)

  const style = useMemo(() => {
    return {
      transitionDelay: `${delayMs}ms`,
      ['--cf-reveal-y' as never]: `${y}px`,
    }
  }, [delayMs, y])

  return (
    <div ref={ref} className={cn('cf-reveal', inView && 'is-visible', className)} style={style}>
      {children}
    </div>
  )
}

