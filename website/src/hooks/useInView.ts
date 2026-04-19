import { useEffect, useState, type RefObject } from 'react'

type Options = {
  rootMargin?: string
  threshold?: number | number[]
  once?: boolean
}

export default function useInView<T extends Element>(ref: RefObject<T | null>, options: Options = {}) {
  const [inView, setInView] = useState(false)

  useEffect(() => {
    const el = ref.current
    if (!el) return

    if (typeof window === 'undefined' || typeof IntersectionObserver === 'undefined') {
      setInView(true)
      return
    }

    const observer = new IntersectionObserver(
      (entries) => {
        const entry = entries[0]
        if (!entry) return

        if (entry.isIntersecting) {
          setInView(true)
          if (options.once !== false) observer.disconnect()
        } else if (options.once === false) {
          setInView(false)
        }
      },
      {
        rootMargin: options.rootMargin ?? '0px 0px -10% 0px',
        threshold: options.threshold ?? 0.15,
      },
    )

    observer.observe(el)
    return () => observer.disconnect()
  }, [ref, options.once, options.rootMargin, options.threshold])

  return inView
}

