# GitHub Pages - Deep Link Demo

This folder contains the GitHub Pages website for testing deep links.

## 📁 Structure

```
docs/
├── index.html                          # Main demo page
├── product/
│   └── index.html                      # Product redirect page
├── promotion/
│   └── index.html                      # Promotion redirect page
└── .well-known/
    ├── assetlinks.json                 # Android App Links
    └── apple-app-site-association      # iOS Universal Links
```

## 🌐 Live Site

After enabling GitHub Pages, this will be available at:
```
https://lehuuthanh23.github.io/demo-deep-link/
```

## 🔧 Configuration Required

### Android App Links
Edit: `.well-known/assetlinks.json`

1. Get SHA-256 fingerprint: `../get_sha256.sh`
2. Update `sha256_cert_fingerprints` array

### iOS Universal Links
Edit: `.well-known/apple-app-site-association`

1. Get Team ID from: https://developer.apple.com/account
2. Update `appID` field

## 📝 Important Files

### `.nojekyll`
Prevents GitHub Pages from processing this as a Jekyll site.
**Do not delete this file!**

### `.well-known/`
Contains App Links and Universal Links configuration files.
These files MUST be accessible at:
- `https://lehuuthanh23.github.io/demo-deep-link/.well-known/assetlinks.json`
- `https://lehuuthanh23.github.io/demo-deep-link/.well-known/apple-app-site-association`

## 🧪 Testing

Visit the site on mobile device and tap any link to test deep linking.

## 📚 Documentation

See parent folder for complete documentation:
- `../QUICKSTART.md` - Quick start guide
- `../DEEPLINK_SETUP.md` - Complete setup
- `../GITHUB_PAGES_DEPLOY.md` - Deployment guide
