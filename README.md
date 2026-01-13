# 🔗 Deep Link Demo với Flutter & GetX

Demo ứng dụng Flutter với tích hợp Deep Link, cho phép mở app từ trình duyệt web.

## 🎯 Tính năng

- ✅ Custom URL Scheme: `demoapp://product/123`
- ✅ HTTPS Universal Links: `https://lehuuthanh23.github.io/demo-deep-link/product/123`
- ✅ Navigation với GetX
- ✅ Xử lý parameters từ URL
- ✅ Demo pages: Product, Promotion
- ✅ GitHub Pages để test deep links

## 🚀 Quick Start

### 1. Clone & Install
```bash
git clone https://github.com/Lehuuthanh23/demo-deep-link.git
cd demo-deep-link
flutter pub get
```

### 2. Run App
```bash
flutter run
```

### 3. Test Deep Link

**Custom Scheme (Hoạt động ngay):**
```bash
# Android
adb shell am start -W -a android.intent.action.VIEW -d "demoapp://product/12345"

# iOS (từ Safari)
demoapp://product/12345
```

**Từ web browser:**
Truy cập: `https://lehuuthanh23.github.io/demo-deep-link/`

## 📱 Các loại Deep Link

### Custom URL Scheme
```
demoapp://product/12345
demoapp://product/12345?name=iPhone&price=999
demoapp://promotion/SUMMER50
```

### HTTPS Links (GitHub Pages)
```
https://lehuuthanh23.github.io/demo-deep-link/product/12345
https://lehuuthanh23.github.io/demo-deep-link/promotion/SUMMER50
```

## 📂 Cấu trúc Project

```
lib/
  main.dart                    # App chính với GetX và deep link handler

android/
  app/src/main/
    AndroidManifest.xml        # Cấu hình Android deep links

ios/
  Runner/
    Info.plist                 # Cấu hình iOS deep links

docs/                          # GitHub Pages
  index.html                   # Trang demo với test links
  product/index.html           # Product redirect page
  promotion/index.html         # Promotion redirect page
  .well-known/
    assetlinks.json            # Android App Links
    apple-app-site-association # iOS Universal Links
```

## 🔧 Cấu hình đầy đủ

Xem hướng dẫn chi tiết trong: **[DEEPLINK_SETUP.md](DEEPLINK_SETUP.md)**

### TL;DR:

1. **Custom Scheme** (`demoapp://`): ✅ Hoạt động ngay
2. **HTTPS Links**: ⚠️ Cần thêm:
   - SHA-256 fingerprint (Android)
   - Apple Team ID (iOS)
   - Deploy GitHub Pages

## 🌐 GitHub Pages Demo

Demo site: `https://lehuuthanh23.github.io/demo-deep-link/`

**Cách bật:**
1. Push code lên GitHub
2. Settings → Pages → Source: `main` branch, `/docs` folder
3. Đợi 1-2 phút
4. Truy cập URL để test

## 📦 Dependencies

```yaml
dependencies:
  app_links: ^6.4.1    # Deep linking
  get: ^4.7.3          # State management & navigation
```

## 🧪 Testing

### Test trong app (không cần deploy)
```bash
flutter run
# Trong app, tap vào các test links ở HomePage
```

### Test từ ADB
```bash
# Product
adb shell am start -W -a android.intent.action.VIEW -d "demoapp://product/123"

# Product với parameters
adb shell am start -W -a android.intent.action.VIEW -d "demoapp://product/123?name=iPhone&price=999"

# Promotion
adb shell am start -W -a android.intent.action.VIEW -d "demoapp://promotion/SUMMER50"
```

### Test từ web browser
1. Deploy GitHub Pages (xem DEEPLINK_SETUP.md)
2. Mở: `https://lehuuthanh23.github.io/demo-deep-link/`
3. Tap vào các link để test

## 💡 Lưu ý

- **Custom Scheme** hoạt động **ngay lập tức** trên cả Android và iOS
- **HTTPS Links** cần cấu hình thêm (SHA-256, Team ID) nhưng cho trải nghiệm tốt hơn
- Deep link hoạt động khi app đã cài đặt
- Test trên thiết bị thật để kết quả chính xác nhất

## 📚 Tài liệu

- [DEEPLINK_SETUP.md](DEEPLINK_SETUP.md) - Hướng dẫn chi tiết cấu hình
- [Flutter Deep Linking](https://docs.flutter.dev/ui/navigation/deep-linking)
- [app_links package](https://pub.dev/packages/app_links)

## 🤝 Contributing

Feel free to open issues and pull requests!

## 📄 License

MIT License
