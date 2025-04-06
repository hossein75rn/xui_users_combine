# ترکیب کاربران XUI

**xui_users_combine** ابزاری است برای ترکیب چند کاربر که از یک پورت استفاده می‌کنند در پنل‌های مختلف XUI و نمایش آن‌ها به صورت یک ورودی مشترک در یک سرور مرکزی.

## 🚀 این ابزار چه می‌کند؟

کاربرانی که در پنل‌های مختلف XUI با یک پورت مشابه اضافه شده‌اند را در یک ورودی ترکیب می‌کند و همه آن‌ها را در یک سرور مرکزی نمایش می‌دهد.

## 📁 ساختار پروژه

- فایل‌های `.hrn` (در اصل فایل‌های PHP هستند که برای امنیت تغییر نام داده شده‌اند)
- فایل `xapi.sh`: اسکریپت bash برای اجرا روی سرور مرکزی
- فایل `index.html`: رابط کاربری برای ارسال اطلاعات
- سرور روی پورت **8080** اجرا می‌شود

## 📌 چرا `.hrn` به جای `.php`؟

برای جلوگیری از اجرای ناخواسته فایل‌های PHP در سرورهای عمومی. اگر در محیط امن هستید، آن‌ها را به `.php` تغییر دهید.

## 🧠 استفاده مرکزی

- `xapi.sh` را روی یک سرور اختصاصی اجرا کنید.
- فایل `index.html` را روی همان سرور میزبانی کنید.
- سپس از پورت 8080 استفاده کنید برای دسترسی به پنل مرکزی.

### 🛠️ مراحل نصب

```bash
bash <(curl -sSL https://raw.githubusercontent.com/hossein75rn/xui_users_combine/refs/heads/main/xui/v1/panels/xapi.sh)

```

باز کردن در مرورگر:
`http://your-server-ip:7577`

## 🧪 نحوه استفاده

1. در پنل XUI خود، یک inbound با پورت دلخواه (مثلاً 2095) بسازید.
2. شناسه Inbound را یادداشت کنید.
3. به داشبورد در سرور مرکزی بروید.
4. فرم را به این صورت پر کنید:

| فیلد | توضیح |
|------|-------|
| 1️⃣ | نام کاربری پنل جدید |
| 2️⃣ | رمز عبور پنل |
| 3️⃣ | پسوند سرور (مثل `server1`، می‌شود `hossein server1`) – *در صورت وجود کاربران تکراری الزامی است* |
| 4️⃣ | شناسه Inbound |
| 5️⃣ | JSON خروجی inbound را از پنل قدیمی کپی کرده و اینجا قرار دهید |

5. روی **Submit** کلیک کنید تا کاربران به پنل مرکزی اضافه شوند.

## 🙋‍♂️ مشارکت

در صورت داشتن پیشنهاد یا بهبود، خوشحال می‌شویم pull request ارسال کنید.

## 📜 مجوز

این پروژه تحت مجوز [MIT](LICENSE) ارائه می‌شود.

## 👤 نویسنده

ساخته شده توسط [@hossein75rn](https://github.com/hossein75rn)
