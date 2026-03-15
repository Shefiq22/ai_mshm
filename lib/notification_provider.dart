import 'package:flutter/material.dart';

// ══════════════════════════════════════════════════════════════════════════════
// ── AppNotification model ─────────────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
enum NotificationType {
  riskAlert,
  checkinReminder,
  weeklyTool,
  periodPrediction,
  systemMessage,
  labResult,
}

class AppNotification {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime timestamp;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });
}

// ══════════════════════════════════════════════════════════════════════════════
// ── NotificationsProvider — InheritedNotifier for red-dot badge ───────────────
// ══════════════════════════════════════════════════════════════════════════════
class NotificationsProvider extends InheritedNotifier<NotificationsNotifier> {
  const NotificationsProvider({
    super.key,
    required NotificationsNotifier super.notifier,
    required super.child,
  });

  static NotificationsNotifier of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<NotificationsProvider>();
    if (provider == null) {
      throw FlutterError(
        'NotificationsProvider.of() called with a context that does not '
        'contain a NotificationsProvider.\n'
        'Make sure NotificationsProvider wraps your MaterialApp in main.dart.',
      );
    }
    return provider.notifier!;
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ── NotificationsNotifier — the actual state ──────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
class NotificationsNotifier extends ChangeNotifier {
  final List<AppNotification> _notifications = [
    AppNotification(
      id: '1',
      title: 'Risk Score Updated',
      body: 'Your PCOS risk score has increased to 0.68. Tap to view details.',
      type: NotificationType.riskAlert,
      timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
      isRead: false,
    ),
    AppNotification(
      id: '2',
      title: 'Morning Check-In Due',
      body: 'Don\'t forget to complete your morning check-in for today.',
      type: NotificationType.checkinReminder,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
    ),
    AppNotification(
      id: '3',
      title: 'Weekly Assessment Due',
      body: 'Your mFG Hirsutism Score and PHQ-4 assessments are due this week.',
      type: NotificationType.weeklyTool,
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: false,
    ),
    AppNotification(
      id: '4',
      title: 'Period Predicted in 3 Days',
      body: 'Based on your cycle data, your next period is expected on March 18.',
      type: NotificationType.periodPrediction,
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      isRead: true,
    ),
    AppNotification(
      id: '5',
      title: 'Lab Results Reminder',
      body: 'Your AMH and DHEAS lab results are missing. Adding them improves your risk score accuracy.',
      type: NotificationType.labResult,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    AppNotification(
      id: '6',
      title: 'Welcome to AI-MSHM',
      body: 'Your health monitoring has started. Complete your first check-in to begin tracking.',
      type: NotificationType.systemMessage,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
  ];

  List<AppNotification> get notifications => List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  bool get hasUnread => unreadCount > 0;

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void markAllAsRead() {
    bool changed = false;
    for (final n in _notifications) {
      if (!n.isRead) {
        n.isRead = true;
        changed = true;
      }
    }
    if (changed) notifyListeners();
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }

  // Simulate receiving a new push notification (call this from backend later)
  void addNotification(AppNotification notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }
}