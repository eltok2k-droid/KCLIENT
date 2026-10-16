@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"
title KING CLIENT - Setup and Run

echo ========================================
echo        KING CLIENT - تشغيل المشروع
echo ========================================
echo.

where node >nul 2>nul
if errorlevel 1 (
  echo لم يتم العثور على Node.js على هذا الجهاز.
  echo سيتم فتح صفحة التحميل الرسمية. نزّل إصدار LTS وثبّته، ثم أغلق هذه النافذة وافتح هذا الملف مرة أخرى.
  start "" "https://nodejs.org/en/download"
  echo.
  pause
  exit /b 1
)

where npm >nul 2>nul
if errorlevel 1 (
  echo تم العثور على Node.js لكن npm غير متاح. أعد تثبيت إصدار LTS من الموقع الرسمي مع تفعيل Add to PATH.
  start "" "https://nodejs.org/en/download"
  pause
  exit /b 1
)

echo Node.js:
node --version
echo npm:
npm --version
echo.
if not exist ".env.local" (
  echo تنبيه: ملف .env.local غير موجود. انسخ .env.example إلى .env.local وأدخل بيانات Supabase.
  pause
  exit /b 1
)

if not exist "node_modules" (
  echo جاري تثبيت متطلبات المشروع، وقد يستغرق ذلك عدة دقائق...
  call npm install
  if errorlevel 1 (
    echo.
    echo فشل تثبيت المتطلبات. تأكد من اتصال الإنترنت ثم أعد المحاولة.
    pause
    exit /b 1
  )
)

echo.
echo سيتم تشغيل الموقع. اترك هذه النافذة مفتوحة.
echo افتح المتصفح على: http://localhost:3000
echo لاختبار الاتصال: http://localhost:3000/api/health/supabase
echo لإيقاف الموقع اضغط Ctrl+C داخل هذه النافذة.
echo.
call npm run dev
pause
