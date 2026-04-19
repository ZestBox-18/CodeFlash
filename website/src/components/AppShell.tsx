import { type ReactNode } from 'react'
import { useLocation } from 'react-router-dom'
import Footer from '@/components/Footer'
import NavBar from '@/components/NavBar'

export default function AppShell({ children }: { children: ReactNode }) {
  const location = useLocation()
  return (
    <div className="min-h-screen text-slate-900">
      <NavBar />
      <div className="px-4 pb-20 pt-10 md:pt-12">
        <div className="cf-container">
          <div key={location.pathname} className="cf-page">
            {children}
          </div>
        </div>
      </div>
      <Footer />
    </div>
  )
}
