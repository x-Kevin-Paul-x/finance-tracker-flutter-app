# PocketFlow

A beautiful, minimalist personal finance tracker built with Flutter. Visualize your spending habits with intuitive charts, glassmorphic design, and smooth animations.

## Features

- **Smart Dashboard**:
  - Real-time balance updates.
  - "Good Morning/Evening" greeting based on time of day.
  - Glassmorphic UI cards for a premium look.
  - Mini trend chart for quick spending analysis.
- **Transaction Management**:
  - Quick add income/expenses.
  - Categorize transactions with icons and colors.
  - Delete transactions with a long press.
- **Insights**:
  - Visual breakdown of spending by category.
  - Monthly trends.
- **Offline First**:
  - All data stored locally using SQLite.
  - Privacy-focused: no data leaves your device.
- **Customizable**:
  - Light/Dark mode support.
  - Manage categories.

## Screenshots

> *Screenshots are currently unavailable in this repository preview. Please build and run the app to see the Glassmorphic UI in action!*

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/pocketflow.git
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## Architecture & Code Quality

- **State Management**: Uses `Provider` for efficient state management and reactivity.
- **Optimized Performance**:
  - Cached financial totals to reduce calculation overhead (O(1) access for balance).
  - Efficient list rendering.
- **Modern UI**:
  - Custom `GlassContainer` widget for frosted glass effects.
  - Gradient backgrounds and smooth transitions.
- **Robust Error Handling**:
  - centralized error handling in Provider methods.
  - Graceful fallbacks for missing categories or data.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request.

## License

MIT
