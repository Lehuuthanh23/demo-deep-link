# ⚡ Quick Start Guide - Deep Link Demo

## 🚀 Bắt đầu ngay trong 5 phút

### Bước 1: Run app
```bash
flutter run
```

### Bước 2: Test Deep Link từ trong app
- Mở app → Tap vào các card màu xanh/xanh lá/cam/tím
- Xem navigation hoạt động với GetX

### Bước 3: Test Deep Link từ terminal (Android)
```bash
# Product
adb shell am start -W -a android.intent.action.VIEW -d "demoapp://product/12345"

# Promotion  
adb shell am start -W -a android.intent.action.VIEW -d "demoapp://promotion/SUMMER50"
```

### Bước 4: Test Deep Link từ iOS Safari
- Paste vào Safari: `demoapp://product/12345`
- Tap "Go"
- App sẽ mở

---

## 🌐 Deploy lên GitHub Pages (Optional)

### Setup một lần:
```bash
# 1. Push code
git add .
git commit -m "Add deep link demo"
git push origin main

# 2. Enable GitHub Pages
# Vào: https://github.com/Lehuuthanh23/demo-deep-link/settings/pages
# Source: main branch
# Folder: /docs
# Save

# 3. Đợi 1-2 phút, sau đó truy cập:
# https://lehuuthanh23.github.io/demo-deep-link/
```

### Test từ GitHub Pages:
1. Mở: `https://lehuuthanh23.github.io/demo-deep-link/`
2. Tap vào bất kỳ link nào
3. App sẽ mở (nếu đã cài)

---

## 🔧 Cấu hình HTTPS Links (Advanced)

> ⚠️ Chỉ cần nếu muốn dùng `https://` thay vì `demoapp://`

### Android - Lấy SHA-256:
```bash
./get_sha256.sh
```
→ Copy SHA-256 (bỏ dấu `:`) 
→ Paste vào `docs/.well-known/assetlinks.json`

### iOS - Cấu hình Xcode:
1. Mở `ios/Runner.xcworkspace` 
2. Runner → Signing & Capabilities
3. "+ Capability" → "Associated Domains"
4. Add: `applinks:lehuuthanh23.github.io`
5. Lấy Team ID từ developer.apple.com
6. Update `docs/.well-known/apple-app-site-association`

---

## 📝 Các link test

### Custom Scheme (hoạt động ngay):
```
demoapp://product/123
demoapp://product/456?name=iPhone&price=999
demoapp://promotion/SUMMER50
```

### HTTPS (sau khi config):
```
https://lehuuthanh23.github.io/demo-deep-link/product/123
https://lehuuthanh23.github.io/demo-deep-link/promotion/SUMMER50
```

---

## ✅ Checklist

- [ ] `flutter run` → App chạy OK
- [ ] Test navigation trong app
- [ ] Test deep link với `adb` (Android)
- [ ] Test deep link với Safari (iOS)
- [ ] (Optional) Push code lên GitHub
- [ ] (Optional) Enable GitHub Pages
- [ ] (Optional) Test từ web browser
- [ ] (Advanced) Config SHA-256 & Team ID

---

## 🆘 Troubleshooting

**App không mở khi click link?**
- ✅ Check app đã được cài đặt
- ✅ Rebuild app: `flutter clean && flutter run`
- ✅ Test lại với custom scheme trước: `demoapp://product/123`

**GitHub Pages không hiển thị?**
- ✅ Check Settings → Pages đã enable
- ✅ Đợi 2-3 phút sau khi enable
- ✅ Check có file `docs/.nojekyll`

**HTTPS links không mở app?**
- ✅ Custom scheme hoạt động chưa?
- ✅ SHA-256 đã update vào `assetlinks.json`?
- ✅ Team ID đã update vào `apple-app-site-association`?
- ✅ File .well-known accessible tại URL?

---

## 📚 Đọc thêm

- Chi tiết đầy đủ: [DEEPLINK_SETUP.md](DEEPLINK_SETUP.md)
- Project README: [README.md](README.md)

---

Chúc bạn thành công! 🎉
