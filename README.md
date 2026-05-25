# 💸 PocketFlow

> A beautiful, minimalist personal finance tracker that helps you visualize your spending habits through intuitive charts and insights.

---

## 🌟 Overview
**PocketFlow** is designed to make finance tracking feel effortless and enjoyable. See where your money flows with smooth animations, smart categories, and instant visual feedback.

Our core philosophy: *Simplicity and delightful UX over feature bloat.*

---

## 📸 Screenshots

| Dashboard | Quick Add | Insights |
|:---:|:---:|:---:|
| <img src="https://placehold.co/300x600/6B4CE6/FFFFFF/png?text=Dashboard" width="250" /> | <img src="https://placehold.co/300x600/10B981/FFFFFF/png?text=Quick+Add" width="250" /> | <img src="https://placehold.co/300x600/EF4444/FFFFFF/png?text=Insights" width="250" /> |

*(Note: Replace placeholder images with actual app screenshots)*

---

## ✨ Key Features

### ⚡ Quick Add Transaction
* **Instant Entry:** Floating action button for quick access.
* **3-Tap Flow:** Amount → Category → Note.
* **Smart Toggles:** Easily switch between Income and Expense.
* **Haptic Feedback:** Tactile response on save for a satisfying experience.

### 📊 Smart Dashboard
* **Big Picture:** Current month balance displayed clearly.
* **Visual Breakdown:** Spending by category via an intuitive donut chart.
* **Recent Activity:** Quick glance at your last 10 transactions.
* **Trends:** Week-over-week trend indicator.

### 🗂️ Category Management
* **Pre-loaded Defaults:** Food, Transport, Housing, Entertainment, Income, Subscriptions, Shopping, Healthcare.
* **Customization:** Add your own custom categories.
* **Color-Coded:** For quick visual recognition.

### 📈 History & Insights
* **Calendar View:** Monthly view to track spending over time.
* **Deep Dives:** Filter by category, search transactions, and export to CSV.
* **Visual Analytics:** Monthly spending trends (line chart) and category breakdown (pie/donut chart).

---

## 🎨 Design Highlights

### 🖌️ Color Palette
* **Primary:** Deep Purple (`#6B4CE6`)
* **Income:** Emerald Green (`#10B981`)
* **Expense:** Ruby Red (`#EF4444`)
* **Background:** Clean White / Sleek Dark Mode
* **Accents:** Modern gradient overlays

### 🪄 UI / UX Magic
* **Glassmorphism:** Elegant frosted glass cards for transactions.
* **Fluid Animations:** Card slide-ins, chart loading animations, count-up balances.
* **Intuitive Gestures:** Pull-to-refresh, swipe-to-delete, smooth carousels.

---

## 🛠️ Technical Stack

**Framework:** Flutter
**State Management:** Provider (`^6.0.0`)
**Local Storage:** SQLite via `sqflite` (`^2.3.0`)
**Charts:** `fl_chart` (`^0.65.0`)
**UI & Utils:** `intl`, `font_awesome_flutter`, `uuid`

### Database Schema

```sql
CREATE TABLE transactions (
  id TEXT PRIMARY KEY,
  amount REAL NOT NULL,
  category TEXT NOT NULL,
  type TEXT NOT NULL,  -- 'income' or 'expense'
  note TEXT,
  date INTEGER NOT NULL,  -- Unix timestamp
  created_at INTEGER NOT NULL
);

CREATE TABLE categories (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  icon TEXT NOT NULL,
  color TEXT NOT NULL,
  type TEXT NOT NULL  -- 'income' or 'expense'
);
```

---

## 🚀 Getting Started

To run PocketFlow locally:

1. **Clone the repository.**
2. **Navigate to the workspace root.**
3. **Run the following commands:**

```bash
flutter pub get
flutter run -d chrome   # Or -d windows / -d macos / -d ios / -d android
```

> **Note on Web & Desktop Support:**
> * Web: Uses an in-memory fallback for storage as `sqflite` is not web-supported. Data will reset on reload.
> * Desktop: Add `sqflite_common_ffi` to enable local SQLite storage.

---

## 🛣️ Roadmap

* [ ] Add charts (`fl_chart`) and insights screen.
* [ ] Persist default categories into the DB and add category management UI.
* [ ] Add tests for provider and DB layer.
* [ ] (Post-MVP) Budgets & spending limits.
* [ ] (Post-MVP) Recurring transactions.

---
*Built with ❤️ using Flutter.*
