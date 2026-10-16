import Link from "next/link";
export default function NotFound() {
  return <main className="inner-page"><section className="inner-card"><span className="section-kicker">404</span><h1>الصفحة غير موجودة</h1><p className="muted">تحقق من الرابط أو ارجع إلى الصفحة الرئيسية.</p><Link className="gold-button" href="/">الرئيسية</Link></section></main>;
}
