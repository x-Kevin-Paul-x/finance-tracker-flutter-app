import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _db;
  // simple in-memory fallback for web where sqflite isn't available
  final Map<String, List<Map<String, dynamic>>> _memory = {};

  Future<Database> get db async {
    if (kIsWeb) throw StateError('Database not available on web (use memory APIs)');
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  Future<Database> _init() async {
    if (kIsWeb) throw StateError('Database initialization not supported on web');
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'haiku_finance.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        type TEXT NOT NULL,
        note TEXT,
        date INTEGER NOT NULL,
        created_at INTEGER NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE categories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        icon TEXT NOT NULL,
        color TEXT NOT NULL,
        type TEXT NOT NULL,
        sortOrder INTEGER
      );
    ''');
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    if (kIsWeb) {
      _memory.putIfAbsent(table, () => []);
      _memory[table]!.removeWhere((m) => m['id'] == values['id']);
      _memory[table]!.add(Map<String, dynamic>.from(values));
      return 1;
    }
    final database = await db;
    return await database.insert(table, values,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> delete(String table, String where, List<dynamic> args) async {
    if (kIsWeb) {
      if (!_memory.containsKey(table)) return 0;
      final id = args.isNotEmpty ? args[0] : null;
      final before = _memory[table]!.length;
      _memory[table]!.removeWhere((m) => m['id'] == id);
      return before - _memory[table]!.length;
    }
    final database = await db;
    return await database.delete(table, where: where, whereArgs: args);
  }

  Future<int> update(String table, Map<String, dynamic> values, {String? where, List<dynamic>? whereArgs}) async {
    if (kIsWeb) {
      if (!_memory.containsKey(table)) return 0;
      final id = whereArgs?.isNotEmpty == true ? whereArgs![0] : null;
      final idx = _memory[table]!.indexWhere((m) => m['id'] == id);
      if (idx != -1) {
        _memory[table]![idx].addAll(values);
        return 1;
      }
      return 0;
    }
    final database = await db;
    return await database.update(table, values, where: where, whereArgs: whereArgs);
  }

  Future<List<Map<String, dynamic>>> query(String table,
      {String? where, List<dynamic>? whereArgs, String? orderBy}) async {
    if (kIsWeb) {
      final list = _memory[table] ?? [];
      // basic where support for id = ?
      if (where != null && whereArgs != null && whereArgs.isNotEmpty && where.contains('id = ?')) {
        final id = whereArgs[0];
        return list.where((m) => m['id'] == id).map((e) => Map<String, dynamic>.from(e)).toList();
      }
      // orderBy: support 'date DESC'
      final copy = List<Map<String, dynamic>>.from(list);
      if (orderBy != null && orderBy.contains('date')) {
        copy.sort((a, b) => (b['date'] as int).compareTo(a['date'] as int));
      }
      return copy;
    }
    final database = await db;
    return await database.query(table,
        where: where, whereArgs: whereArgs, orderBy: orderBy);
  }
}
