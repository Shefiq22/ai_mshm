import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_textstyles.dart';
import 'routes.dart';

// ─────────────────────────────────────────────
//  PROFILE SCREEN
// ─────────────────────────────────────────────
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? const BackButton(color: AppColors.textDark)
            : null,
        automaticallyImplyLeading: true,
        title: Text('My Profile', style: AppTextStyles.screenTitle),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.textDark),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.privacy),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── User Header ──
            Container(
              color: AppColors.surfaceWhite,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary.withOpacity(0.15),
                    child: const Text(
                      'SJ',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sarah Johnson', style: AppTextStyles.greetingName),
                        const SizedBox(height: 2),
                        Text('sarah.johnson@email.com', style: AppTextStyles.cardSubtitle),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.cardBorder),
                              ),
                              child: Text('Patient', style: AppTextStyles.smallText),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Member since January 2024',
                                style: AppTextStyles.smallText,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.inputBorder),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text('Edit', style: AppTextStyles.inputLabel),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ── Demographics ──
            _sectionLabel('Demographics'),
            _ProfileCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      _DemoTile(icon: Icons.calendar_today_outlined, label: 'Age', value: '28 years'),
                      const SizedBox(width: 16),
                      _DemoTile(icon: Icons.person_outline, label: 'Ethnicity', value: 'White'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _DemoTile(icon: Icons.straighten_outlined, label: 'Height', value: '165 cm'),
                      const SizedBox(width: 16),
                      _DemoTile(icon: Icons.monitor_weight_outlined, label: 'Weight', value: '62 kg'),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(height: 1, color: AppColors.divider),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.show_chart, color: AppColors.primary, size: 16),
                      const SizedBox(width: 8),
                      Text('BMI', style: AppTextStyles.cardSubtitle),
                      const Spacer(),
                      Text('22.8',
                          style: AppTextStyles.cardTitle
                              .copyWith(fontSize: 16, color: AppColors.textDark)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('Normal',
                            style: AppTextStyles.smallText.copyWith(
                                color: const Color(0xFF2E7D32),
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ── Wearable Connections ──
            _sectionLabel('Wearable Connections'),
            _ProfileCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.textDark,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.watch_outlined,
                            color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Apple Watch',
                                style: AppTextStyles.activityTitle
                                    .copyWith(fontSize: 14)),
                            const SizedBox(height: 2),
                            Text('Last synced 2 hours ago',
                                style: AppTextStyles.smallText),
                          ],
                        ),
                      ),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2ECC71),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.devices),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 44),
                      side: const BorderSide(color: AppColors.inputBorder),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('Manage Devices',
                        style: AppTextStyles.inputLabel),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ── Data Completeness ──
            _sectionLabel('Data Completeness Overview'),
            _ProfileCard(
              child: Row(
                children: [
                  SizedBox(
                    width: 90,
                    height: 90,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 90,
                          height: 90,
                          child: CircularProgressIndicator(
                            value: 0.78,
                            strokeWidth: 9,
                            backgroundColor:
                                AppColors.primary.withOpacity(0.15),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.primary),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('78%',
                                style: AppTextStyles.cardTitle
                                    .copyWith(fontSize: 18)),
                            Text('Complete',
                                style: AppTextStyles.smallText
                                    .copyWith(fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: const [
                        _CompletionRow(
                            label: 'Profile Info',
                            value: 1.0,
                            color: Color(0xFF2ECC71)),
                        SizedBox(height: 8),
                        _CompletionRow(
                            label: 'Clinical Data',
                            value: 0.65,
                            color: AppColors.primary),
                        SizedBox(height: 8),
                        _CompletionRow(
                            label: 'Wearable Sync',
                            value: 0.82,
                            color: Color(0xFF3A7BD5)),
                        SizedBox(height: 8),
                        _CompletionRow(
                            label: 'Check-ins',
                            value: 0.64,
                            color: Color(0xFFF5A623)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ── Settings Menu ──
            _ProfileCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _SettingsRow(
                    icon: Icons.notifications_outlined,
                    label: 'Notification Settings',
                    subtitle: 'Check-in reminders & alerts',
                    onTap: () => Navigator.pushNamed(
                        context, AppRoutes.notifications),
                  ),
                  const Divider(
                      height: 1, indent: 56, color: AppColors.divider),
                  _SettingsRow(
                    icon: Icons.watch_outlined,
                    label: 'Connected Devices',
                    subtitle: 'Manage wearable integrations',
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.devices),
                  ),
                  const Divider(
                      height: 1, indent: 56, color: AppColors.divider),
                  _SettingsRow(
                    icon: Icons.shield_outlined,
                    label: 'Data & Privacy',
                    subtitle: 'Manage your data and consent',
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.privacy),
                  ),
                  const Divider(
                      height: 1, indent: 56, color: AppColors.divider),
                  _SettingsRow(
                    icon: Icons.description_outlined,
                    label: 'Export Reports',
                    subtitle: 'Download your health summary',
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.clinicalPdf),
                  ),
                  const Divider(
                      height: 1, indent: 56, color: AppColors.divider),
                  _SettingsRow(
                    icon: Icons.help_outline,
                    label: 'Help & Support',
                    subtitle: 'FAQs and contact support',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ── Logout ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    title: const Text('Log Out'),
                    content:
                        const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                            context, AppRoutes.login),
                        child: Text('Log Out',
                            style: TextStyle(color: AppColors.riskHigh)),
                      ),
                    ],
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: AppColors.riskHigh, size: 18),
                      const SizedBox(width: 8),
                      Text('Log Out',
                          style: AppTextStyles.featureTitle
                              .copyWith(color: AppColors.riskHigh)),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            Text('AI-MSHM v1.0.0', style: AppTextStyles.smallText),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textLight,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  NOTIFICATION SETTINGS SCREEN
// ─────────────────────────────────────────────
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  String _morningTime = '08:00';
  String _eveningTime = '20:00';
  bool _morning = true;
  bool _evening = true;
  bool _weekly = true;
  bool _period = true;
  bool _risk = true;
  bool _wearable = false;
  bool _dnd = false;
  bool _saved = false;

  final List<String> _morningTimes = [
    for (int h = 6; h <= 10; h++)
      for (int m in [0, 30])
        if (!(h == 10 && m == 30))
          '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}'
  ];

  final List<String> _eveningTimes = [
    for (int h = 18; h <= 22; h++)
      for (int m in [0, 30])
        if (!(h == 22 && m == 30))
          '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}'
  ];

  void _showTimePicker(
      BuildContext context, String current, List<String> times, ValueChanged<String> onSelect) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SizedBox(
        height: 300,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.cardBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: times.length,
                itemBuilder: (_, i) {
                  final t = times[i];
                  final selected = t == current;
                  return ListTile(
                    title: Text(t,
                        style: TextStyle(
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: selected
                              ? AppColors.primary
                              : AppColors.textDark,
                        )),
                    trailing: selected
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                    tileColor: selected
                        ? AppColors.primary.withOpacity(0.08)
                        : null,
                    onTap: () {
                      onSelect(t);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        elevation: 0,
        leading: const BackButton(color: AppColors.textDark),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notification Settings', style: AppTextStyles.screenTitle),
            Text('Manage your reminders and alerts',
                style: AppTextStyles.smallText),
          ],
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionLabel('Check-in Reminder Times'),
                _ProfileCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _TimeRow(
                        icon: Icons.wb_sunny_outlined,
                        iconColor: const Color(0xFFF5A623),
                        iconBg: const Color(0xFFFFFBF0),
                        label: 'Morning Check-In',
                        subtitle: 'When to remind you',
                        time: _morningTime,
                        onTap: () => _showTimePicker(
                            context, _morningTime, _morningTimes,
                            (v) => setState(() => _morningTime = v)),
                      ),
                      const Divider(height: 1, color: AppColors.divider),
                      _TimeRow(
                        icon: Icons.nightlight_round,
                        iconColor: const Color(0xFF5B6FBE),
                        iconBg: const Color(0xFFEEF0FF),
                        label: 'Evening Check-In',
                        subtitle: 'When to remind you',
                        time: _eveningTime,
                        onTap: () => _showTimePicker(
                            context, _eveningTime, _eveningTimes,
                            (v) => setState(() => _eveningTime = v)),
                      ),
                    ],
                  ),
                ),
                _sectionLabel('Notification Types'),
                _ProfileCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _NotifRow(
                        icon: Icons.wb_sunny_outlined,
                        label: 'Morning Check-In Reminder',
                        subtitle: 'Daily reminder to complete your morning check-in',
                        value: _morning,
                        onChanged: (v) => setState(() => _morning = v),
                      ),
                      const Divider(height: 1, indent: 56, color: AppColors.divider),
                      _NotifRow(
                        icon: Icons.nightlight_round,
                        label: 'Evening Check-In Reminder',
                        subtitle: 'Daily reminder to complete your evening check-in',
                        value: _evening,
                        onChanged: (v) => setState(() => _evening = v),
                      ),
                      const Divider(height: 1, indent: 56, color: AppColors.divider),
                      _NotifRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Weekly Tool Prompts',
                        subtitle: 'Reminders for mFG scoring and PHQ-4 assessment',
                        value: _weekly,
                        onChanged: (v) => setState(() => _weekly = v),
                      ),
                      const Divider(height: 1, indent: 56, color: AppColors.divider),
                      _NotifRow(
                        icon: Icons.show_chart,
                        label: 'Period Tracking Alerts',
                        subtitle: 'Predictions and reminders for cycle tracking',
                        value: _period,
                        onChanged: (v) => setState(() => _period = v),
                      ),
                      const Divider(height: 1, indent: 56, color: AppColors.divider),
                      _NotifRow(
                        icon: Icons.warning_amber_outlined,
                        label: 'Risk Score Updates',
                        subtitle: 'Notifications when your risk score changes significantly',
                        value: _risk,
                        onChanged: (v) => setState(() => _risk = v),
                      ),
                      const Divider(height: 1, indent: 56, color: AppColors.divider),
                      _NotifRow(
                        icon: Icons.access_time_outlined,
                        label: 'Wearable Sync Reminders',
                        subtitle: "Alerts when wearable data hasn't synced recently",
                        value: _wearable,
                        onChanged: (v) => setState(() => _wearable = v),
                      ),
                    ],
                  ),
                ),
                _sectionLabel('Quiet Hours'),
                _ProfileCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _NotifRow(
                        icon: Icons.do_not_disturb_on_outlined,
                        label: 'Do Not Disturb',
                        subtitle: 'Pause all notifications',
                        value: _dnd,
                        onChanged: (v) => setState(() => _dnd = v),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "When enabled, you won't receive any notifications between 10:00 PM and 7:00 AM. Critical risk alerts will still come through.",
                            style: AppTextStyles.smallText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.primary.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.notifications_outlined,
                            color: AppColors.primary, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Push notifications require permission from your device. Make sure notifications are enabled in your device settings for AI-MSHM.',
                            style: AppTextStyles.smallText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: AppColors.surfaceWhite,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: ElevatedButton(
                onPressed: () {
                  setState(() => _saved = true);
                  Future.delayed(const Duration(seconds: 2),
                      () => setState(() => _saved = false));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _saved ? const Color(0xFF2ECC71) : AppColors.primary,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  _saved ? '✓  Saved!' : 'Save Preferences',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textLight,
            letterSpacing: 0.8,
          ),
        ),
      );
}

// ─────────────────────────────────────────────
//  CONNECTED DEVICES SCREEN — Full sync/unsync
// ─────────────────────────────────────────────

class _DeviceInfo {
  final String name;
  final String subtitle;
  final Color color;
  final List<String> dataTags;
  final IconData icon;
  bool connected;
  bool syncing;
  bool syncDone;
  String lastSynced;
  int syncPercent;

  _DeviceInfo({
    required this.name,
    required this.subtitle,
    required this.color,
    required this.dataTags,
    required this.icon,
    this.connected = false,
    this.syncing = false,
    this.syncDone = false,
    this.lastSynced = 'Never',
    this.syncPercent = 0,
  });
}

class ConnectedDevicesScreen extends StatefulWidget {
  const ConnectedDevicesScreen({super.key});

  @override
  State<ConnectedDevicesScreen> createState() =>
      _ConnectedDevicesScreenState();
}

class _ConnectedDevicesScreenState extends State<ConnectedDevicesScreen> {
  final List<_DeviceInfo> _devices = [
    _DeviceInfo(
      name: 'Apple Watch',
      subtitle: 'Apple HealthKit',
      color: const Color(0xFF1A1A1A),
      icon: Icons.watch,
      dataTags: ['HRV', 'Steps', 'Sleep', 'Heart Rate'],
      connected: true,
      lastSynced: '2 hours ago',
      syncPercent: 72,
    ),
    _DeviceInfo(
      name: 'Fitbit',
      subtitle: 'Fitbit',
      color: const Color(0xFF00B0B9),
      icon: Icons.fitness_center,
      dataTags: ['HRV', 'Steps', 'Sleep'],
      connected: false,
      lastSynced: 'Never',
      syncPercent: 0,
    ),
    _DeviceInfo(
      name: 'Garmin',
      subtitle: 'Garmin Connect',
      color: const Color(0xFF006EC7),
      icon: Icons.directions_run,
      dataTags: ['HRV', 'Steps', 'GPS'],
      connected: false,
      lastSynced: 'Never',
      syncPercent: 0,
    ),
    _DeviceInfo(
      name: 'Oura Ring',
      subtitle: 'Oura Health',
      color: const Color(0xFF5B5B5B),
      icon: Icons.circle_outlined,
      dataTags: ['HRV', 'Sleep', 'Readiness'],
      connected: false,
      lastSynced: 'Never',
      syncPercent: 0,
    ),
    _DeviceInfo(
      name: 'WHOOP',
      subtitle: 'WHOOP Band',
      color: const Color(0xFF1A1A2E),
      icon: Icons.sports_gymnastics,
      dataTags: ['HRV', 'Recovery', 'Strain'],
      connected: false,
      lastSynced: 'Never',
      syncPercent: 0,
    ),
  ];

  List<_DeviceInfo> get _connected =>
      _devices.where((d) => d.connected).toList();
  List<_DeviceInfo> get _available =>
      _devices.where((d) => !d.connected).toList();

  // ── Sync a device ─────────────────────────────────────────────────────────
  Future<void> _syncDevice(_DeviceInfo device) async {
    setState(() {
      device.syncing = true;
      device.syncDone = false;
    });
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    setState(() {
      device.syncing = false;
      device.syncDone = true;
      device.lastSynced = 'Just now';
      device.syncPercent = 85 + _devices.indexOf(device) * 3;
    });
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    setState(() => device.syncDone = false);
  }

  // ── Connect a device ──────────────────────────────────────────────────────
  Future<void> _connectDevice(_DeviceInfo device) async {
    setState(() => device.syncing = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() {
      device.connected = true;
      device.syncing = false;
      device.lastSynced = 'Just now';
      device.syncPercent = 80;
    });
  }

  // ── Disconnect confirmation dialog ────────────────────────────────────────
  void _confirmDisconnect(_DeviceInfo device) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Disconnect ${device.name}?'),
        content: const Text(
          'This will stop syncing data from this device. Your existing data will be preserved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textMedium)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                device.connected = false;
                device.syncDone = false;
                device.syncing = false;
                device.lastSynced = 'Never';
                device.syncPercent = 0;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Disconnect',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        elevation: 0,
        leading: const BackButton(color: AppColors.textDark),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Connected Devices', style: AppTextStyles.screenTitle),
            Text('Manage wearable integrations',
                style: AppTextStyles.smallText),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Connected devices section ─────────────────────────────
            if (_connected.isNotEmpty) ...[
              _sectionLabel('CONNECTED DEVICES (${_connected.length})'),
              ..._connected.map((d) => _ConnectedDeviceCard(
                    device: d,
                    onSync: () => _syncDevice(d),
                    onDisconnect: () => _confirmDisconnect(d),
                  )),
            ],

            // ── Available integrations ────────────────────────────────
            _sectionLabel('AVAILABLE INTEGRATIONS'),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: _available.asMap().entries.map((entry) {
                  final i = entry.key;
                  final d = entry.value;
                  return Column(
                    children: [
                      _AvailableDeviceRow(
                        device: d,
                        onConnect: () => _connectDevice(d),
                      ),
                      if (i < _available.length - 1)
                        const Divider(
                            height: 1, color: AppColors.divider),
                    ],
                  );
                }).toList(),
              ),
            ),

            // ── Sync settings ─────────────────────────────────────────
            _sectionLabel('SYNC SETTINGS'),
            _SyncSettingsCard(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textLight,
            letterSpacing: 0.8,
          ),
        ),
      );
}

// ── Connected device card ─────────────────────────────────────────────────────
class _ConnectedDeviceCard extends StatelessWidget {
  final _DeviceInfo device;
  final VoidCallback onSync;
  final VoidCallback onDisconnect;

  const _ConnectedDeviceCard({
    required this.device,
    required this.onSync,
    required this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Device icon
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: device.color,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(device.icon, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + Connected badge
                      Row(
                        children: [
                          Flexible(
                            child: Text(device.name,
                                style: AppTextStyles.cardTitle
                                    .copyWith(fontSize: 15),
                                overflow: TextOverflow.ellipsis),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF2ECC71),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text('Connected',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF2E7D32),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(device.subtitle,
                          style: AppTextStyles.cardSubtitle),
                      const SizedBox(height: 6),

                      // Last synced + sync %
                      Row(
                        children: [
                          const Icon(Icons.access_time_outlined,
                              size: 12, color: AppColors.textLight),
                          const SizedBox(width: 4),
                          Text(device.lastSynced,
                              style: AppTextStyles.smallText),
                          const SizedBox(width: 12),
                          const Icon(Icons.trending_up,
                              size: 12, color: AppColors.textLight),
                          const SizedBox(width: 4),
                          Text('${device.syncPercent}%',
                              style: AppTextStyles.smallText),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Data tags
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: device.dataTags
                            .map((tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: AppColors.primary
                                            .withOpacity(0.2)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 5,
                                        height: 5,
                                        decoration: const BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(tag,
                                          style: AppTextStyles.smallText
                                              .copyWith(
                                                  color: AppColors.primary,
                                                  fontWeight:
                                                      FontWeight.w600)),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Sync Now + Disconnect row ─────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Row(
              children: [
                // Sync button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: device.syncing ? null : onSync,
                    icon: device.syncing
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary))
                        : Icon(
                            device.syncDone ? Icons.check : Icons.sync,
                            size: 16,
                            color: device.syncDone
                                ? const Color(0xFF2ECC71)
                                : AppColors.primary),
                    label: Text(
                      device.syncing
                          ? 'Syncing...'
                          : device.syncDone
                              ? '✓  Synced!'
                              : 'Sync Now',
                      style: AppTextStyles.inputLabel.copyWith(
                          color: device.syncDone
                              ? const Color(0xFF2ECC71)
                              : AppColors.textDark),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 44),
                      side: const BorderSide(color: AppColors.inputBorder),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Disconnect (X) button
                GestureDetector(
                  onTap: onDisconnect,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.riskHigh.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.riskHigh.withOpacity(0.2)),
                    ),
                    child: const Icon(Icons.close,
                        color: AppColors.riskHigh, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Available device row ──────────────────────────────────────────────────────
class _AvailableDeviceRow extends StatelessWidget {
  final _DeviceInfo device;
  final VoidCallback onConnect;

  const _AvailableDeviceRow({
    required this.device,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: device.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(device.icon, color: device.color, size: 20),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(device.name,
                    style:
                        AppTextStyles.activityTitle.copyWith(fontSize: 14)),
                const SizedBox(height: 2),
                Text('Connect your ${device.name} device',
                    style: AppTextStyles.smallText),
              ],
            ),
          ),
          device.syncing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: AppColors.primary))
              : GestureDetector(
                  onTap: onConnect,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add,
                        color: AppColors.primary, size: 18),
                  ),
                ),
        ],
      ),
    );
  }
}

// ── Sync settings card ────────────────────────────────────────────────────────
class _SyncSettingsCard extends StatefulWidget {
  @override
  State<_SyncSettingsCard> createState() => _SyncSettingsCardState();
}

class _SyncSettingsCardState extends State<_SyncSettingsCard> {
  bool _bgSync = true;
  String _frequency = 'Every 15 min';

  final List<String> _freqOptions = [
    'Every 5 min',
    'Every 15 min',
    'Every 30 min',
    'Every hour',
    'Every 2 hours',
  ];

  void _showFreqPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.cardBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            ..._freqOptions.map((f) => ListTile(
                  title: Text(f,
                      style: TextStyle(
                        fontWeight: f == _frequency
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: f == _frequency
                            ? AppColors.primary
                            : AppColors.textDark,
                      )),
                  trailing: f == _frequency
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  tileColor: f == _frequency
                      ? AppColors.primary.withOpacity(0.08)
                      : null,
                  onTap: () {
                    setState(() => _frequency = f);
                    Navigator.pop(context);
                  },
                )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Background Sync',
                          style:
                              AppTextStyles.activityTitle.copyWith(fontSize: 14)),
                      const SizedBox(height: 2),
                      Text('Automatically sync data in the background',
                          style: AppTextStyles.smallText),
                    ],
                  ),
                ),
                Switch(
                  value: _bgSync,
                  onChanged: (v) => setState(() => _bgSync = v),
                  activeColor: AppColors.primary,
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sync Frequency',
                          style:
                              AppTextStyles.activityTitle.copyWith(fontSize: 14)),
                      const SizedBox(height: 2),
                      Text('How often to sync wearable data',
                          style: AppTextStyles.smallText),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _showFreqPicker,
                  child: Row(
                    children: [
                      Text(_frequency,
                          style:
                              AppTextStyles.activityTitle.copyWith(fontSize: 13)),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down,
                          size: 16, color: AppColors.textMedium),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  DATA & PRIVACY SCREEN
// ─────────────────────────────────────────────
class DataPrivacyScreen extends StatefulWidget {
  const DataPrivacyScreen({super.key});

  @override
  State<DataPrivacyScreen> createState() => _DataPrivacyScreenState();
}

class _DataPrivacyScreenState extends State<DataPrivacyScreen> {
  bool _behavioral = true;
  bool _wearable = true;
  bool _clinical = true;
  bool _clinician = true;
  bool _research = false;
  bool _model = true;
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        elevation: 0,
        leading: const BackButton(color: AppColors.textDark),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Data & Privacy', style: AppTextStyles.screenTitle),
            Text('Control your health data', style: AppTextStyles.smallText),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.shield_outlined,
                  color: AppColors.primary, size: 16),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionLabel('Data Layer Visibility'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: Text(
                    'Control which data layers are used in your risk score calculation and visible to connected clinicians.',
                    style: AppTextStyles.cardSubtitle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _DataLayerCard(
                        icon: Icons.remove_red_eye_outlined,
                        iconBg: const Color(0xFF7C3AED),
                        label: 'Behavioral Data',
                        subtitle: 'Daily check-ins, mood, symptoms',
                        tags: const [
                          'Morning/evening check-ins',
                          'Fatigue levels',
                          'Pain tracking'
                        ],
                        value: _behavioral,
                        onChanged: (v) => setState(() => _behavioral = v),
                      ),
                      const SizedBox(height: 8),
                      _DataLayerCard(
                        icon: Icons.storage_outlined,
                        iconBg: AppColors.primary,
                        label: 'Wearable Data',
                        subtitle: 'HRV, steps, sleep patterns',
                        tags: const [
                          'Heart rate variability',
                          'Sleep stages',
                          'Activity metrics'
                        ],
                        value: _wearable,
                        onChanged: (v) => setState(() => _wearable = v),
                      ),
                      const SizedBox(height: 8),
                      _DataLayerCard(
                        icon: Icons.description_outlined,
                        iconBg: const Color(0xFF0EA5E9),
                        label: 'Clinical Data',
                        subtitle: 'Lab results, ultrasound, assessments',
                        tags: const [
                          'Lab test results',
                          'Ultrasound findings',
                          'mFG scores'
                        ],
                        value: _clinical,
                        onChanged: (v) => setState(() => _clinical = v),
                      ),
                    ],
                  ),
                ),
                _sectionLabel('Consent Management'),
                _ProfileCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _ConsentRow(
                        icon: Icons.people_outline,
                        label: 'Share with Clinician',
                        subtitle:
                            'Allow your connected healthcare providers to view your data',
                        value: _clinician,
                        onChanged: (v) => setState(() => _clinician = v),
                      ),
                      const Divider(height: 1, color: AppColors.divider),
                      _ConsentRow(
                        icon: Icons.folder_outlined,
                        label: 'Anonymized Research',
                        subtitle:
                            'Contribute to PCOS research (fully anonymized)',
                        value: _research,
                        onChanged: (v) => setState(() => _research = v),
                      ),
                      const Divider(height: 1, color: AppColors.divider),
                      _ConsentRow(
                        icon: Icons.lock_outline,
                        label: 'Model Improvement',
                        subtitle:
                            'Help improve AI predictions with your anonymized patterns',
                        value: _model,
                        onChanged: (v) => setState(() => _model = v),
                      ),
                    ],
                  ),
                ),
                _sectionLabel('Your Data Rights'),
                _ProfileCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _RightsRow(
                        icon: Icons.download_outlined,
                        iconColor: AppColors.primary,
                        label: 'Export My Data',
                        subtitle: 'Download all your health data as a file',
                        onTap: () {},
                      ),
                      const Divider(height: 1, color: AppColors.divider),
                      _RightsRow(
                        icon: Icons.delete_outline,
                        iconColor: AppColors.riskHigh,
                        label: 'Delete All Data',
                        labelColor: AppColors.riskHigh,
                        subtitle: 'Permanently erase your account and data',
                        onTap: () => showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            title: Text('Delete All Data',
                                style: TextStyle(color: AppColors.riskHigh)),
                            content: const Text(
                                'This will permanently erase your account and all associated health data. This action cannot be undone.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Delete',
                                    style: TextStyle(
                                        color: AppColors.riskHigh)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.primary.withOpacity(0.2)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.shield_outlined,
                            color: AppColors.primary, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Your Data is Protected',
                                  style: AppTextStyles.activityTitle
                                      .copyWith(fontSize: 14)),
                              const SizedBox(height: 4),
                              Text(
                                'All health data is encrypted at rest and in transit. We comply with HIPAA regulations and never sell your personal information to third parties.',
                                style: AppTextStyles.smallText,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: AppColors.surfaceWhite,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: ElevatedButton(
                onPressed: () {
                  setState(() => _saved = true);
                  Future.delayed(const Duration(seconds: 2),
                      () => setState(() => _saved = false));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _saved ? const Color(0xFF2ECC71) : AppColors.primary,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  _saved ? '✓  Saved!' : 'Save Privacy Settings',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textLight,
            letterSpacing: 0.8,
          ),
        ),
      );
}

// ═════════════════════════════════════════════
//  SHARED PRIVATE WIDGETS
// ═════════════════════════════════════════════

class _ProfileCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const _ProfileCard({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: child,
    );
  }
}

class _DemoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DemoTile(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 16),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.smallText),
              Text(value,
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompletionRow extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  const _CompletionRow(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 82,
          child: Text(label,
              style: AppTextStyles.smallText.copyWith(fontSize: 11)),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 7,
              backgroundColor: AppColors.progressBg,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 32,
          child: Text(
            '${(value * 100).round()}%',
            textAlign: TextAlign.right,
            style: AppTextStyles.smallText.copyWith(
                fontSize: 11, fontWeight: FontWeight.w700,
                color: AppColors.textDark),
          ),
        ),
      ],
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  const _SettingsRow(
      {required this.icon,
      required this.label,
      required this.subtitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: AppColors.iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: AppTextStyles.activityTitle
                          .copyWith(fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.smallText),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                size: 20, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }
}

class _TimeRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor, iconBg;
  final String label, subtitle, time;
  final VoidCallback onTap;
  const _TimeRow(
      {required this.icon,
      required this.iconColor,
      required this.iconBg,
      required this.label,
      required this.subtitle,
      required this.time,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
                color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: AppTextStyles.activityTitle.copyWith(fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.smallText),
              ],
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.inputBorder),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(time,
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 14)),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down,
                      size: 14, color: AppColors.textMedium),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotifRow extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _NotifRow(
      {required this.icon,
      required this.label,
      required this.subtitle,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AppColors.iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: AppTextStyles.activityTitle.copyWith(fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.smallText),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _DataLayerCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String label, subtitle;
  final List<String> tags;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _DataLayerCard(
      {required this.icon,
      required this.iconBg,
      required this.label,
      required this.subtitle,
      required this.tags,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: iconBg.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconBg, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: AppTextStyles.cardTitle.copyWith(fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.cardSubtitle),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: tags
                      .map((t) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: Text(t, style: AppTextStyles.smallText),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _ConsentRow extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ConsentRow(
      {required this.icon,
      required this.label,
      required this.subtitle,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AppColors.iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: AppTextStyles.activityTitle.copyWith(fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.smallText),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _RightsRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label, subtitle;
  final Color? labelColor;
  final VoidCallback onTap;
  const _RightsRow(
      {required this.icon,
      required this.iconColor,
      required this.label,
      this.labelColor,
      required this.subtitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: AppTextStyles.activityTitle.copyWith(
                          fontSize: 14, color: labelColor)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.smallText),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                size: 20, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }
}