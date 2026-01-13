#!/bin/bash

# Script để lấy SHA-256 fingerprint cho Android App Links

echo "🔑 Lấy SHA-256 Fingerprint cho Android App Links"
echo "================================================"
echo ""

# Kiểm tra có debug keystore không
DEBUG_KEYSTORE="$HOME/.android/debug.keystore"

if [ ! -f "$DEBUG_KEYSTORE" ]; then
    echo "❌ Không tìm thấy debug keystore tại: $DEBUG_KEYSTORE"
    echo "   Hãy build app ít nhất 1 lần để tạo debug keystore"
    exit 1
fi

echo "📱 DEBUG KEYSTORE:"
echo "=================="
keytool -list -v -keystore "$DEBUG_KEYSTORE" -alias androiddebugkey -storepass android -keypass android 2>/dev/null | grep "SHA256:" | cut -d " " -f 3

echo ""
echo "📝 Copy SHA-256 ở trên (bỏ dấu ':') và paste vào:"
echo "   docs/.well-known/assetlinks.json"
echo ""
echo "Ví dụ: nếu SHA-256 là AA:BB:CC:DD:EE"
echo "Thì paste: AABBCCDDEE"
echo ""

# Kiểm tra có release keystore không
echo "🔐 RELEASE KEYSTORE (nếu có):"
echo "============================="

RELEASE_KEYSTORE_PATH=""
KEY_PROPERTIES="android/key.properties"

if [ -f "$KEY_PROPERTIES" ]; then
    RELEASE_KEYSTORE_PATH=$(grep "storeFile=" "$KEY_PROPERTIES" | cut -d "=" -f 2)
    KEYSTORE_PASSWORD=$(grep "storePassword=" "$KEY_PROPERTIES" | cut -d "=" -f 2)
    KEY_ALIAS=$(grep "keyAlias=" "$KEY_PROPERTIES" | cut -d "=" -f 2)
    KEY_PASSWORD=$(grep "keyPassword=" "$KEY_PROPERTIES" | cut -d "=" -f 2)
    
    if [ -f "$RELEASE_KEYSTORE_PATH" ]; then
        echo "Tìm thấy release keystore: $RELEASE_KEYSTORE_PATH"
        keytool -list -v -keystore "$RELEASE_KEYSTORE_PATH" -alias "$KEY_ALIAS" -storepass "$KEYSTORE_PASSWORD" -keypass "$KEY_PASSWORD" 2>/dev/null | grep "SHA256:" | cut -d " " -f 3
    else
        echo "Chưa cấu hình release keystore"
    fi
else
    echo "Chưa có key.properties (chưa setup release build)"
fi

echo ""
echo "✅ Done! Copy SHA-256 và cập nhật assetlinks.json"
