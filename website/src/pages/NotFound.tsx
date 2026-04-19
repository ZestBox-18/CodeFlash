import { Link } from 'react-router-dom'

export default function NotFound() {
  return (
    <div className="py-16">
      <div className="cf-card p-10">
        <div className="text-2xl font-semibold text-slate-900">页面不存在</div>
        <div className="mt-2 text-base text-slate-600">你访问的页面可能已移动或暂未上线。</div>
        <div className="mt-6">
          <Link
            to="/"
            className="cf-btn-primary"
          >
            返回首页
          </Link>
        </div>
      </div>
    </div>
  )
}
