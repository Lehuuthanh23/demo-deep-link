#!/bin/bash

# Script để push deep link demo lên GitHub và enable Pages

echo "🚀 Deploying Deep Link Demo to GitHub"
echo "======================================"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Step 1: Git status
echo -e "${BLUE}📋 Step 1: Checking git status...${NC}"
git status --short

echo ""
read -p "Do you want to add all files? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    git add .
    echo -e "${GREEN}✅ Files added${NC}"
fi

# Step 2: Commit
echo ""
echo -e "${BLUE}📦 Step 2: Committing changes...${NC}"
read -p "Enter commit message (or press Enter for default): " COMMIT_MSG

if [ -z "$COMMIT_MSG" ]; then
    COMMIT_MSG="Add deep link configuration with GitHub Pages demo"
fi

git commit -m "$COMMIT_MSG"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Committed successfully${NC}"
else
    echo -e "${YELLOW}⚠️  No changes to commit or commit failed${NC}"
fi

# Step 3: Push
echo ""
echo -e "${BLUE}🚀 Step 3: Pushing to GitHub...${NC}"
read -p "Push to origin main? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    git push origin main
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Pushed successfully${NC}"
    else
        echo -e "${YELLOW}⚠️  Push failed. Check your remote configuration.${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}⚠️  Skipped push${NC}"
    exit 0
fi

# Step 4: Instructions for GitHub Pages
echo ""
echo -e "${GREEN}✅ Code pushed to GitHub!${NC}"
echo ""
echo -e "${BLUE}📚 Next Steps:${NC}"
echo ""
echo "1. Enable GitHub Pages:"
echo "   👉 https://github.com/Lehuuthanh23/demo-deep-link/settings/pages"
echo ""
echo "2. Configure GitHub Pages:"
echo "   - Source: Deploy from a branch"
echo "   - Branch: main"
echo "   - Folder: /docs"
echo "   - Click 'Save'"
echo ""
echo "3. Wait 1-2 minutes, then visit:"
echo "   👉 https://lehuuthanh23.github.io/demo-deep-link/"
echo ""
echo "4. Update App Links config:"
echo "   📱 Android: ./get_sha256.sh"
echo "   🍎 iOS: Get Team ID from developer.apple.com"
echo ""
echo -e "${YELLOW}💡 Tip: Run './test_deeplinks.sh' to test deep links${NC}"
echo ""
