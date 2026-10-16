import Link from "next/link";
import { ArrowRight, ShieldCheck } from "lucide-react";

export default function LoginPage() {
  return <main className="inner-page"><header className="inner-header"><Link href="/" className="brand"><span className="brand-mark">K</span><span><strong>KING CLIENT</strong><small>ملك التصميم</small></span></Link><Link href="/" className="back-link"><ArrowRight size={17}/> الرئيسية</Link></header>
    <section className="inner-card login-card"><span className="section-kicker">حسابك</span><h1>تسجيل الدخول</h1><p className="muted">سيتم تفعيل تسجيل الدخول بالبريد الإلكتروني وجوجل بعد ربط مشروع Supabase وضبط إعدادات المصادقة.</p><div className="notice"><ShieldCheck size={20}/><div><strong>المصادقة غير مفعلة بعد</strong><p>هذه الصفحة لا تحفظ كلمة المرور ولا تدّعي تسجيل الدخول. أكمل إعداد البيئة حسب ملف README.</p></div></div><Link href="/" className="outline-button full-button">العودة للرئيسية</Link></section>
  </main>;
}
