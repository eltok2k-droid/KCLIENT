import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "KING CLIENT | ملك التصميم",
  description: "منصة عرض الأعمال وحجز خدمات التصميم وإدارة المشاريع."
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="ar" dir="rtl">
      <body>{children}</body>
    </html>
  );
}
