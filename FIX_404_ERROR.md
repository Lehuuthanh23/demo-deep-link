# 🔧 Sửa lỗi "404 Not Found" trên GitHub Pages

## ❌ Vấn đề

Khi truy cập URL như:
```
https://lehuuthanh23.github.io/demo-deep-link/product/123
https://lehuuthanh23.github.io/demo-deep-link/promotion/SUMMER50
```

GitHub Pages trả về **404 Not Found** vì không tìm thấy file `/product/123/index.html`.

## ✅ Giải pháp

Tạo file `docs/404.html` - GitHub Pages tự động redirect mọi URL không tồn tại đến file này.

### Cách hoạt động:

```
User truy cập:
https://lehuuthanh23.github.io/demo-deep-link/product/123
        ↓
GitHub Pages không tìm thấy file
        ↓
Tự động load: docs/404.html
        ↓
JavaScript trong 404.html parse URL
        ↓
Extract: resourceType = "product", id = "123"
        ↓
Construct deep link: demoapp://product/123
        ↓
Auto redirect sau 1 giây
        ↓
Mở app (nếu đã cài)
```

## 📝 Đã thực hiện

✅ Tạo file `docs/404.html` với:
- Tự động parse URL path
- Extract resource type (product/promotion) và ID
- Construct deep link tương ứng
- Auto redirect sau 1 giây
- Fallback UI nếu app chưa cài
- Nút manual "Mở App"

## 🧪 Test

### 1. Commit và push code:

```bash
git add docs/404.html
git commit -m "Add 404.html for deep link routing"
git push origin main
```

### 2. Đợi GitHub Pages rebuild (1-2 phút)

### 3. Test trên browser:

```
# Test product link
https://lehuuthanh23.github.io/demo-deep-link/product/123
https://lehuuthanh23.github.io/demo-deep-link/product/456?name=iPhone

# Test promotion link
https://lehuuthanh23.github.io/demo-deep-link/promotion/SUMMER50
https://lehuuthanh23.github.io/demo-deep-link/promotion/WINTER25?discount=50
```

### 4. Kết quả mong đợi:

- ✅ Trang 404.html hiển thị với loader
- ✅ Hiển thị URL hiện tại và deep link sẽ mở
- ✅ Sau 1 giây tự động redirect
- ✅ App mở (nếu đã cài trên mobile)
- ✅ Hoặc hiển thị fallback message

## 📱 Test trên Mobile

### Cách 1: SMS/Message
```
1. Gửi link cho chính mình:
   https://lehuuthanh23.github.io/demo-deep-link/product/123

2. Tap vào link từ SMS/Message app

3. Browser mở → 404.html load → Auto redirect → App mở
```

### Cách 2: Notes/Email
```
1. Paste link vào Notes hoặc Email
2. Tap link
3. Same flow as above
```

### Cách 3: Direct Browser
```
1. Mở Safari/Chrome trên mobile
2. Paste URL vào address bar
3. Tap Go
4. 404.html load → Auto redirect → App mở
```

## 🔍 Debug

Nếu vẫn không hoạt động:

### 1. Kiểm tra 404.html đã deploy chưa:
```bash
curl -I https://lehuuthanh23.github.io/demo-deep-link/404.html

# Nên trả về: HTTP/2 200
```

### 2. Kiểm tra JavaScript console:
```
Mở browser DevTools (F12)
→ Console tab
→ Reload page
→ Xem logs về path parsing và deep link construction
```

### 3. Test deep link thủ công:
```bash
# Nếu 404.html hiển thị đúng deep link
# Copy deep link đó và test trực tiếp:

# Android
adb shell am start -W -a android.intent.action.VIEW -d "demoapp://product/123"

# iOS
Paste vào Safari: demoapp://product/123
```

## 💡 Cải tiến thêm

### Thêm loading state tốt hơn:
Edit `docs/404.html`, thêm:
```javascript
// Show countdown
let countdown = 3;
const countdownInterval = setInterval(() => {
    countdown--;
    if (countdown > 0) {
        document.getElementById('status').innerHTML = 
            `Mở app trong ${countdown}s...`;
    } else {
        clearInterval(countdownInterval);
    }
}, 1000);
```

### Thêm analytics:
```javascript
// Track deep link opens
if (window.gtag) {
    gtag('event', 'deep_link_open', {
        'resource_type': resourceType,
        'resource_id': resourceId
    });
}
```

## 📊 So sánh trước và sau

### ❌ Trước (Không có 404.html):
```
User → https://.../product/123
     → GitHub Pages: 404 Not Found
     → Không mở app
     → User confused ❌
```

### ✅ Sau (Có 404.html):
```
User → https://.../product/123
     → GitHub Pages: Load 404.html
     → Parse URL → Construct deep link
     → Auto redirect to demoapp://product/123
     → App opens ✅
     → Navigate to ProductPage
     → User happy 🎉
```

## 🎯 Best Practices

### 1. Keep 404.html simple
- Nhanh load
- Clear messaging
- Fallback options

### 2. Handle edge cases
```javascript
// Invalid URL format
if (pathSegments.length < 2) {
    // Redirect to home
}

// Unknown resource type
if (!['product', 'promotion'].includes(resourceType)) {
    // Show error or redirect home
}
```

### 3. Mobile-first design
- Large tap targets
- Clear instructions
- Responsive layout

## ✅ Checklist

- [x] Tạo file `docs/404.html`
- [ ] Commit và push
- [ ] Đợi GitHub Pages rebuild
- [ ] Test trên desktop browser
- [ ] Test trên mobile browser
- [ ] Test deep link mở app
- [ ] Test với parameters
- [ ] Verify logs in console

## 🚀 Deploy

```bash
# Quick deploy
git add docs/404.html
git commit -m "Add 404.html for GitHub Pages deep link routing"
git push origin main

# Đợi 1-2 phút
# Test: https://lehuuthanh23.github.io/demo-deep-link/product/123
```

---

**Lưu ý:** File 404.html là tính năng đặc biệt của GitHub Pages. Nó tự động được sử dụng cho mọi URL không tồn tại. Đây là cách phổ biến để implement client-side routing trên static hosting!

Chúc bạn thành công! 🎊
