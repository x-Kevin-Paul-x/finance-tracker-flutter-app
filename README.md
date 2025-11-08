Finance Tracker App - "PocketFlow"
Overview
A beautiful, minimalist personal finance tracker that helps users visualize their spending habits through intuitive charts and insights. Focus on simplicity and delightful UX.
Core Concept
"See where your money flows" - Track income/expenses with smooth animations, smart categories, and instant visual feedback.
Goals

Make finance tracking feel effortless and even enjoyable
Provide instant visual insights (charts, trends)
Work 100% offline (local storage only)
Beautiful, modern UI with smooth animations

Non-Goals

Bank account integration (too complex for v1)
Multi-user/sync features
Investment tracking
Bill reminders/notifications

Key Features
1. Quick Add Transaction

Floating action button for instant entry
Amount → Category → Note (3-tap flow)
Income vs Expense toggle
Haptic feedback on save

2. Smart Dashboard

Current month balance (big, bold number)
Spending by category (donut chart)
Recent transactions (last 10)
Week-over-week trend indicator

3. Category Management

Pre-loaded categories with icons:

🍔 Food & Dining
🚗 Transportation
🏠 Housing
🎮 Entertainment
💰 Income
📱 Subscriptions
🛒 Shopping
💊 Healthcare


Custom categories (add your own)
Color-coded for quick recognition

4. History & Insights

Monthly view with calendar
Filter by category
Search transactions
Export to CSV

5. Visual Analytics

Monthly spending trends (line chart)
Category breakdown (pie/donut chart)
Top spending categories
Income vs Expense comparison

Design Highlights
Color Scheme
Primary: Deep Purple (#6B4CE6)
Income: Green (#10B981)
Expense: Red (#EF4444)
Background: White/Dark mode
Accents: Gradient overlays
Animations

Transaction card slide-in when added
Chart animations on load
Pull-to-refresh with custom indicator
Smooth category selection carousel
Balance number count-up animation

UI Elements

Glassmorphism cards for transactions
Bottom sheet for quick add
Swipe-to-delete on transactions
Haptic feedback throughout
Empty states with friendly illustrations

Technical Stack
Packages Needed
yamldependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.0.0
  
  # Local Storage
  sqflite: ^2.3.0  # SQLite database
  path_provider: ^2.1.0
  
  # Charts
  fl_chart: ^0.65.0
  
  # UI Enhancements
  intl: ^0.18.0  # Date/number formatting
  font_awesome_flutter: ^10.6.0  # Icons
  
  # Utilities
  uuid: ^4.2.0  # Generate unique IDs
Database Schema
sqlCREATE TABLE transactions (
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

## User Flow

### Happy Path
1. Open app → See dashboard with current month balance
2. Tap FAB → Quick add bottom sheet appears
3. Enter amount → Select category → Add note (optional)
4. Tap "Add" → Transaction appears with animation
5. Dashboard updates instantly with new totals
6. Charts refresh automatically

### Analytics Flow
1. Swipe to "Insights" tab
2. See monthly spending chart
3. Tap category in pie chart → See all transactions
4. Filter by date range
5. Export if needed

## File Structure
```
lib/
├── main.dart
├── models/
│   ├── transaction.dart
│   └── category.dart
├── services/
│   ├── database_service.dart
│   └── transaction_service.dart
├── providers/
│   └── finance_provider.dart
├── screens/
│   ├── home_screen.dart
│   ├── insights_screen.dart
│   ├── history_screen.dart
│   └── settings_screen.dart
├── widgets/
│   ├── transaction_card.dart
│   ├── category_selector.dart
│   ├── balance_card.dart
│   ├── chart_widgets/
│   │   ├── donut_chart.dart
│   │   └── line_chart.dart
│   └── add_transaction_sheet.dart
├── utils/
│   ├── constants.dart
│   └── formatters.dart
└── theme/
    └── app_theme.dart
MVP Milestones
Week 1: Core Functionality

 Database setup
 Add/view transactions
 Basic list view
 Category selection

Week 2: UI Polish

 Dashboard design
 Transaction cards
 Animations
 Dark mode

Week 3: Analytics

 Charts integration
 Monthly insights
 Filters
 Export feature

Wow Factors 🚀

Instant Feedback: Every action feels responsive with haptics and animations
Beautiful Charts: Animated, colorful data visualization
Smooth Gestures: Swipe to delete, pull to refresh
Smart Insights: "You spent 30% more on dining this month"
Clean Design: No clutter, just essential info

Future Enhancements (Post-MVP)

Budgets & spending limits
Recurring transactions
Multi-currency support
Cloud backup
Widgets for home screen
Receipt photo attachment
Tags for transactions

## How to run

Run the app from the workspace root. Example (PowerShell):

```powershell
cd 'c:\Users\kevin\OneDrive\Desktop\Projects\FLET\Flutter_Haiku'
flutter pub get
flutter run -d chrome   # or -d windows / -d edge depending on target
```

Notes:
- On web the project uses an in-memory fallback for storage because `sqflite` is not supported on web. Transactions added in the browser will not persist across reloads.
- For desktop (Windows/macOS/Linux) you can add `sqflite_common_ffi` and initialize `databaseFactory = databaseFactoryFfi;` before opening the database to use a SQLite implementation on desktop.

Next steps I can do for you:
- Add charts (fl_chart) and insights screen.
- Persist default categories into the DB and add category management UI.
- Add tests for provider and DB layer.

