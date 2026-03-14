import 'package:ai_mshm/app_colors.dart';
import 'package:ai_mshm/app_textstyles.dart';
import 'package:ai_mshm/widgets.dart';
import 'package:flutter/material.dart';

// ─── Screen 20: Lab Results Upload ───────────────────────────────────────────
class LabUploadScreen extends StatefulWidget {
  const LabUploadScreen({super.key});
  @override State<LabUploadScreen> createState() => _LabUploadState();
}

class _LabUploadState extends State<LabUploadScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this);
  final Map<String, TextEditingController> _fields = {
    'LH (IU/L)': TextEditingController(), 'FSH (IU/L)': TextEditingController(),
    'AMH (ng/mL)': TextEditingController(), 'Free Testosterone (pg/mL)': TextEditingController(),
    'DHEAS (μg/dL)': TextEditingController(), 'Fasting Glucose (mg/dL)': TextEditingController(),
    'Fasting Insulin (μIU/mL)': TextEditingController(), 'HbA1c (%)': TextEditingController(),
    'TSH (mIU/L)': TextEditingController(),
  };
  bool _uploading = false, _saving = false;

  double? get _lhFsh {
    final lh = double.tryParse(_fields['LH (IU/L)']?.text ?? '');
    final fsh = double.tryParse(_fields['FSH (IU/L)']?.text ?? '');
    if (lh == null || fsh == null || fsh == 0) return null;
    return lh / fsh;
  }

  double? get _homaIr {
    final g = double.tryParse(_fields['Fasting Glucose (mg/dL)']?.text ?? '');
    final i = double.tryParse(_fields['Fasting Insulin (μIU/mL)']?.text ?? '');
    if (g == null || i == null) return null;
    return (i * g) / 405;
  }

  @override void dispose() { _tabs.dispose(); for (final c in _fields.values) c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context)),
        title: Text('Add Lab Results', style: AppTextStyles.cardTitle),
        bottom: TabBar(controller: _tabs,
          labelColor: AppColors.primary, unselectedLabelColor: AppColors.textMedium,
          indicatorColor: AppColors.primary,
          tabs: const [Tab(text: 'Manual Entry'), Tab(text: 'Upload PDF')]),
      ),
      body: TabBarView(controller: _tabs, children: [
        // Manual Entry
        SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Computed values
            if (_lhFsh != null || _homaIr != null)
              Container(margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primary.withOpacity(0.2))),
                child: Column(children: [
                  if (_lhFsh != null) _ComputedRow(label: 'LH/FSH Ratio', value: _lhFsh!.toStringAsFixed(2)),
                  if (_lhFsh != null && _homaIr != null) const Divider(height: 12),
                  if (_homaIr != null) _ComputedRow(label: 'HOMA-IR', value: _homaIr!.toStringAsFixed(2)),
                ])),

            ..._fields.entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(e.key, style: AppTextStyles.inputLabel),
                const SizedBox(height: 6),
                TextField(controller: e.value, keyboardType: TextInputType.number,
                  style: AppTextStyles.inputText,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(hintText: 'Enter value',
                    suffixIcon: Padding(padding: const EdgeInsets.all(12),
                      child: Text(_refRange(e.key),
                        style: AppTextStyles.smallText.copyWith(fontSize: 11, color: AppColors.textLight))))),
              ]))),

            const SizedBox(height: 20),
            PrimaryButton(label: 'Save Lab Results', isLoading: _saving,
              onPressed: () async {
                setState(() => _saving = true);
                await Future.delayed(const Duration(milliseconds: 800));
                setState(() => _saving = false);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Lab results saved ✓'), backgroundColor: AppColors.primary));
                  Navigator.pop(context);
                }
              }),
            const SizedBox(height: 24),
          ]),
        ),

        // Upload PDF
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                setState(() => _uploading = true);
                await Future.delayed(const Duration(seconds: 2));
                setState(() => _uploading = false);
              },
              child: Container(height: 180, width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite, borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 2,
                    style: BorderStyle.solid)),
                child: _uploading
                  ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const CircularProgressIndicator(color: AppColors.primary),
                      const SizedBox(height: 12),
                      Text('Processing PDF...', style: AppTextStyles.cardSubtitle),
                    ])
                  : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Icon(Icons.upload_file_outlined, size: 48, color: AppColors.primary),
                      const SizedBox(height: 12),
                      Text('Tap to upload PDF, JPG, or PNG', style: AppTextStyles.cardTitle),
                      const SizedBox(height: 4),
                      Text('AI will extract lab values automatically', style: AppTextStyles.cardSubtitle),
                    ])),
            ),
            const SizedBox(height: 20),
            Container(padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.warningAmber.withOpacity(0.3))),
              child: Row(children: [
                const Icon(Icons.info_outline, color: AppColors.warningAmber, size: 18),
                const SizedBox(width: 10),
                Expanded(child: Text('Extracted values will be shown for your review before saving.',
                  style: AppTextStyles.smallText.copyWith(color: AppColors.warningAmber))),
              ])),
          ]),
        ),
      ]),
    );
  }

  String _refRange(String key) {
    const ranges = {
      'LH (IU/L)': '2–15', 'FSH (IU/L)': '3–10', 'AMH (ng/mL)': '1–3.5',
      'Free Testosterone (pg/mL)': '0.1–6.4', 'DHEAS (μg/dL)': '35–430',
      'Fasting Glucose (mg/dL)': '70–99', 'Fasting Insulin (μIU/mL)': '2–25',
      'HbA1c (%)': '<5.7', 'TSH (mIU/L)': '0.4–4.0',
    };
    return ranges[key] ?? '';
  }
}

class _ComputedRow extends StatelessWidget {
  final String label, value;
  const _ComputedRow({required this.label, required this.value});
  @override Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: AppTextStyles.sectionLabel),
      Text(value, style: AppTextStyles.detailsLink.copyWith(fontWeight: FontWeight.w800)),
    ],
  );
}

// ─── Screen 21: Ultrasound / DICOM Upload ────────────────────────────────────
class UltrasoundUploadScreen extends StatefulWidget {
  const UltrasoundUploadScreen({super.key});
  @override State<UltrasoundUploadScreen> createState() => _UltrasoundState();
}

class _UltrasoundState extends State<UltrasoundUploadScreen> {
  // 0=empty, 1=uploading, 2=processing, 3=complete, 4=error
  int _status = 0;

  Future<void> _upload() async {
    setState(() => _status = 1);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _status = 2);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _status = 3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context)),
        title: Text('Upload Ultrasound Scan', style: AppTextStyles.cardTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Container(padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primary.withOpacity(0.2))),
            child: Row(children: [
              const Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(
                'AI-MSHM can automatically count follicles and measure ovarian volume from your ultrasound.',
                style: AppTextStyles.smallText.copyWith(color: AppColors.textDark))),
            ])),

          const SizedBox(height: 20),
          Text('Supported formats: DICOM (.dcm), JPEG, PNG', style: AppTextStyles.smallText),
          const SizedBox(height: 14),

          GestureDetector(
            onTap: _status == 0 ? _upload : null,
            child: Container(height: 160, width: double.infinity,
              decoration: BoxDecoration(color: AppColors.surfaceWhite, borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _status == 0 ? AppColors.inputBorder : AppColors.primary,
                  width: _status == 0 ? 1 : 2)),
              child: _status == 0
                ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.add_photo_alternate_outlined, size: 48, color: AppColors.primary),
                    const SizedBox(height: 10),
                    Text('Tap to select file', style: AppTextStyles.cardTitle),
                    const SizedBox(height: 4),
                    Text('Camera Roll · Files · DICOM viewer', style: AppTextStyles.cardSubtitle),
                  ])
                : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const SizedBox(width: 28, height: 28,
                      child: CircularProgressIndicator(strokeWidth: 3, color: AppColors.primary)),
                    const SizedBox(height: 12),
                    Text(_status == 1 ? 'Uploading...' : 'CNN processing — ~60 seconds',
                      style: AppTextStyles.cardSubtitle),
                  ])),
          ),

          if (_status >= 1) ...[
            const SizedBox(height: 16),
            Container(padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.surfaceWhite, borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.cardBorder)),
              child: Row(children: [
                _StatusStep(label: 'Uploaded', done: _status >= 2),
                Expanded(child: Container(height: 2, color: _status >= 2 ? AppColors.primary : AppColors.progressBg)),
                _StatusStep(label: 'Processing', done: _status >= 3),
                Expanded(child: Container(height: 2, color: _status >= 3 ? AppColors.primary : AppColors.progressBg)),
                _StatusStep(label: 'Complete', done: _status == 3),
              ])),
          ],

          if (_status == 3) ...[
            const SizedBox(height: 20),
            DashCard(title: 'AI Ultrasound Results',
              trailing: const RiskBadge(tier: 'Moderate'),
              child: Padding(padding: const EdgeInsets.only(top: 12),
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: const [
                    _ResultMetric(label: 'Follicles\n(right)', value: '12'),
                    _ResultMetric(label: 'Follicles\n(left)', value: '10'),
                    _ResultMetric(label: 'Avg Diameter', value: '6.4mm'),
                    _ResultMetric(label: 'Ovarian\nVolume', value: '11.2mL'),
                  ]),
                  const SizedBox(height: 14),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: AppColors.riskModerate.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8)),
                    child: Text('PCOM: Positive — follicle count ≥ 12 per ovary',
                      style: AppTextStyles.smallText.copyWith(color: AppColors.riskModerate, fontWeight: FontWeight.w600))),
                  const SizedBox(height: 10),
                  Text('AI estimate — not a clinical diagnosis. Confirm with your sonographer.',
                    style: AppTextStyles.smallText.copyWith(fontSize: 11), textAlign: TextAlign.center),
                ])),
            ),
          ],

          const SizedBox(height: 24),
        ]),
      ),
    );
  }
}

class _StatusStep extends StatelessWidget {
  final String label; final bool done;
  const _StatusStep({required this.label, required this.done});
  @override Widget build(BuildContext context) => Column(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 24, height: 24,
      decoration: BoxDecoration(color: done ? AppColors.primary : AppColors.progressBg, shape: BoxShape.circle),
      child: Icon(done ? Icons.check : Icons.circle, size: 12,
        color: done ? Colors.white : AppColors.textLight)),
    const SizedBox(height: 4),
    Text(label, style: AppTextStyles.stepLabel),
  ]);
}

class _ResultMetric extends StatelessWidget {
  final String label, value;
  const _ResultMetric({required this.label, required this.value});
  @override Widget build(BuildContext context) => Column(children: [
    Text(value, style: AppTextStyles.biomarkerValue.copyWith(fontSize: 16)),
    const SizedBox(height: 2),
    Text(label, style: AppTextStyles.biomarkerUnit, textAlign: TextAlign.center),
  ]);
}

// ─── Screen 22: Clinical Data Status ─────────────────────────────────────────
class ClinicalStatusScreen extends StatefulWidget {
  const ClinicalStatusScreen({super.key});
  @override State<ClinicalStatusScreen> createState() => _ClinicalStatusState();
}

class _ClinicalStatusState extends State<ClinicalStatusScreen> {
  final _biomarkers = [
    {'name': 'LH',               'value': '8.2',   'unit': 'IU/L',   'date': 'Mar 1',  'ok': true},
    {'name': 'FSH',              'value': '4.1',   'unit': 'IU/L',   'date': 'Mar 1',  'ok': true},
    {'name': 'AMH',              'value': null,    'unit': 'ng/mL',  'date': null,     'ok': false},
    {'name': 'Free Testosterone', 'value': '7.2', 'unit': 'pg/mL',  'date': 'Feb 20', 'ok': false},
    {'name': 'DHEAS',            'value': null,    'unit': 'μg/dL',  'date': null,     'ok': false},
    {'name': 'Fasting Glucose',  'value': '94',    'unit': 'mg/dL',  'date': 'Mar 1',  'ok': true},
    {'name': 'Fasting Insulin',  'value': '12',    'unit': 'μIU/mL', 'date': 'Mar 1',  'ok': true},
    {'name': 'HbA1c',            'value': null,    'unit': '%',      'date': null,     'ok': false},
    {'name': 'TSH',              'value': '2.1',   'unit': 'mIU/L',  'date': 'Feb 20', 'ok': true},
  ];

  int get _provided => _biomarkers.where((m) => m['value'] != null).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context)),
        title: Text('My Clinical Data', style: AppTextStyles.cardTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Completeness
          DashCard(
            title: 'Clinical Layer Completeness',
            trailing: Text('$_provided/${_biomarkers.length}', style: AppTextStyles.percentagePrimary),
            child: Padding(padding: const EdgeInsets.only(top: 12),
              child: Column(children: [
                LayerProgress(label: 'Biomarkers provided', percent: _provided / _biomarkers.length),
                const SizedBox(height: 12),
                Container(padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    const Icon(Icons.trending_up, color: AppColors.primary, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text('Adding Clinical Layer data increases Risk Score accuracy by up to 34%.',
                      style: AppTextStyles.smallText.copyWith(color: AppColors.primary))),
                  ])),
              ])),
          ),

          const SizedBox(height: 20),
          Text('Biochemical Panel', style: AppTextStyles.sectionHeader),
          const SizedBox(height: 12),

          ..._biomarkers.map((m) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.surfaceWhite, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder)),
              child: Row(children: [
                Icon(m['value'] != null ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: m['value'] != null ? AppColors.riskLow : AppColors.textLight, size: 20),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(m['name'] as String, style: AppTextStyles.activityTitle),
                  if (m['value'] != null)
                    Text('${m['value']} ${m['unit']} · ${m['date']}', style: AppTextStyles.activityTime)
                  else
                    Text('Not provided', style: AppTextStyles.activityTime),
                ])),
                OutlinedButton(
                  onPressed: () => Navigator.pushNamed(context, '/clinical/labs'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.inputBorder),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: Text(m['value'] != null ? 'Update' : 'Add',
                    style: AppTextStyles.linkText.copyWith(fontSize: 12))),
              ]),
            ),
          )),

          const SizedBox(height: 20),
          Text('Imaging', style: AppTextStyles.sectionHeader),
          const SizedBox(height: 12),

          Container(padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surfaceWhite, borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder)),
            child: Row(children: [
              const Icon(Icons.image_search_outlined, color: AppColors.primary, size: 28),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Ultrasound Scan', style: AppTextStyles.activityTitle),
                Text('Last scan: Feb 15 · PCOM Positive', style: AppTextStyles.activityTime),
              ])),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/clinical/ultrasound'),
                child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                  child: const Text('Upload', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)))),
            ])),

          const SizedBox(height: 24),
        ]),
      ),
    );
  }
}