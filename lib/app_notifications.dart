import 'package:ai_mshm/notification_provider.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_textstyles.dart';

// ══════════════════════════════════════════════════════════════════════════════
// ── NotificationsScreen ───────────────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 400));
  late final Animation<double> _fade =
      CurvedAnimation(parent: _c, curve: Curves.easeOut);

  @override
  void initState() {
    super.initState();
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  // ── Notification type metadata ────────────────────────────────────────────
  _NotifMeta _metaFor(NotificationType type) {
    switch (type) {
      case NotificationType.riskAlert:
        return _NotifMeta(
          icon: Icons.shield_outlined,
          color: AppColors.riskHigh,
          bg: AppColors.riskHigh.withOpacity(0.1),
          tag: 'Risk Alert',
        );
      case NotificationType.checkinReminder:
        return _NotifMeta(
          icon: Icons.wb_sunny_outlined,
          color: Colors.orange,
          bg: const Color(0xFFFFF3E0),
          tag: 'Check-In',
        );
      case NotificationType.weeklyTool:
        return _NotifMeta(
          icon: Icons.assignment_outlined,
          color: const Color(0xFF1565C0),
          bg: const Color(0xFFE3F2FD),
          tag: 'Weekly Tools',
        );
      case NotificationType.periodPrediction:
        return _NotifMeta(
          icon: Icons.calendar_today_outlined,
          color: const Color(0xFF9C27B0),
          bg: const Color(0xFFF3E5F5),
          tag: 'Cycle',
        );
      case NotificationType.labResult:
        return _NotifMeta(
          icon: Icons.biotech_outlined,
          color: AppColors.primary,
          bg: AppColors.iconBg,
          tag: 'Labs',
        );
      case NotificationType.systemMessage:
        return _NotifMeta(
          icon: Icons.info_outline,
          color: AppColors.textMedium,
          bg: AppColors.surfaceLight,
          tag: 'System',
        );
      default:
        return _NotifMeta(
          icon: Icons.notifications_outlined,
          color: AppColors.textMedium,
          bg: AppColors.surfaceLight,
          tag: 'Notification',
        );
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final notifier = NotificationsProvider.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fade,
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────────────
            Container(
              color: AppColors.surfaceWhite,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: AppColors.textDark, size: 22),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Notifications',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textDark)),
                            AnimatedBuilder(
                              animation: notifier,
                              builder: (_, __) => Text(
                                notifier.hasUnread
                                    ? '${notifier.unreadCount} unread'
                                    : 'All caught up',
                                style: AppTextStyles.smallText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Mark all read button
                      AnimatedBuilder(
                        animation: notifier,
                        builder: (_, __) => notifier.hasUnread
                            ? TextButton(
                                onPressed: () {
                                  notifier.markAllAsRead();
                                },
                                child: Text('Mark all read',
                                    style: AppTextStyles.linkText
                                        .copyWith(fontSize: 13)),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Divider(height: 1, color: AppColors.divider),

            // ── Notification list ──────────────────────────────────────
            Expanded(
              child: AnimatedBuilder(
                animation: notifier,
                builder: (_, __) {
                  final notifications = notifier.notifications;

                  if (notifications.isEmpty) {
                    return _EmptyState();
                  }

                  // Group into unread / earlier
                  final unread =
                      notifications.where((n) => !n.isRead).toList();
                  final read = notifications.where((n) => n.isRead).toList();

                  return ListView(
                    padding: const EdgeInsets.only(bottom: 24),
                    children: [
                      if (unread.isNotEmpty) ...[
                        _SectionHeader(label: 'NEW'),
                        ...unread.map((n) => _NotificationTile(
                              notification: n,
                              meta: _metaFor(n.type),
                              timeAgo: _timeAgo(n.timestamp),
                              onTap: () => notifier.markAsRead(n.id),
                              onDismiss: () =>
                                  notifier.deleteNotification(n.id),
                            )),
                      ],
                      if (read.isNotEmpty) ...[
                        _SectionHeader(label: 'EARLIER'),
                        ...read.map((n) => _NotificationTile(
                              notification: n,
                              meta: _metaFor(n.type),
                              timeAgo: _timeAgo(n.timestamp),
                              onTap: () {},
                              onDismiss: () =>
                                  notifier.deleteNotification(n.id),
                            )),
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Text(label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textLight,
                letterSpacing: 0.8)),
      );
}

// ── Empty state ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.iconBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.notifications_none_outlined,
                  size: 36, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            const Text('No notifications',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark)),
            const SizedBox(height: 6),
            const Text('You\'re all caught up!',
                style: TextStyle(fontSize: 13, color: AppColors.textMedium)),
          ],
        ),
      );
}

// ── Notification tile (swipe to dismiss) ─────────────────────────────────────
class _NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final _NotifMeta meta;
  final String timeAgo;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationTile({
    required this.notification,
    required this.meta,
    required this.timeAgo,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.riskHigh.withOpacity(0.1),
        child: const Icon(Icons.delete_outline,
            color: AppColors.riskHigh, size: 22),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: notification.isRead
                ? AppColors.surfaceWhite
                : AppColors.primary.withOpacity(0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: notification.isRead
                  ? AppColors.cardBorder
                  : AppColors.primary.withOpacity(0.2),
              width: notification.isRead ? 1 : 1.5,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: meta.bg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(meta.icon, color: meta.color, size: 20),
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: meta.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(meta.tag,
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: meta.color)),
                        ),
                        const Spacer(),
                        Text(timeAgo,
                            style: AppTextStyles.smallText
                                .copyWith(fontSize: 11)),
                        // Unread dot
                        if (!notification.isRead) ...[
                          const SizedBox(width: 6),
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(notification.title,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.w700,
                            color: AppColors.textDark)),
                    const SizedBox(height: 3),
                    Text(notification.body,
                        style: AppTextStyles.cardSubtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Notification metadata ─────────────────────────────────────────────────────
class _NotifMeta {
  final IconData icon;
  final Color color;
  final Color bg;
  final String tag;
  const _NotifMeta(
      {required this.icon,
      required this.color,
      required this.bg,
      required this.tag});
}

// ══════════════════════════════════════════════════════════════════════════════
// ── NotificationBadge — the bell icon with red dot for dashboard ──────────────
// ══════════════════════════════════════════════════════════════════════════════
class NotificationBadge extends StatelessWidget {
  final VoidCallback onTap;

  const NotificationBadge({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final notifier = NotificationsProvider.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: notifier,
        builder: (_, __) => Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.notifications_outlined,
                color: AppColors.textDark, size: 26),

            // ── Red dot badge ─────────────────────────────────────────
            if (notifier.hasUnread)
              Positioned(
                top: -2,
                right: -2,
                child: AnimatedScale(
                  scale: notifier.hasUnread ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.elasticOut,
                  child: Container(
                    width: notifier.unreadCount > 9 ? 18 : 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53E3E),
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        notifier.unreadCount > 9
                            ? '9+'
                            : '${notifier.unreadCount}',
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}