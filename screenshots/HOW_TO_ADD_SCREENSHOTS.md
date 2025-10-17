# 📸 How to Add Screenshots to README

Follow these steps to add screenshots to your GitHub repository:

## 1. Take Screenshots from Your Device

### Method A: Using Android Studio Emulator

1. Run your Flutter app in Android Studio emulator
2. Navigate to each screen you want to capture
3. Click the camera icon in the emulator toolbar
4. Screenshots will be saved to your desktop

### Method B: Using Physical Device (Android)

1. Navigate to the screen
2. Press **Power + Volume Down** simultaneously
3. Connect device to computer via USB
4. Copy images from `DCIM/Screenshots` folder

### Method C: Using iOS Simulator

1. Navigate to the screen
2. Press **Cmd + S** on Mac
3. Screenshots will be saved to desktop

## 2. Required Screenshots

Based on the app features, you need these 6 screenshots:

1. **user_list.png** - Main user management screen
2. **register_user.png** - User registration form
3. **stock_list.png** - Stock management list
4. **monthly_summary.png** - Monthly stock summary
5. **add_transaction.png** - Add transaction screen
6. **heartbeat.png** - Heart beat monitor animation

## 3. Optimize Screenshots

### Resize Images (Recommended: 1080x2400 or similar)

```bash
# Using ImageMagick (install first)
magick convert input.png -resize 1080x2400 output.png

# Or use online tools:
# - https://tinypng.com/ (compress)
# - https://www.iloveimg.com/resize-image (resize)
```

### Rename Files

Rename your screenshots to match the names in README:

- `user_list.png`
- `register_user.png`
- `stock_list.png`
- `monthly_summary.png`
- `add_transaction.png`
- `heartbeat.png`

## 4. Add Screenshots to Repository

### Copy files to screenshots folder:

```bash
# Navigate to project root
cd e:\FLUTTER\eratani

# Copy your screenshots
copy "path\to\your\screenshot.png" "screenshots\"
```

### Or manually:

1. Open Windows Explorer
2. Navigate to `e:\FLUTTER\eratani\screenshots\`
3. Copy all your screenshots here

## 5. Commit and Push to GitHub

```bash
# Add screenshots to git
git add screenshots/*.png

# Commit
git commit -m "Add app screenshots"

# Push to GitHub
git push origin main
```

## 6. Verify on GitHub

1. Go to your GitHub repository
2. Navigate to the README.md
3. Screenshots should now be visible

## Alternative: Use Imgur or Other Image Hosting

If you don't want to commit images to git:

1. Upload screenshots to [Imgur](https://imgur.com)
2. Get direct image links
3. Update README.md with those links:

```markdown
<img src="https://i.imgur.com/yourimage.png" width="250" alt="User List">
```

## Screenshot Guidelines

### Best Practices:

- ✅ Use consistent device/screen size
- ✅ Portrait orientation for mobile apps
- ✅ Show actual data (not lorem ipsum)
- ✅ Clean status bar (or hide it)
- ✅ Consistent time display (e.g., 9:41)
- ✅ Optimize file size (< 500KB each)

### What to Avoid:

- ❌ Different screen sizes mixed
- ❌ Developer debug banners visible
- ❌ Personal information visible
- ❌ Low quality/blurry images
- ❌ Inconsistent UI states

## Quick Reference: Screenshot Names

Copy these names for your files:

```
screenshots/
├── user_list.png           # Main user screen (1st image you attached)
├── register_user.png       # Registration form (2nd image you attached)
├── heartbeat.png           # Heart monitor (3rd image you attached)
├── stock_list.png          # Stock list (4th image you attached)
├── monthly_summary.png     # Monthly summary (5th image you attached)
└── add_transaction.png     # Add transaction (6th image you attached)
```

---

**Need help?** Create an issue in the repository!
