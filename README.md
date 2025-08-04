# SwiftCocktails
A SwiftUI-based mobile app that lets you discover, search, and save cocktail recipes using the [API Ninjas Cocktail API](https://api-ninjas.com/api/cocktail). Find drinks by name, explore random cocktails, or browse collections by ingredients like Vodka, Rum, and Gin.

---

## 🚀 Features

### 🔍 Base
- Search bar for cocktail names
- Display results in a clean card layout
- Tap on a card to view full recipe and ingredients

### 💎 Advanced
- Save favorite cocktails locally
- Ingredient-based filtering (e.g., show all "Vodka" cocktails)
- Random cocktail suggestion (for the indecisive 🍹)

---

## 🧱 Tech Stack

- **Swift 6**
- **SwiftUI**
- **Combine**
- **URLSession** for API calls
- **MVVM** architecture (with optional extension to TCA if desired)

---

## 🛠 Setup

1. Clone the repository:
Clone the repository via SSH:
```bash
   git clone git@github.com:alexmeshchenko/SwiftCocktails.git
```

2. Open the project in Xcode:
```bash
   open SwiftCocktails.xcodeproj
```

3. Add your API key:

Create a file named Secrets.plist in the project root or in a Resources folder.

Use this format:

```bash
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>API_NINJAS_KEY</key>
    <string>YOUR_API_KEY</string>
</dict>
</plist>
```

4. Make sure the file is added to your Xcode project (not checked into Git).

5. Add this line to your .gitignore:
```bash
Secrets.plist
```

---

## 📸 Screenshots
Placeholder for future UI mockups

---

## 📦 Future plans
Dark Mode support

Share cocktail cards via iMessage or social media

Cocktail of the day widget

Barcode scanning for ingredients?

---

## ⚖️ License
MIT License. See LICENSE for details.

---

## 🍻 Cheers!
Inspired by curiosity and crafted with SwiftUI.
