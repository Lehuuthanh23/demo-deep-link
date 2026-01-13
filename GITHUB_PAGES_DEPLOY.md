# GitHub Pages Deploy Guide

## Cách 1: Manual Deploy (Khuyến nghị - Đơn giản)

### 1. Push code lên GitHub
```bash
git add .
git commit -m "Add deep link demo with GitHub Pages"
git push origin main
```

### 2. Enable GitHub Pages
1. Vào repository: `https://github.com/Lehuuthanh23/demo-deep-link`
2. Click **Settings** (⚙️)
3. Scroll xuống **Pages** (ở sidebar bên trái)
4. Tại **Source**:
   - Branch: **main**
   - Folder: **/docs**
   - Click **Save**

### 3. Đợi deploy
- GitHub sẽ tự động build và deploy
- Đợi 1-2 phút
- Reload trang, bạn sẽ thấy URL: `https://lehuuthanh23.github.io/demo-deep-link/`

### 4. Kiểm tra
```bash
# Test xem site đã live chưa
curl https://lehuuthanh23.github.io/demo-deep-link/

# Test assetlinks.json (Android)
curl https://lehuuthanh23.github.io/demo-deep-link/.well-known/assetlinks.json

# Test apple-app-site-association (iOS)
curl https://lehuuthanh23.github.io/demo-deep-link/.well-known/apple-app-site-association
```

### 5. Update config files (Quan trọng!)

**Android - assetlinks.json:**
```bash
# Lấy SHA-256
./get_sha256.sh

# Copy output và update vào:
# docs/.well-known/assetlinks.json
```

**iOS - apple-app-site-association:**
1. Lấy Team ID từ https://developer.apple.com/account
2. Update vào: `docs/.well-known/apple-app-site-association`

**Push changes:**
```bash
git add docs/.well-known/
git commit -m "Update App Links & Universal Links config"
git push
```

---

## Cách 2: GitHub Actions (Advanced)

> Tự động deploy mỗi khi push code

### 1. Tạo workflow file
`.github/workflows/deploy-pages.yml`:

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [ main ]
    paths:
      - 'docs/**'
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: true

jobs:
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      
      - name: Setup Pages
        uses: actions/configure-pages@v4
      
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: 'docs'
      
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

### 2. Enable workflow
1. Push workflow file lên GitHub
2. Settings → Pages → Source: **GitHub Actions**
3. Workflow sẽ tự chạy

---

## Custom Domain (Optional)

Nếu có domain riêng (ví dụ: `deeplink.example.com`):

### 1. Cấu hình DNS
Tại nhà cung cấp domain, thêm CNAME record:
```
CNAME: deeplink -> lehuuthanh23.github.io
```

### 2. Cấu hình GitHub Pages
1. Settings → Pages → Custom domain
2. Nhập: `deeplink.example.com`
3. Save
4. Enable **Enforce HTTPS**

### 3. Update config files
**Android - AndroidManifest.xml:**
```xml
<data 
    android:scheme="https"
    android:host="deeplink.example.com" />
```

**Android - assetlinks.json:**
Deploy tại: `https://deeplink.example.com/.well-known/assetlinks.json`

**iOS - Info.plist:**
```xml
<key>Associated Domains</key>
<array>
    <string>applinks:deeplink.example.com</string>
</array>
```

**iOS - apple-app-site-association:**
Deploy tại: `https://deeplink.example.com/.well-known/apple-app-site-association`

---

## Verify Deployment

### Android App Links
```bash
# Test assetlinks.json
curl -I https://lehuuthanh23.github.io/demo-deep-link/.well-known/assetlinks.json

# Should return:
# HTTP/2 200
# content-type: application/json
```

### iOS Universal Links
```bash
# Test apple-app-site-association
curl -I https://lehuuthanh23.github.io/demo-deep-link/.well-known/apple-app-site-association

# Should return:
# HTTP/2 200
# content-type: application/json
```

### Online validators
- **Android:** https://developers.google.com/digital-asset-links/tools/generator
- **iOS:** https://search.developer.apple.com/appsearch-validation-tool/

---

## Troubleshooting

### Page 404 sau khi enable
- Đợi 2-3 phút
- Check branch và folder đã đúng
- Check có file `docs/.nojekyll`

### .well-known files không accessible
- Check có file `docs/.nojekyll`
- Push lại code: `git push`
- Test trực tiếp URL

### App Links không hoạt động
- Verify SHA-256 đã đúng
- Clear Google Play Services cache:
  ```bash
  adb shell pm clear com.google.android.gms
  ```
- Reinstall app

### Universal Links không hoạt động
- Verify Team ID và Bundle ID
- Xóa app và cài lại (iOS cache config khi install)
- Test với Apple validator

---

## Summary Checklist

- [ ] Push code to GitHub
- [ ] Enable GitHub Pages (Settings → Pages)
- [ ] Test site: `https://lehuuthanh23.github.io/demo-deep-link/`
- [ ] Get SHA-256 fingerprint: `./get_sha256.sh`
- [ ] Update `assetlinks.json` with SHA-256
- [ ] Get Apple Team ID from developer.apple.com
- [ ] Update `apple-app-site-association` with Team ID
- [ ] Push config changes
- [ ] Test HTTPS deep links on real device

---

Good luck! 🚀
