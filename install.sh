#!/bin/bash

# مسیر هدف برای کپی فایل قالب
TARGET_DIR="/var/lib/rebecca/templates/subscription"
# مسیر موقت برای کلون کردن مخزن
TEMP_REPO_DIR="/tmp/liquildGlassy-for-Rebecca"

# رنگ‌ها برای خروجی زیباتر
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}شروع نصب قالب LiquildGlassy برای Rebecca Panel...${NC}"

# 1. بررسی اجرا با دسترسی روت (برای نوشتن در /var/lib)
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}این اسکریپت باید با دسترسی روت (sudo) اجرا شود.${NC}"
   exit 1
fi

# 2. ایجاد پوشه هدف در صورت وجود نداشتن
mkdir -p "$TARGET_DIR"

# 3. حذف پوشه موقت قدیمی (در صورت وجود)
rm -rf "$TEMP_REPO_DIR"

# 4. کلون کردن مخزن
echo -e "${GREEN}در حال دریافت آخرین نسخه قالب از مخزن...${NC}"
git clone https://github.com/im-https/liquildGlassy-for-Rebecca.git "$TEMP_REPO_DIR"

# 5. بررسی موفقیت کلون
if [ $? -ne 0 ]; then
    echo -e "${RED}خطا در کلون کردن مخزن. لطفاً اتصال اینترنت خود را بررسی کنید.${NC}"
    exit 1
fi

# 6. پیدا کردن و کپی کردن فایل index.html
#    بر اساس ساختار، فایل‌های قالب در پوشه themes قرار دارند.
#    ما یک فایل index.html را از اولین پوشه موجود در themes برمی‌داریم.
#    برای سادگی، می‌توانید دقیقاً مشخص کنید از کدام قالب استفاده شود.
#    مثال: از قالب 'liquildGlassy' استفاده می‌کنیم.
THEME_SOURCE="$TEMP_REPO_DIR/themes/liquildGlassy/index.html"

if [ -f "$THEME_SOURCE" ]; then
    echo -e "${GREEN}یافتن فایل قالب در: $THEME_SOURCE${NC}"
    cp "$THEME_SOURCE" "$TARGET_DIR/"
    echo -e "${GREEN}فایل index.html با موفقیت در $TARGET_DIR کپی شد.${NC}"
else
    echo -e "${RED}خطا: فایل index.html در مسیر $THEME_SOURCE یافت نشد.${NC}"
    echo -e "${RED}لطفاً ساختار پوشه‌های پروژه را بررسی کنید.${NC}"
    # پاکسازی و خروج
    rm -rf "$TEMP_REPO_DIR"
    exit 1
fi

# 7. پاکسازی: حذف پوشه موقت
rm -rf "$TEMP_REPO_DIR"
echo -e "${GREEN}پاکسازی انجام شد.${NC}"

# 8. راهنمای نهایی
echo -e "${GREEN}✅ نصب با موفقیت انجام شد!${NC}"
echo "مراحل بعدی:"
echo "1. در پنل Rebecca، به بخش Settings -> Subscriptions بروید."
echo "2. در قسمت 'Custom templates directory'، مسیر زیر را وارد کنید:"
echo "   /var/lib/rebecca/templates"
echo "3. تنظیمات را ذخیره کرده و سرویس پنل را مجدداً راه‌اندازی کنید."
echo "قالب شما در آدرس اشتراک‌گیری قابل مشاهده خواهد بود."

exit 0
