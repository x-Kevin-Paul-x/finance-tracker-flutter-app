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
    // Load default categories (basic set) and existing rows.
    _loadDefaultCategories();
    await _loadFromDb();
  }

  void _loadDefaultCategories() {
    if (_categories.isNotEmpty) return;
    _categories.addAll([
      CategoryModel(id: 'food', name: 'Food & Dining', icon: '🍔', color: '#F97316', type: 'expense'),
      CategoryModel(id: 'transport', name: 'Transport', icon: '🚗', color: '#60A5FA', type: 'expense'),
      CategoryModel(id: 'housing', name: 'Housing', icon: '🏠', color: '#A78BFA', type: 'expense'),
      CategoryModel(id: 'ent', name: 'Entertainment', icon: '🎮', color: '#F472B6', type: 'expense'),
      CategoryModel(id: 'income', name: 'Income', icon: '💰', color: '#10B981', type: 'income'),
      CategoryModel(id: 'subscriptions', name: 'Subscriptions', icon: '📱', color: '#F97316', type: 'expense'),
    ]);
  }

  Future<void> _loadFromDb() async {
    // Load categories from DB if present (not yet persisting defaults for simplicity)
    final txRows = await _db.query('transactions', orderBy: 'date DESC');
    _transactions.clear();
    for (final r in txRows) {
      _transactions.add(TransactionModel.fromMap(r));
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
}
