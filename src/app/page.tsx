import Link from "next/link";
import { ArrowLeft, Crown, Palette, Clapperboard, Smartphone, Code2, ShieldCheck, Layers3 } from "lucide-react";
import { siteConfig } from "@/lib/config";

const icons = [Palette, Clapperboard, Smartphone, Code2];

export default function HomePage() {
  return (
    <main>
      <header className="topbar">
        <Link href="/" className="brand" aria-label="العودة إلى الرئيسية">
          <span className="brand-mark"><Crown size={25} strokeWidth={1.8} /></span>
          <span><strong>KING CLIENT</strong><small>ملك التصميم</small></span>
        </Link>
        <nav className="desktop-nav" aria-label="التنقل الرئيسي">
          <a href="#services">الخدمات</a><a href="#workflow">كيف نعمل</a><a href="#about">عن المنصة</a>
        </nav>
        <div className="header-actions">
          <Link className="quiet-link" href="/login">تسجيل الدخول</Link>
          <Link className="gold-button small-button" href="/booking">احجز خدمة <ArrowLeft size={16}/></Link>
        </div>
      </header>

      <section className="hero">
        <div className="hero-glow" aria-hidden="true" />
        <div className="hero-content">
          <div className="eyebrow"><span className="gold-dot"/> استوديو إبداعي — من الفكرة إلى التسليم</div>
          <h1>إبداعك يبدأ <span>من هنا</span></h1>
          <p>{siteConfig.descriptionAr}</p>
          <div className="hero-actions">
            <Link className="gold-button" href="/booking">احجز خدمتك <ArrowLeft size={18}/></Link>
            <a className="outline-button" href="#services">استكشف الخدمات</a>
          </div>
          <div className="hero-trust"><ShieldCheck size={17}/> متابعة واضحة للمشروع وملاحظاتك في مكان واحد</div>
        </div>
        <div className="hero-art" aria-label="هوية KING CLIENT">
          <div className="art-ring ring-one"/><div className="art-ring ring-two"/>
          <div className="art-center"><Crown size={76} strokeWidth={1.1}/><strong>K</strong></div>
          <span className="art-caption">DESIGN WITH PURPOSE</span>
        </div>
      </section>

      <section className="services section-wrap" id="services">
        <div className="section-heading">
          <div><span className="section-kicker">خدماتنا</span><h2>كل فكرتك الإبداعية، <span>في مكان واحد</span></h2></div>
          <p>اختر الخدمة المناسبة وابدأ طلبك. تفاصيل السعر النهائي والموعد يتم تأكيدها بعد مراجعة متطلباتك.</p>
        </div>
        <div className="service-grid">
          {siteConfig.categories.map((service, index) => {
            const Icon = icons[index];
            return <Link href={`/booking?service=${service.key}`} className="service-card" key={service.key}>
              <div className="service-card-top"><span className="service-number">#{service.number}</span><span className="service-icon"><Icon size={24}/></span></div>
              <h3>{service.ar}</h3><p>{service.en}</p>
              <span className="card-link">ابدأ طلبك <ArrowLeft size={16}/></span>
            </Link>;
          })}
        </div>
      </section>

      <section className="workflow section-wrap" id="workflow">
        <div className="section-heading compact"><div><span className="section-kicker">خطوات واضحة</span><h2>من أول رسالة حتى <span>التسليم</span></h2></div></div>
        <div className="workflow-grid">
          <div><span>01</span><h3>أرسل طلبك</h3><p>حدد نوع الخدمة والمتطلبات والميزانية المتوقعة.</p></div>
          <div><span>02</span><h3>راجع عرض السعر</h3><p>تستلم السعر النهائي والمدة المقترحة قبل بدء التنفيذ.</p></div>
          <div><span>03</span><h3>تابع مشروعك</h3><p>تتابع تحديثات المعاينة وترسل ملاحظاتك من حسابك.</p></div>
          <div><span>04</span><h3>استلم الملفات</h3><p>تظهر ملفات التسليم وفق حالة المشروع وشروط الدفع.</p></div>
        </div>
      </section>

      <section className="closing section-wrap" id="about">
        <div className="closing-icon"><Layers3 size={28}/></div>
        <div><h2>فكرتك تستحق تنفيذًا يليق بها</h2><p>ابدأ بطلب واضح، وتابع التفاصيل والتعديلات من مكان واحد.</p></div>
        <Link className="gold-button" href="/booking">ابدأ الآن <ArrowLeft size={18}/></Link>
      </section>

      <footer className="footer"><Link href="/" className="footer-brand">KING <span>DESIGNER</span></Link><span>© {new Date().getFullYear()} KING CLIENT</span><span>تصميم باهتمام. تنفيذ باحتراف.</span></footer>
    </main>
  );
}
