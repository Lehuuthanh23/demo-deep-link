# 🔗 Hướng dẫn cấu hình Deep Link với GitHub Pages

## 📋 Tổng quan

Deep Link cho phép mở ứng dụng Flutter từ trình duyệt web. Có 2 loại deep link:

1. **Custom URL Scheme** (demoapp://): Đơn giản, hoạt động ngay
2. **Universal Links/App Links** (https://): Phức tạp hơn, cần domain và cấu hình

## 🎯 Mục tiêu

- Link từ web: `https://lehuuthanh23.github.io/demo-deep-link/product/123`
- Mở app Flutter và navigate đến trang Product với ID 123

---

## 📱 1. CẤU HÌNH ANDROID

### 1.1. AndroidManifest.xml (✅ ĐÃ CẤU HÌNH)

File: `android/app/src/main/AndroidManifest.xml`

```xml
<!-- Deep Link: Custom URL Scheme -->
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="demoapp" />
</intent-filter>

<!-- App Links: HTTPS URLs từ GitHub Pages -->
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data 
        android:scheme="https"
        android:host="lehuuthanh23.github.io"
        android:pathPrefix="/demo-deep-link" />
</intent-filter>
```

### 1.2. Lấy SHA-256 Fingerprint (⚠️ CẦN LÀM)

**Debug Build:**
```bash
cd android
./gradlew signingReport
```

Hoặc dùng keytool:
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

**Release Build** (khi có signing key):
```bash
keytool -list -v -keystore /path/to/your-release-key.keystore
```

Lưu lại SHA-256 fingerprint (dạng: `AA:BB:CC:...`)

### 1.3. Cập nhật assetlinks.json

File: `docs/.well-known/assetlinks.json`

Thay `YOUR_SHA256_FINGERPRINT_HERE` bằng SHA-256 thật (remove dấu `:`)

```json
[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "com.example.deep_link_demo",
      "sha256_cert_fingerprints": [
        "AABBCCDD..."
      ]
    }
  }
]
```

---

## 🍎 2. CẤU HÌNH iOS

### 2.1. Info.plist (✅ ĐÃ CẤU HÌNH)

File: `ios/Runner/Info.plist`

```xml
<!-- Deep Link: Custom URL Scheme -->
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLName</key>
        <string>com.example.deepLinkDemo</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>demoapp</string>
        </array>
    </dict>
</array>

<!-- Universal Links: HTTPS URLs -->
<key>FlutterDeepLinkingEnabled</key>
<true/>
```

### 2.2. Xcode Configuration (⚠️ CẦN LÀM)

1. Mở `ios/Runner.xcworkspace` bằng Xcode
2. Chọn project "Runner" → Target "Runner"
3. Tab "Signing & Capabilities"
4. Nhấn "+ Capability" → Chọn "Associated Domains"
5. Thêm domain:
   ```
   applinks:lehuuthanh23.github.io
   ```

### 2.3. Lấy Apple Team ID (⚠️ CẦN LÀM)

1. Vào [Apple Developer](https://developer.apple.com/account)
2. Membership → Team ID (dạng: `ABCD123456`)

### 2.4. Cập nhật apple-app-site-association

File: `docs/.well-known/apple-app-site-association`

Thay `YOUR_TEAM_ID` bằng Team ID thật:

```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "ABCD123456.com.example.deepLinkDemo",
        "paths": [
          "/demo-deep-link/*"
        ]
      }
    ]
  }
}
```

---

## 🌐 3. DEPLOY LÊN GITHUB PAGES

### 3.1. Cấu trúc thư mục `docs/`

```
docs/
├── index.html                          # Trang chủ với test links
├── product/
│   └── index.html                      # Redirect page cho product
├── promotion/
│   └── index.html                      # Redirect page cho promotion
└── .well-known/
    ├── assetlinks.json                 # Android App Links
    └── apple-app-site-association      # iOS Universal Links
```

### 3.2. Push code lên GitHub

```bash
git add .
git commit -m "Add deep link configuration and GitHub Pages"
git push origin main
```

### 3.3. Bật GitHub Pages

1. Vào repo: `https://github.com/Lehuuthanh23/demo-deep-link`
2. Settings → Pages
3. Source: **Deploy from a branch**
4. Branch: **main** → Folder: **/docs** → Save

Đợi 1-2 phút, site sẽ được deploy tại:
```
https://lehuuthanh23.github.io/demo-deep-link/
```

### 3.4. Kiểm tra cấu hình

**Android App Links:**
```
https://lehuuthanh23.github.io/demo-deep-link/.well-known/assetlinks.json
```

**iOS Universal Links:**
```
https://lehuuthanh23.github.io/demo-deep-link/.well-known/apple-app-site-association
```

⚠️ **Quan trọng:** File phải trả về `Content-Type: application/json` và không redirect!

---

## 🧪 4. TEST DEEP LINKS

### 4.1. Custom URL Scheme (Hoạt động ngay)

**Test từ web:**
1. Mở: `https://lehuuthanh23.github.io/demo-deep-link/`
2. Tap vào link: `demoapp://product/12345`
3. App sẽ mở và navigate đến Product page

**Test từ ADB (Android):**
```bash
adb shell am start -W -a android.intent.action.VIEW -d "demoapp://product/12345"
```

**Test từ Safari (iOS):**
1. Paste link vào address bar: `demoapp://product/12345`
2. Tap Go

### 4.2. HTTPS Links (Cần cấu hình đầy đủ)

**Test từ web:**
1. Mở: `https://lehuuthanh23.github.io/demo-deep-link/`
2. Tap vào: `https://lehuuthanh23.github.io/demo-deep-link/product/99`
3. Nếu app đã cài, sẽ mở trực tiếp không qua browser

**Test từ ADB (Android):**
```bash
adb shell am start -W -a android.intent.action.VIEW -d "https://lehuuthanh23.github.io/demo-deep-link/product/99"
```

---

## 📝 5. CÁC TRANG TEST TRÊN GITHUB PAGES

### Trang chủ
```
https://lehuuthanh23.github.io/demo-deep-link/
```
- Hiển thị tất cả test links
- Test custom scheme (demoapp://)
- Test HTTPS links

### Trang Product
```
https://lehuuthanh23.github.io/demo-deep-link/product/123
https://lehuuthanh23.github.io/demo-deep-link/product/456?name=iPhone
```

### Trang Promotion
```
https://lehuuthanh23.github.io/demo-deep-link/promotion/SUMMER50
https://lehuuthanh23.github.io/demo-deep-link/promotion/WINTER25
```

---

## 🔧 6. TROUBLESHOOTING

### Android App Links không hoạt động

1. **Kiểm tra assetlinks.json:**
   ```bash
   curl https://lehuuthanh23.github.io/demo-deep-link/.well-known/assetlinks.json
   ```

2. **Verify SHA-256:**
   ```bash
   cd android && ./gradlew signingReport
   ```

3. **Test bằng Android Studio:**
   - Tools → App Links Assistant
   - Open Digital Asset Links File Generator
   - Test App Links

4. **Clear cache:**
   ```bash
   adb shell pm clear com.google.android.gms
   adb shell pm clear com.example.deep_link_demo
   ```

### iOS Universal Links không hoạt động

1. **Kiểm tra apple-app-site-association:**
   ```bash
   curl https://lehuuthanh23.github.io/demo-deep-link/.well-known/apple-app-site-association
   ```

2. **Verify Team ID & Bundle ID:**
   - Xcode → Runner → Signing & Capabilities
   - Đảm bảo Team ID và Bundle ID đúng

3. **Test với Apple validator:**
   ```
   https://search.developer.apple.com/appsearch-validation-tool/
   ```

4. **Xóa app và cài lại:**
   - iOS cache universal links khi cài app lần đầu
   - Xóa app → Cài lại để refresh

### Custom Scheme không hoạt động

1. **Android:** Kiểm tra AndroidManifest.xml có intent-filter
2. **iOS:** Kiểm tra Info.plist có CFBundleURLTypes
3. **Rebuild app:** `flutter clean && flutter run`

---

## 📚 7. DEMO CODE TRONG APP

File `lib/main.dart` đã được cấu hình để:

✅ Lắng nghe deep links từ custom scheme (`demoapp://`)
✅ Lắng nghe deep links từ HTTPS
✅ Parse URI và navigate đến đúng trang
✅ Xử lý parameters từ URL

**Ví dụ navigation:**
- `demoapp://product/123` → ProductPage với ID 123
- `demoapp://product/123?name=iPhone` → ProductPage với params
- `demoapp://promotion/SUMMER50` → PromotionPage với code SUMMER50

---

## ✅ CHECKLIST

### Bắt buộc (Custom Scheme hoạt động ngay)
- [x] Cấu hình AndroidManifest.xml
- [x] Cấu hình Info.plist
- [x] Code xử lý deep link trong app
- [x] Build và test app

### Tùy chọn (Để HTTPS links hoạt động)
- [ ] Lấy SHA-256 fingerprint (Android)
- [ ] Cập nhật assetlinks.json
- [ ] Lấy Apple Team ID (iOS)
- [ ] Cập nhật apple-app-site-association
- [ ] Cấu hình Associated Domains trong Xcode
- [ ] Deploy lên GitHub Pages
- [ ] Test HTTPS links

---

## 🎓 TÀI LIỆU THAM KHẢO

- [Flutter Deep Linking](https://docs.flutter.dev/ui/navigation/deep-linking)
- [Android App Links](https://developer.android.com/training/app-links)
- [iOS Universal Links](https://developer.apple.com/ios/universal-links/)
- [app_links package](https://pub.dev/packages/app_links)

---

## 🚀 NEXT STEPS

1. ✅ **Test Custom Scheme ngay:**
   ```bash
   flutter run
   # Test link: demoapp://product/12345
   ```

2. **Deploy GitHub Pages:**
   ```bash
   git add docs/
   git commit -m "Add GitHub Pages for deep link testing"
   git push
   # Enable Pages in repo settings
   ```

3. **Cấu hình App Links (tùy chọn):**
   - Lấy SHA-256 fingerprint
   - Cập nhật assetlinks.json
   - Cấu hình iOS Associated Domains
   - Test HTTPS links

---

## 💡 GHI CHÚ

- **Custom Scheme** (`demoapp://`) hoạt động **ngay lập tức** không cần cấu hình thêm
- **HTTPS Links** cần cấu hình đầy đủ nhưng cho UX tốt hơn (không hiện popup chọn app)
- GitHub Pages miễn phí và dễ dùng cho testing
- Production nên dùng domain riêng và HTTPS links

---

Chúc bạn thành công! 🎉
