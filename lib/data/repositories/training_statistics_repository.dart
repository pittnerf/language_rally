// lib/data/repositories/training_statistics_repository.dart
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../models/training_statistics.dart';
import '../models/training_session.dart';
import '../models/training_settings.dart';
import '../models/badge_event.dart';

class TrainingStatisticsRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> saveStatistics(TrainingStatistics stats) async {
    final db = await _dbHelper.database;
    await db.insert(
      'training_statistics',
      _statsToMap(stats),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<TrainingStatistics?> getStatisticsForPackage(String packageId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'training_statistics',
      where: 'package_id = ?',
      whereArgs: [packageId],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return _mapToStats(maps.first);
  }

  Future<void> saveSession(TrainingSession session) async {
    final db = await _dbHelper.database;
    await db.insert(
      'training_sessions',
      _sessionToMap(session),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Map<String, dynamic> _statsToMap(TrainingStatistics stats) {
    return <String, dynamic>{
      'package_id': stats.packageId,
      'total_items_learned': stats.totalItemsLearned,
      'total_items_reviewed': stats.totalItemsReviewed,
      'current_streak': stats.currentStreak,
      'longest_streak': stats.longestStreak,
      'last_trained_at': stats.lastTrainedAt.millisecondsSinceEpoch,
      'average_accuracy': stats.averageAccuracy,
    };
  }

  TrainingStatistics _mapToStats(Map<String, dynamic> map) {
    return TrainingStatistics(
      packageId: map['package_id'] as String,
      totalItemsLearned: (map['total_items_learned'] as int?) ?? 0,
      totalItemsReviewed: (map['total_items_reviewed'] as int?) ?? 0,
      currentStreak: (map['current_streak'] as int?) ?? 0,
      longestStreak: (map['longest_streak'] as int?) ?? 0,
      lastTrainedAt: DateTime.fromMillisecondsSinceEpoch(
        (map['last_trained_at'] as int?) ?? 0,
      ),
      averageAccuracy: ((map['average_accuracy'] as num?) ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> _sessionToMap(TrainingSession session) {
    return <String, dynamic>{
      'id': session.id,
      'package_id': session.packageId,
      'settings': jsonEncode(session.settings.toJson()),
      'item_ids': session.itemIds.join(','), // Store as comma-separated string
      'item_outcomes': session.itemOutcomes.isNotEmpty
          ? jsonEncode(session.itemOutcomes)
          : null,
      'historical_accuracy_ratios': session.historicalAccuracyRatios.isNotEmpty
          ? jsonEncode(session.historicalAccuracyRatios)
          : null,
      'badge_events': session.badgeEvents.isNotEmpty
          ? jsonEncode(session.badgeEvents.map((e) => e.toJson()).toList())
          : null,
      'current_item_index': session.currentItemIndex,
      'started_at': session.startedAt.millisecondsSinceEpoch,
      'completed_at': session.completedAt?.millisecondsSinceEpoch,
      'correct_answers': session.correctAnswers,
      'total_answers': session.totalAnswers,
      'status': session.status.name,
    };
  }

  TrainingSession _mapToSession(Map<String, dynamic> map) {
    // Decode settings
    final settingsJson = jsonDecode(map['settings'] as String) as Map<String, dynamic>;
    final settings = TrainingSettings.fromJson(settingsJson);

    // Decode item outcomes
    List<bool> itemOutcomes = [];
    if (map['item_outcomes'] != null) {
      final decoded = jsonDecode(map['item_outcomes'] as String) as List;
      itemOutcomes = decoded.map((e) => e as bool).toList();
    }

    // Decode historical accuracy ratios
    List<double> historicalAccuracyRatios = [];
    if (map['historical_accuracy_ratios'] != null) {
      final decoded = jsonDecode(map['historical_accuracy_ratios'] as String) as List;
      historicalAccuracyRatios = decoded.map((e) => (e as num).toDouble()).toList();
    }

    // Decode badge events
    List<BadgeEvent> badgeEvents = [];
    if (map['badge_events'] != null) {
      final decoded = jsonDecode(map['badge_events'] as String) as List;
      badgeEvents = decoded
          .map((e) => BadgeEvent.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return TrainingSession(
      id: map['id'] as String,
      packageId: map['package_id'] as String,
      settings: settings,
      itemIds: (map['item_ids'] as String).split(',').where((id) => id.isNotEmpty).toList(),
      itemOutcomes: itemOutcomes,
      historicalAccuracyRatios: historicalAccuracyRatios,
      badgeEvents: badgeEvents,
      currentItemIndex: map['current_item_index'] as int,
      correctAnswers: map['correct_answers'] as int,
      totalAnswers: map['total_answers'] as int,
      startedAt: DateTime.fromMillisecondsSinceEpoch(map['started_at'] as int),
      completedAt: map['completed_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['completed_at'] as int)
          : null,
      status: SessionStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => SessionStatus.active,
      ),
    );
  }

  Future<List<TrainingSession>> getSessionsForPackage(String packageId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'training_sessions',
      where: 'package_id = ?',
      whereArgs: [packageId],
      orderBy: 'started_at DESC',
    );
    return maps.map((map) => _mapToSession(map)).toList();
  }

  Future<TrainingSession?> getSessionById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'training_sessions',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return _mapToSession(maps.first);
  }

  Future<void> updateSession(TrainingSession session) async {
    final db = await _dbHelper.database;
    await db.update(
      'training_sessions',
      _sessionToMap(session),
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }
}