#!/bin/bash

# Script test deep links nhanh

echo "🧪 Deep Link Testing Script"
echo "============================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if device is connected
check_device() {
    if ! command -v adb &> /dev/null; then
        echo -e "${RED}❌ ADB not found. Please install Android SDK${NC}"
        return 1
    fi
    
    DEVICES=$(adb devices | grep -v "List" | grep "device$" | wc -l)
    if [ $DEVICES -eq 0 ]; then
        echo -e "${RED}❌ No Android device connected${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✅ Found $DEVICES Android device(s)${NC}"
    return 0
}

# Test function
test_link() {
    local link=$1
    local description=$2
    
    echo ""
    echo -e "${YELLOW}Testing: $description${NC}"
    echo "Link: $link"
    
    adb shell am start -W -a android.intent.action.VIEW -d "$link" 2>&1 | grep -q "Complete"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Success${NC}"
    else
        echo -e "${RED}❌ Failed${NC}"
    fi
    
    sleep 2
}

# Main
echo "1. Checking Android device..."
if ! check_device; then
    echo ""
    echo -e "${YELLOW}💡 For iOS, test manually in Safari:${NC}"
    echo "   1. Open Safari"
    echo "   2. Paste deep link"
    echo "   3. Tap 'Go'"
    exit 1
fi

echo ""
echo "2. Testing Custom Scheme Links (demoapp://)"
echo "============================================"

test_link "demoapp://product/12345" "Product with ID 12345"
test_link "demoapp://product/67890?name=iPhone&price=999" "Product with parameters"
test_link "demoapp://promotion/SUMMER50" "Promotion code SUMMER50"
test_link "demoapp://promotion/WINTER25?discount=50" "Promotion with discount"

echo ""
echo "3. Testing HTTPS Links (GitHub Pages)"
echo "====================================="
echo -e "${YELLOW}⚠️  These only work after configuring SHA-256 & deploying to GitHub Pages${NC}"

test_link "https://lehuuthanh23.github.io/demo-deep-link/product/123" "GitHub Pages product link"
test_link "https://lehuuthanh23.github.io/demo-deep-link/promotion/NEWYEAR" "GitHub Pages promotion link"

echo ""
echo "✅ Testing completed!"
echo ""
echo "📝 Notes:"
echo "  - Custom scheme (demoapp://) should work immediately"
echo "  - HTTPS links need SHA-256 config + GitHub Pages deployment"
echo ""
echo "🔍 Check app logs with:"
echo "  adb logcat | grep -i 'deep link'"
