import Link from "next/link";
import { ArrowRight, LockKeyhole } from "lucide-react";
import { siteConfig } from "@/lib/config";

export default function BookingPage() {
  return <main className="inner-page">
    <header className="inner-header"><Link href="/" className="brand"><span className="brand-mark">K</span><span><strong>KING CLIENT</strong><small>ملك التصميم</small></span></Link><Link href="/" className="back-link"><ArrowRight size={17}/> الرئيسية</Link></header>
    <section className="inner-card">
      <span className="section-kicker">ابدأ مشروعك</span><h1>حجز خدمة</h1>
      <p className="muted">اختر الخدمة للانتقال إلى نموذج الطلب. حفظ الطلب النهائي يتطلب إعداد قاعدة البيانات وتسجيل الدخول أولًا.</p>
      <div className="booking-options">{siteConfig.categories.map(s => <Link key={s.key} href={`/booking/request?service=${s.key}`} className="booking-option"><span className="option-number">#{s.number}</span><span><strong>{s.ar}</strong><small>{s.en}</small></span><ArrowRight size={18}/></Link>)}</div>
      <div className="secure-note"><LockKeyhole size={17}/> لن نطلب بيانات دفع حساسة داخل نموذج الحجز.</div>
    </section>
  </main>;
}
