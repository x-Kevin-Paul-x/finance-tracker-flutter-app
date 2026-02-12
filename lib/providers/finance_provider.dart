import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../services/database_service.dart';

class FinanceProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  final List<TransactionModel> _transactions = [];
  final List<CategoryModel> _categories = [];

  double _balance = 0.0;
  Map<String, double> _cachedCategoryTotals = {};

  // Cache for monthly totals to avoid O(N) iteration on every build
  double _currentMonthExpense = 0.0;
  double _currentMonthIncome = 0.0;

  List<TransactionModel> get transactions => List.unmodifiable(_transactions);
  List<CategoryModel> get categories => List.unmodifiable(_categories);
  double get balance => _balance;
  double get monthlyExpense => _currentMonthExpense;
  double get monthlyIncome => _currentMonthIncome;

  Future<void> init() async {
    try {
      await _loadFromDb();
      _recalculateTotals();
    } catch (e) {
      debugPrint("Error initializing FinanceProvider: $e");
    }
  }

  Future<void> _loadFromDb() async {
    try {
      final txRows = await _db.query('transactions', orderBy: 'date DESC');
      _transactions.clear();
      for (final r in txRows) {
        _transactions.add(TransactionModel.fromMap(r));
      }

      final catRows = await _db.query('categories', orderBy: 'sortOrder');
      _categories.clear();
      if (catRows.isEmpty) {
        // Create default categories
        _categories.addAll([
          CategoryModel(id: 'food', name: 'Food & Dining', icon: '🍔', color: '#F97316', type: 'expense'),
          CategoryModel(id: 'transport', name: 'Transport', icon: '🚗', color: '#60A5FA', type: 'expense'),
          CategoryModel(id: 'housing', name: 'Housing', icon: '🏠', color: '#A78BFA', type: 'expense'),
          CategoryModel(id: 'ent', name: 'Entertainment', icon: '🎮', color: '#F472B6', type: 'expense'),
          CategoryModel(id: 'income', name: 'Income', icon: '💰', color: '#10B981', type: 'income'),
          CategoryModel(id: 'subscriptions', name: 'Subscriptions', icon: '📱', color: '#F97316', type: 'expense'),
        ]);
        for (int i = 0; i < _categories.length; i++) {
          var c = _categories[i];
          await _db.insert('categories', c.toMap(sortOrder: i));
        }
      } else {
        for (final r in catRows) {
          _categories.add(CategoryModel.fromMap(r));
        }
      }
    } catch (e) {
      debugPrint("Error loading from DB: $e");
      rethrow;
    }

    notifyListeners();
  }

  void _recalculateTotals() {
    double total = 0.0;
    double mExpense = 0.0;
    double mIncome = 0.0;

    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1).millisecondsSinceEpoch;
    final end = DateTime(now.year, now.month + 1, 1).millisecondsSinceEpoch;

    _cachedCategoryTotals.clear();

    for (final t in _transactions) {
      // Total Balance
      if (t.type == 'income') {
        total += t.amount;
      } else {
        total -= t.amount;
        // Category Totals (Expenses only for now)
         _cachedCategoryTotals[t.category] = (_cachedCategoryTotals[t.category] ?? 0) + t.amount;
      }

      // Monthly Totals
      if (t.date >= start && t.date < end) {
        if (t.type == 'expense') {
          mExpense += t.amount;
        } else if (t.type == 'income') {
          mIncome += t.amount;
        }
      }
    }

    _balance = total;
    _currentMonthExpense = mExpense;
    _currentMonthIncome = mIncome;
    // We don't call notifyListeners here usually if called from init(),
    // but if called from add/delete we do.
  }

  /// Returns a map of category -> total amount (only expenses counted here)
  Map<String, double> categoryTotals({String type = 'expense'}) {
    // Return cached if we are only asking for expenses.
    // Ideally we should cache by type, but currently only expense breakdown is used.
    if (type == 'expense') {
        return Map.unmodifiable(_cachedCategoryTotals);
    }
    // Fallback for other types or strict recalculation if needed
    final Map<String, double> out = {};
    for (final t in _transactions) {
      if (t.type != type) continue;
      out[t.category] = (out[t.category] ?? 0) + t.amount;
    }
    return out;
  }

  Future<void> addTransaction(TransactionModel tx) async {
    try {
      await _db.insert('transactions', tx.toMap());
      _transactions.insert(0, tx);
      _recalculateTotals();
      notifyListeners();
    } catch (e) {
      debugPrint("Error adding transaction: $e");
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await _db.delete('transactions', 'id = ?', [id]);
      _transactions.removeWhere((t) => t.id == id);
      _recalculateTotals();
      notifyListeners();
    } catch (e) {
       debugPrint("Error deleting transaction: $e");
    }
  }

  Future<void> addCategory(CategoryModel cat) async {
    try {
      await _db.insert('categories', cat.toMap(sortOrder: _categories.length));
      _categories.add(cat);
      notifyListeners();
    } catch (e) {
      debugPrint("Error adding category: $e");
    }
  }

  Future<void> updateCategory(CategoryModel cat) async {
    try {
      await _db.update('categories', cat.toMap(), where: 'id = ?', whereArgs: [cat.id]);
      final idx = _categories.indexWhere((c) => c.id == cat.id);
      if (idx != -1) {
        _categories[idx] = cat;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error updating category: $e");
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      await _db.delete('categories', 'id = ?', [id]);
      _categories.removeWhere((c) => c.id == id);
      notifyListeners();
    } catch (e) {
       debugPrint("Error deleting category: $e");
    }
  }

  Future<void> reorderCategories(int oldIndex, int newIndex) async {
    try {
      final cat = _categories.removeAt(oldIndex);
      _categories.insert(newIndex, cat);
      // Update sortOrder in DB
      for (int i = 0; i < _categories.length; i++) {
        await _db.update('categories', {'sortOrder': i}, where: 'id = ?', whereArgs: [_categories[i].id]);
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error reordering categories: $e");
    }
  }

  // Deprecated: usage replaced by property `monthlyExpense` / `monthlyIncome`
  double monthlyTotal({String? type}) {
    if (type == 'expense') return _currentMonthExpense;
    if (type == 'income') return _currentMonthIncome;

    // Fallback if type is null or something else
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1).millisecondsSinceEpoch;
    final end = DateTime(now.year, now.month + 1, 1).millisecondsSinceEpoch;
    double total = 0;
    for (final t in _transactions) {
      if (t.date >= start && t.date < end) {
        if (type == null || t.type == type) total += t.amount;
      }
    }
    return total;
  }

  Map<int, double> dailyTotals() {
    final Map<int, double> out = {};
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 30));
    for (final t in _transactions) {
      if (t.type != 'expense') continue;
      final date = DateTime.fromMillisecondsSinceEpoch(t.date);
      if (date.isBefore(start)) continue;
      final day = date.day; // Note: this groups by day of month, not absolute date.
                            // For a 30 day trend across months, we might need full date key.
                            // But keeping logic simple as per original for now.
      out[day] = (out[day] ?? 0) + t.amount;
    }
    return out;
  }
}
