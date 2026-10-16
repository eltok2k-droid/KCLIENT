import Link from "next/link";
import { ArrowRight, ShieldAlert } from "lucide-react";

export default function AdminPage() {
  return <main className="inner-page"><header className="inner-header"><Link href="/" className="brand"><span className="brand-mark">K</span><span><strong>KING CLIENT</strong><small>لوحة الإدارة</small></span></Link><Link href="/" className="back-link"><ArrowRight size={17}/> الرئيسية</Link></header><section className="inner-card"><span className="section-kicker">منطقة الإدارة</span><h1>لوحة الإدارة</h1><div className="notice warning"><ShieldAlert size={20}/><div><strong>لوحة الإدارة غير متصلة بعد</strong><p>لا توجد بيانات إدارية معروضة. يجب إنشاء دور مسؤول والتحقق منه في الخادم وسياسات قاعدة البيانات قبل إظهار أي بيانات.</p></div></div><Link className="gold-button" href="/">العودة للرئيسية</Link></section></main>;
}
