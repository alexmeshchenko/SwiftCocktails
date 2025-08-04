# SwiftCocktails

![Quotoday Banner](Banner.jpeg)

A SwiftUI-based mobile app that lets you discover, search, and save cocktail recipes using the [API Ninjas Cocktail API](https://api-ninjas.com/api/cocktail). Find drinks by name, explore random cocktails, or browse collections by ingredients like Vodka, Rum, and Gin.

Now with detailed instructions and, optionally, thumbnail images from TheCocktailDB.

---

## 🚀 Features

### 🔍 Base
- Search for cocktails by name using the search bar on the main screen  
- Display search results as a clean list with cocktail name and ingredients  
- Tap a cocktail to view full **name**, **ingredients**, and **instructions**


### 💎 Advanced
| Feature | Status |
|:--|:---:|
| 👍 Save favourite cocktails | ✔ in progress via `FavoritesStore` |
| 📋 Ingredient collections & filters | ✔– you can tap on “Vodka”, “Rum”, etc. to explore cocktails |
| 📸 Cocktail thumbnails from TheCocktailDB | ✔ using `AsyncImage` (see below) |


---

## 🧱 Tech Stack & Architecture

- **Swift 6** + **SwiftUI** (iOS 15+)  
- MVVM architecture: `CocktailViewModel`, `CocktailLoaderService`, `CocktailImageService`, `FavoritesStore`  
- Combine / Actors for asynchronous logic and observable state  
- `URLSession` for API calls; leverages built‑in HTTP caching  
- `AsyncImage` for loading and displaying thumbnail images  

---

## 🛠 Setup

1. Clone the repository:
Clone the repository via SSH:
```bash
   git clone git@github.com:alexmeshchenko/SwiftCocktails.git
```

2. Configure API keys
**Config.plist** in your app target’s resources:

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

3. Add this line to your .gitignore:
```bash
Config.plist
```

4. Make sure the file is added to your Xcode project (not checked into Git).

---

## 🚀 What Has Been Implemented?
⚙️ SearchView + CocktailViewModel: submits queries, handles loading and error states

📝 CocktailLoaderService: fetches recipes; decodes name, ingredients, instructions

🖼 CocktailImageService: fetches thumbnail from TheCocktailDB API

🖼 CocktailDetailView: shows recipe details with Async‑loaded thumbnail

---
## 📄 Why Use TheCocktailDB?
* Provides free drink images and data to enhance your UI

* No strict usage caps — unlimited in demo mode

* For publicly released apps, their FAQ expects Patreon support if used commercially

Using images from TheCocktailDB is licensed for app use, as long as you respect their attribution policy and signup requirement for production usage.
---

## 🎯 Next Development Steps
1. 🧾 Favorites

* Implement FavoritesStore using UserDefaults or simple file-based JSON

* Allow toggling favourite status on CocktailDetailView

2. 📌 Ingredient Collections

* On CocktailDetailView, make each ingredient tappable

* Tapping opens a new view (or sheet) listing all cocktails containing that ingredient

* Can cache ingredient-to-items map in-memory or persisted

3. 🔄 Random Cocktail Feature

* Fetch a random suggestion (search with no name parameter)

* Display prominently in SearchView header as a “Lucky!” card

4. 🧵 Concurrency Improvements

* Parallelize fetching of images for all list items using TaskGroup or Combine

* Add image caching layer (Nuke, SDWebImageSwiftUI) to improve lists performance

---

## 🛠 Optional Enhancement Ideas
* Automatically capitalize cocktail names (.capitalized)

* Add .transition(.opacity) to AsyncImage for smoother loading

* Dark mode theme

* Share cocktails via iMessage / social media

* Widget showing “Cocktail of the Day”


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

Keep experimenting — next steps: Favorites + Ingredient collections + Random mode.
Let me know when you want live search debounce (on typing), CoreData sync, or a Swift Package migration!
