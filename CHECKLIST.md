# ✅ Deep Link Setup Checklist

Sử dụng checklist này để theo dõi quá trình setup deep link.

## 🚀 Phase 1: Basic Setup (5 phút)

### Testing Locally
- [ ] Chạy `flutter pub get`
- [ ] Chạy `flutter run`
- [ ] App khởi động thành công
- [ ] Xem HomePage với các test links
- [ ] Tap vào card "Product Link" → Navigate thành công
- [ ] Tap vào card "Promotion Link" → Navigate thành công
- [ ] Back về HomePage → History hiển thị các link

### Testing Deep Links (Custom Scheme)

#### Android
- [ ] Connect Android device/emulator
- [ ] Chạy `./test_deeplinks.sh` hoặc:
- [ ] Test: `adb shell am start -W -a android.intent.action.VIEW -d "demoapp://product/12345"`
- [ ] App mở và hiển thị ProductPage với ID 12345
- [ ] Test: `adb shell am start -W -a android.intent.action.VIEW -d "demoapp://promotion/SUMMER50"`
- [ ] App mở và hiển thị PromotionPage với code SUMMER50

#### iOS
- [ ] Mở Safari trên iOS device/simulator
- [ ] Paste: `demoapp://product/12345`
- [ ] Tap "Go"
- [ ] App mở và navigate đến ProductPage
- [ ] Test với promotion link tương tự

---

## 📤 Phase 2: GitHub Pages (10 phút)

### Push to GitHub
- [ ] Commit tất cả changes: `git add .`
- [ ] Commit: `git commit -m "Add deep link demo"`
- [ ] Push: `git push origin main` hoặc chạy `./deploy.sh`
- [ ] Verify code đã lên GitHub

### Enable GitHub Pages
- [ ] Vào: `https://github.com/Lehuuthanh23/demo-deep-link/settings/pages`
- [ ] Source: **Deploy from a branch**
- [ ] Branch: **main**
- [ ] Folder: **/docs**
- [ ] Click **Save**
- [ ] Đợi 1-2 phút

### Verify Deployment
- [ ] Visit: `https://lehuuthanh23.github.io/demo-deep-link/`
- [ ] Trang hiển thị đầy đủ với test links
- [ ] Check: `https://lehuuthanh23.github.io/demo-deep-link/.well-known/assetlinks.json`
- [ ] File trả về JSON (không 404)
- [ ] Check: `https://lehuuthanh23.github.io/demo-deep-link/.well-known/apple-app-site-association`
- [ ] File trả về JSON (không 404)

### Test from Browser
- [ ] Mở site trên mobile browser
- [ ] Tap link "Product Link"
- [ ] App mở (nếu đã cài)
- [ ] Hoặc redirect page hiển thị và auto-redirect

---

## 🔧 Phase 3: HTTPS Deep Links (30-60 phút) - Optional

> Bỏ qua phase này nếu chỉ dùng custom scheme (demoapp://)

### Android App Links

#### Get SHA-256 Fingerprint
- [ ] Chạy: `./get_sha256.sh`
- [ ] Copy SHA-256 từ output (format: `AA:BB:CC:DD:...`)
- [ ] Remove dấu `:` → `AABBCCDD...`

#### Update assetlinks.json
- [ ] Mở file: `docs/.well-known/assetlinks.json`
- [ ] Paste SHA-256 vào `sha256_cert_fingerprints`
- [ ] Save file
- [ ] Commit: `git add docs/.well-known/assetlinks.json`
- [ ] Commit: `git commit -m "Update Android App Links SHA-256"`
- [ ] Push: `git push`
- [ ] Đợi 1-2 phút để GitHub Pages update

#### Verify Android App Links
- [ ] Reinstall app (để trigger verification)
- [ ] Test HTTPS link:
  ```bash
  adb shell am start -W -a android.intent.action.VIEW \
    -d "https://lehuuthanh23.github.io/demo-deep-link/product/123"
  ```
- [ ] App mở trực tiếp (không qua browser prompt)

### iOS Universal Links

#### Get Apple Team ID
- [ ] Login: https://developer.apple.com/account
- [ ] Membership → Team ID (format: `ABCD123456`)
- [ ] Copy Team ID

#### Update apple-app-site-association
- [ ] Mở file: `docs/.well-known/apple-app-site-association`
- [ ] Replace `YOUR_TEAM_ID` với Team ID thật
- [ ] Save file
- [ ] Commit và push

#### Configure Xcode
- [ ] Mở: `ios/Runner.xcworkspace` bằng Xcode
- [ ] Select project "Runner" → Target "Runner"
- [ ] Tab "Signing & Capabilities"
- [ ] Click "+ Capability"
- [ ] Select "Associated Domains"
- [ ] Add domain: `applinks:lehuuthanh23.github.io`
- [ ] Build lại app

#### Verify iOS Universal Links
- [ ] Xóa app khỏi device
- [ ] Cài lại app (trigger verification)
- [ ] Gửi link qua Notes/Messages: `https://lehuuthanh23.github.io/demo-deep-link/product/456`
- [ ] Long press link → "Open in [App Name]" xuất hiện
- [ ] Tap link → App mở trực tiếp

---

## 🧪 Phase 4: Comprehensive Testing

### Custom Scheme (demoapp://)
- [ ] Product link cơ bản hoạt động
- [ ] Product link với parameters hoạt động
- [ ] Promotion link hoạt động
- [ ] Parameters được parse đúng
- [ ] Navigation giữa các page hoạt động
- [ ] Back button hoạt động

### HTTPS Links (nếu đã config)
- [ ] Product link mở app trực tiếp
- [ ] Promotion link mở app trực tiếp
- [ ] Không hiện "Open with..." dialog
- [ ] Parameters được parse từ GitHub Pages URL

### Edge Cases
- [ ] Link với ID không hợp lệ → App vẫn mở
- [ ] Link với parameters lỗi → App vẫn mở
- [ ] Deep link khi app đang chạy → Navigate đúng page
- [ ] Deep link khi app bị kill → App mở và navigate
- [ ] Deep link spam (tap nhiều lần) → Không crash

---

## 📚 Phase 5: Documentation Review

### Read Documentation
- [ ] Đọc: `README.md` - Project overview
- [ ] Đọc: `QUICKSTART.md` - Quick start
- [ ] Đọc: `GETTING_STARTED.md` - Complete guide
- [ ] (Optional) Đọc: `DEEPLINK_SETUP.md` - Technical details
- [ ] (Optional) Đọc: `FLOW_DIAGRAM.md` - Visual diagrams

### Understand Code
- [ ] Review: `lib/main.dart` - Main app code
- [ ] Understand: `_handleDeepLink()` function
- [ ] Understand: GetX routing logic
- [ ] Review: `android/app/src/main/AndroidManifest.xml`
- [ ] Review: `ios/Runner/Info.plist`

---

## 🎯 Phase 6: Customization (Optional)

### Add Your Own Routes
- [ ] Thêm route mới trong `getPages`
- [ ] Tạo page tương ứng
- [ ] Thêm logic parse trong `_handleDeepLink()`
- [ ] Thêm test link trong HomePage
- [ ] Test deep link cho route mới

### Customize GitHub Pages
- [ ] Sửa màu sắc trong `docs/index.html`
- [ ] Thêm logo/branding
- [ ] Thêm analytics tracking
- [ ] Thêm social sharing buttons

### Production Setup
- [ ] Đổi package name/bundle ID
- [ ] Generate release signing key (Android)
- [ ] Lấy SHA-256 cho release build
- [ ] Update assetlinks.json với release SHA-256
- [ ] Setup Apple Developer account
- [ ] Configure production Team ID
- [ ] Test trên production build

---

## ✅ Final Checklist

### Must Have (Required)
- [x] App compiles và runs
- [x] Custom scheme deep links hoạt động
- [x] Navigation giữa pages hoạt động
- [x] GitHub Pages deployed (có thể access)

### Should Have (Recommended)
- [ ] HTTPS deep links hoạt động (Android)
- [ ] HTTPS deep links hoạt động (iOS)
- [ ] Đã đọc documentation
- [ ] Đã test tất cả scenarios

### Nice to Have (Optional)
- [ ] Custom routes added
- [ ] GitHub Pages customized
- [ ] Production ready
- [ ] Analytics integrated

---

## 📊 Progress Tracker

**Tổng số items:** 100+

**Hoàn thành:**
- Phase 1: __ / 15 items
- Phase 2: __ / 15 items
- Phase 3: __ / 25 items
- Phase 4: __ / 15 items
- Phase 5: __ / 8 items
- Phase 6: __ / 12 items

**Tổng:** __ / 90 items (__ %)

---

## 🎉 Completion

Khi đã tick hết Phase 1 + Phase 2:
```
🎊 Congratulations! 
Deep link demo của bạn đã sẵn sàng!
```

Khi đã tick hết Phase 3:
```
🏆 Expert Level! 
HTTPS deep links hoạt động hoàn hảo!
```

Khi đã tick hết tất cả:
```
🚀 Master Level!
Bạn đã thành thạo Deep Linking!
```

---

**Tip:** Save file này và tick dần khi làm! ✅
