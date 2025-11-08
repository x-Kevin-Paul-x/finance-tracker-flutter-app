import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../services/database_service.dart';

class FinanceProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  final List<TransactionModel> _transactions = [];
  final List<CategoryModel> _categories = [];

  List<TransactionModel> get transactions => List.unmodifiable(_transactions);
  List<CategoryModel> get categories => List.unmodifiable(_categories);

  Future<void> init() async {
    await _loadFromDb();
  }

  Future<void> _loadFromDb() async {
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

    notifyListeners();
  }

  /// Returns a map of category -> total amount (only expenses counted here)
  Map<String, double> categoryTotals({String type = 'expense'}) {
    final Map<String, double> out = {};
    for (final t in _transactions) {
      if (t.type != type) continue;
      out[t.category] = (out[t.category] ?? 0) + t.amount;
    }
    return out;
  }

  Future<void> addTransaction(TransactionModel tx) async {
    await _db.insert('transactions', tx.toMap());
    _transactions.insert(0, tx);
    notifyListeners();
  }

  Future<void> deleteTransaction(String id) async {
    await _db.delete('transactions', 'id = ?', [id]);
    _transactions.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  Future<void> addCategory(CategoryModel cat) async {
    await _db.insert('categories', cat.toMap(sortOrder: _categories.length));
    _categories.add(cat);
    notifyListeners();
  }

  Future<void> updateCategory(CategoryModel cat) async {
    await _db.update('categories', cat.toMap(), where: 'id = ?', whereArgs: [cat.id]);
    final idx = _categories.indexWhere((c) => c.id == cat.id);
    if (idx != -1) {
      _categories[idx] = cat;
      notifyListeners();
    }
  }

  Future<void> deleteCategory(String id) async {
    await _db.delete('categories', 'id = ?', [id]);
    _categories.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  Future<void> reorderCategories(int oldIndex, int newIndex) async {
    final cat = _categories.removeAt(oldIndex);
    _categories.insert(newIndex, cat);
    // Update sortOrder in DB
    for (int i = 0; i < _categories.length; i++) {
      await _db.update('categories', {'sortOrder': i}, where: 'id = ?', whereArgs: [_categories[i].id]);
    }
    notifyListeners();
  }

  double get balance {
    double total = 0.0;
    for (final t in _transactions) {
      total += (t.type == 'income') ? t.amount : -t.amount;
    }
    return total;
  }

  double monthlyTotal({String? type}) {
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
      final day = date.day;
      out[day] = (out[day] ?? 0) + t.amount;
    }
    return out;
  }
}
