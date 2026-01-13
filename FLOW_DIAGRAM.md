# 🔄 Deep Link Flow Diagram

## 📱 Luồng hoạt động của Deep Link

### 1️⃣ Custom URL Scheme Flow (demoapp://)

```
┌─────────────────┐
│  Web Browser/   │
│   SMS/Email     │
│                 │
│ User taps link: │
│ demoapp://...   │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────┐
│   Operating System          │
│                             │
│ • Android: Intent System    │
│ • iOS: URL Handler          │
└────────┬────────────────────┘
         │
         ▼
┌─────────────────────────────┐
│   Your Flutter App          │
│                             │
│ • MainActivity (Android)    │
│ • AppDelegate (iOS)         │
└────────┬────────────────────┘
         │
         ▼
┌─────────────────────────────┐
│   app_links package         │
│                             │
│ • Captures URI              │
│ • Triggers stream           │
└────────┬────────────────────┘
         │
         ▼
┌─────────────────────────────┐
│   HomeController            │
│   (_handleDeepLink)         │
│                             │
│ • Parse URI                 │
│ • Extract params            │
│ • Determine route           │
└────────┬────────────────────┘
         │
         ▼
┌─────────────────────────────┐
│   GetX Navigation           │
│                             │
│ • Get.toNamed()             │
│ • Smart routing             │
└────────┬────────────────────┘
         │
         ▼
┌─────────────────────────────┐
│   Target Page               │
│                             │
│ • ProductPage               │
│ • PromotionPage             │
└─────────────────────────────┘
```

---

### 2️⃣ HTTPS Deep Link Flow (https://lehuuthanh23.github.io)

```
┌─────────────────────────────┐
│  User taps HTTPS link       │
│                             │
│  https://lehuuthanh23       │
│  .github.io/demo-deep-link  │
│  /product/123               │
└────────┬────────────────────┘
         │
         ▼
┌─────────────────────────────┐
│   Operating System          │
│   Checks:                   │
│                             │
│ 1. App installed?           │
│ 2. Domain verified?         │
│    (assetlinks.json / AASA) │
└────────┬────────────────────┘
         │
    ┌────┴────┐
    │         │
    ▼         ▼
┌─────┐   ┌──────────┐
│ YES │   │    NO    │
└──┬──┘   └────┬─────┘
   │           │
   │           ▼
   │      ┌──────────────────┐
   │      │  Open Browser    │
   │      │  Show HTML page  │
   │      │  with redirect   │
   │      └──────────────────┘
   │
   ▼
┌─────────────────────────────┐
│   Open App Directly         │
│   (No browser!)             │
│                             │
│   Same flow as Custom       │
│   Scheme from here...       │
└─────────────────────────────┘
```

---

### 3️⃣ GitHub Pages Redirect Flow

```
┌─────────────────────────────┐
│  User visits GitHub Pages   │
│                             │
│  https://lehuuthanh23       │
│  .github.io/demo-deep-link/ │
│  product/123                │
└────────┬────────────────────┘
         │
         ▼
┌─────────────────────────────┐
│   docs/product/index.html   │
│                             │
│ JavaScript extracts:        │
│ • Product ID: 123           │
│ • Query params              │
│                             │
│ Constructs:                 │
│ demoapp://product/123       │
└────────┬────────────────────┘
         │
         ▼
┌─────────────────────────────┐
│   Auto redirect (1 sec)     │
│                             │
│   window.location.href =    │
│   "demoapp://product/123"   │
└────────┬────────────────────┘
         │
         ▼
┌─────────────────────────────┐
│   App Opens                 │
│   (Custom Scheme Flow)      │
└─────────────────────────────┘
```

---

## 🔍 App Links / Universal Links Verification

### Android App Links Verification

```
┌─────────────────────────────────────┐
│  User installs app                  │
└─────────────────┬───────────────────┘
                  │
                  ▼
┌─────────────────────────────────────┐
│  Android OS checks:                 │
│                                     │
│  AndroidManifest.xml:               │
│  • android:autoVerify="true"        │
│  • Host: lehuuthanh23.github.io     │
└─────────────────┬───────────────────┘
                  │
                  ▼
┌─────────────────────────────────────┐
│  OS fetches:                        │
│  https://lehuuthanh23.github.io     │
│  /.well-known/assetlinks.json       │
└─────────────────┬───────────────────┘
                  │
                  ▼
┌─────────────────────────────────────┐
│  Verify:                            │
│  • Package name matches             │
│  • SHA-256 fingerprint matches      │
└─────────────────┬───────────────────┘
                  │
            ┌─────┴─────┐
            │           │
            ▼           ▼
       ┌────────┐  ┌─────────┐
       │  PASS  │  │  FAIL   │
       └────┬───┘  └────┬────┘
            │           │
            ▼           ▼
      ┌─────────┐  ┌──────────────┐
      │ App     │  │ Show "Open   │
      │ opens   │  │ with" dialog │
      │ direct  │  │              │
      └─────────┘  └──────────────┘
```

### iOS Universal Links Verification

```
┌─────────────────────────────────────┐
│  User installs app                  │
└─────────────────┬───────────────────┘
                  │
                  ▼
┌─────────────────────────────────────┐
│  iOS checks:                        │
│                                     │
│  Info.plist:                        │
│  • Associated Domains               │
│  • applinks:lehuuthanh23.github.io  │
└─────────────────┬───────────────────┘
                  │
                  ▼
┌─────────────────────────────────────┐
│  iOS fetches:                       │
│  https://lehuuthanh23.github.io     │
│  /.well-known/                      │
│  apple-app-site-association         │
└─────────────────┬───────────────────┘
                  │
                  ▼
┌─────────────────────────────────────┐
│  Verify:                            │
│  • App ID matches (TeamID.BundleID) │
│  • Paths match                      │
└─────────────────┬───────────────────┘
                  │
            ┌─────┴─────┐
            │           │
            ▼           ▼
       ┌────────┐  ┌─────────┐
       │  PASS  │  │  FAIL   │
       └────┬───┘  └────┬────┘
            │           │
            ▼           ▼
      ┌─────────┐  ┌──────────────┐
      │ App     │  │ Open in      │
      │ opens   │  │ Safari       │
      │ direct  │  │              │
      └─────────┘  └──────────────┘
```

---

## 🎯 Navigation Logic trong App

```
┌─────────────────────────────────────┐
│  Deep Link URI Received             │
│  Example: demoapp://product/123     │
│           ?name=iPhone&price=999    │
└─────────────────┬───────────────────┘
                  │
                  ▼
┌─────────────────────────────────────┐
│  Parse URI Components:              │
│  • Scheme: demoapp                  │
│  • Host: product                    │
│  • Path: /123                       │
│  • Params: {name, price}            │
└─────────────────┬───────────────────┘
                  │
                  ▼
┌─────────────────────────────────────┐
│  Determine Route Type               │
└─────┬───────────────────────────┬───┘
      │                           │
      ▼                           ▼
┌──────────┐               ┌──────────────┐
│ product  │               │  promotion   │
└─────┬────┘               └──────┬───────┘
      │                           │
      ▼                           ▼
┌──────────────────┐    ┌─────────────────────┐
│ route:           │    │ route:              │
│ /product/123     │    │ /promotion/SUMMER50 │
└─────┬────────────┘    └──────┬──────────────┘
      │                        │
      └────────┬───────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Check Current Route                │
└─────┬───────────────────────────────┘
      │
  ┌───┴────┬──────────┬──────────┐
  │        │          │          │
  ▼        ▼          ▼          ▼
┌───┐  ┌────────┐ ┌────────┐ ┌────────┐
│ / │  │/product│ │/promo  │ │ other  │
└─┬─┘  └───┬────┘ └───┬────┘ └───┬────┘
  │        │          │          │
  ▼        ▼          ▼          ▼
┌────┐  ┌─────┐   ┌─────┐   ┌────────┐
│push│  │replace  │replace  │back to │
│    │  │       │ │       │ │home +  │
│    │  │       │ │       │ │push    │
└────┘  └─────┘   └─────┘   └────────┘
  │        │          │          │
  └────────┴──────────┴──────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  GetX Navigation                    │
│  • Get.toNamed()                    │
│  • Get.offNamed()                   │
│  • Get.until() + Get.toNamed()      │
└─────────────────┬───────────────────┘
                  │
                  ▼
┌─────────────────────────────────────┐
│  Render Target Page                 │
│  • ProductPage (ID + params)        │
│  • PromotionPage (code)             │
└─────────────────────────────────────┘
```

---

## 🌐 Complete User Journey

### Scenario 1: User sees link in SMS

```
📱 SMS Message
   │
   │ "Check this product: demoapp://product/12345"
   │
   ▼
👆 User taps link
   │
   ▼
🤖 Android/iOS detects scheme
   │
   ▼
📲 App opens
   │
   ▼
🎯 Navigate to ProductPage(12345)
   │
   ▼
✅ User sees product details
```

### Scenario 2: User visits GitHub Pages

```
🌐 Browser
   │
   │ User visits: https://lehuuthanh23.github.io/demo-deep-link/
   │
   ▼
🎨 Beautiful landing page
   │
   ▼
👆 User taps "Product Link"
   │
   ▼
↗️ Redirect to: demoapp://product/123
   │
   ▼
📲 App opens (if installed)
   │
   ▼
✅ Navigate to ProductPage(123)
```

### Scenario 3: HTTPS link (fully configured)

```
📧 Email / Social Media
   │
   │ Link: https://lehuuthanh23.github.io/demo-deep-link/product/456
   │
   ▼
👆 User taps link
   │
   ▼
🔍 OS checks App Links/Universal Links
   │
   ├─ App installed + Verified → 📲 Open app directly
   │
   └─ Not verified → 🌐 Open browser → Redirect to app
   │
   ▼
✅ ProductPage(456) displayed
```

---

## 🔐 Security & Verification

```
┌─────────────────────────────────────────┐
│  Security Layer                         │
├─────────────────────────────────────────┤
│                                         │
│  1. Domain Verification                 │
│     • assetlinks.json (Android)         │
│     • apple-app-site-association (iOS)  │
│                                         │
│  2. Certificate Matching                │
│     • SHA-256 fingerprint (Android)     │
│     • Team ID + Bundle ID (iOS)         │
│                                         │
│  3. Path Matching                       │
│     • Only specified paths allowed      │
│     • /demo-deep-link/* in our case     │
│                                         │
│  4. Scheme Protection                   │
│     • Custom scheme registered          │
│     • Only our app can handle           │
│                                         │
└─────────────────────────────────────────┘
```

---

## 📊 Decision Tree: Which Deep Link Type?

```
                  Start
                    │
                    ▼
        ┌───────────────────────┐
        │ Do you have a domain? │
        └───────┬───────────────┘
                │
        ┌───────┴───────┐
        │               │
        NO              YES
        │               │
        ▼               ▼
┌────────────────┐  ┌──────────────────┐
│ Custom Scheme  │  │ Want seamless UX?│
│                │  │ (no prompt)      │
│ demoapp://     │  └────────┬─────────┘
│                │           │
│ ✅ Simple      │     ┌─────┴─────┐
│ ✅ Fast setup  │     │           │
│ ⚠️ Shows prompt│     YES         NO
│                │     │           │
└────────────────┘     ▼           ▼
                 ┌──────────┐  ┌──────────┐
                 │ HTTPS    │  │ Custom   │
                 │ Deep Link│  │ Scheme   │
                 │          │  │          │
                 │ App Links│  └──────────┘
                 │ Universal│
                 │ Links    │
                 │          │
                 │ ✅ No prompt   │
                 │ ✅ Professional│
                 │ ⚠️ Complex     │
                 │ ⚠️ Need config │
                 └──────────┘
```

---

## 💡 Quick Reference

### Custom Scheme (demoapp://)
- ✅ **Setup:** 5 minutes
- ✅ **Works:** Immediately  
- ⚠️ **UX:** Shows "Open with..." dialog
- 🎯 **Best for:** Testing, simple apps

### HTTPS Deep Links
- ⚠️ **Setup:** 30-60 minutes
- ⚠️ **Works:** After verification
- ✅ **UX:** Opens directly, no dialog
- 🎯 **Best for:** Production, professional apps

### Our Implementation
- ✅ Supports **both** methods
- ✅ Custom scheme: Ready now
- ⚠️ HTTPS: Need SHA-256 + Team ID
- 🎯 Flexible for all use cases

---

Sơ đồ này giúp bạn hiểu rõ luồng hoạt động! 🎓
