import Link from "next/link";
import { ArrowRight, Wrench } from "lucide-react";

export default async function RequestPage({ searchParams }: { searchParams: Promise<{ service?: string }> }) {
  const { service } = await searchParams;
  const known = ["graphic", "video", "android", "web"].includes(service ?? "");
  return <main className="inner-page"><header className="inner-header"><Link href="/" className="brand"><span className="brand-mark">K</span><span><strong>KING CLIENT</strong><small>ملك التصميم</small></span></Link><Link href="/booking" className="back-link"><ArrowRight size={17}/> الخدمات</Link></header>
    <section className="inner-card">
      <span className="section-kicker">نموذج الطلب</span><h1>نجهّز طلبك بعناية</h1>
      {known ? <><p className="muted">الخدمة المختارة: <strong>{({graphic:"تصميم جرافيك",video:"مونتاج فيديو",android:"تطبيق أندرويد",web:"موقع ويب"} as Record<string,string>)[service!]}</strong></p><div className="notice"><Wrench size={20}/><div><strong>نموذج الحجز الكامل ضمن المرحلة التالية</strong><p>لم يتم إرسال أو حفظ أي طلب بعد. سنربط النموذج بالمصادقة وقاعدة البيانات قبل تفعيل الإرسال، حتى لا تظهر رسالة نجاح غير حقيقية.</p></div></div></> : <p className="muted">اختر خدمة من صفحة الحجز للمتابعة.</p>}
      <Link className="gold-button" href="/booking">العودة لاختيار الخدمة <ArrowRight size={17}/></Link>
    </section>
  </main>;
}
