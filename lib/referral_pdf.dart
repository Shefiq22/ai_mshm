import 'package:ai_mshm/app_colors.dart';
import 'package:ai_mshm/app_textstyles.dart';
import 'package:ai_mshm/routes.dart';
import 'package:ai_mshm/widgets.dart';
import 'package:flutter/material.dart';


// ─── Screen 27: Clinical Referral Recommendation ─────────────────────────────
class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});
  @override State<ReferralScreen> createState() => _ReferralState();
}

class _ReferralState extends State<ReferralScreen> {
  final List<bool> _checks = List.filled(4, false);
  bool _generating = false;

  final _actions = [
    'Book appointment with a Gynaecologist or Endocrinologist',
    'Request LH, FSH, and Testosterone blood tests',
    'Bring Clinical Summary to your appointment',
    'Continue daily check-ins to track progress',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context)),
        title: Text('Clinical Referral', style: AppTextStyles.cardTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [

          // Urgency card
          Container(padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.riskModerate.withOpacity(0.15),
                AppColors.riskModerate.withOpacity(0.05)]),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.riskModerate.withOpacity(0.4))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(width: 44, height: 44,
                  decoration: BoxDecoration(color: AppColors.riskModerate.withOpacity(0.15), shape: BoxShape.circle),
                  child: const Icon(Icons.local_hospital_outlined, color: AppColors.riskModerate, size: 24)),
                const SizedBox(width: 14),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const RiskBadge(tier: 'High'),
                  const SizedBox(height: 4),
                  Text('Risk Score: 0.67', style: AppTextStyles.sectionLabel),
                ]),
              ]),
              const SizedBox(height: 14),
              Text('Consult a Gynaecologist or Endocrinologist within 2 weeks.',
                style: AppTextStyles.featureTitle),
            ])),

          const SizedBox(height: 16),

          // Why this referral
          DashCard(title: 'Why This Referral', child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              'Your PCOS Risk Score of 0.67 meets the threshold for clinical review. '
              'Two of three Rotterdam Criteria show positive indicators, and your LH/FSH ratio '
              'exceeds the diagnostic threshold. Early clinical assessment is recommended.',
              style: AppTextStyles.bodyText))),

          const SizedBox(height: 16),

          // Specialists
          Text('Recommended Specialists', style: AppTextStyles.sectionHeader),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _SpecialistCard(title: 'Gynaecologist', icon: Icons.medical_services_outlined)),
            const SizedBox(width: 10),
            Expanded(child: _SpecialistCard(title: 'Endocrinologist', icon: Icons.science_outlined)),
            const SizedBox(width: 10),
            Expanded(child: _SpecialistCard(title: 'GP / Primary Care', icon: Icons.person_outline)),
          ]),

          const SizedBox(height: 16),

          // Evidence summary
          DashCard(title: 'Evidence Summary', child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(children: [
              _EvidenceRow(text: 'LH/FSH Ratio 2.8 (threshold: 2.0)'),
              _EvidenceRow(text: 'Cycle variability ±8.2 days (normal < 5)'),
              _EvidenceRow(text: 'mFG Score 7 (threshold: ≥6)'),
              _EvidenceRow(text: 'PCOM positive on ultrasound (Feb 15)'),
            ]))),

          const SizedBox(height: 16),

          // Action checklist
          DashCard(title: 'Recommended Next Steps', child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(children: _actions.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                GestureDetector(onTap: () => setState(() => _checks[e.key] = !_checks[e.key]),
                  child: AnimatedContainer(duration: const Duration(milliseconds: 200),
                    width: 22, height: 22,
                    decoration: BoxDecoration(
                      color: _checks[e.key] ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: _checks[e.key] ? AppColors.primary : AppColors.inputBorder, width: 2)),
                    child: _checks[e.key] ? const Icon(Icons.check, size: 14, color: Colors.white) : null)),
                const SizedBox(width: 10),
                Expanded(child: Text(e.value, style: AppTextStyles.cardSubtitle.copyWith(
                  decoration: _checks[e.key] ? TextDecoration.lineThrough : null,
                  color: _checks[e.key] ? AppColors.textLight : AppColors.textMedium))),
              ]))).toList()))),

          const SizedBox(height: 20),

          PrimaryButton(label: 'Generate Clinical Summary PDF', isLoading: _generating,
            onPressed: () async {
              setState(() => _generating = true);
              await Future.delayed(const Duration(seconds: 1));
              if (mounted) {
                setState(() => _generating = false);
                Navigator.pushNamed(context, AppRoutes.clinicalPdf);
              }
            }),
          const SizedBox(height: 10),

          OutlinedButton(onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              minimumSize: const Size(double.infinity, 50)),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text('Find a Specialist', style: AppTextStyles.linkText),
            ])),

          const SizedBox(height: 24),
        ]),
      ),
    );
  }
}

class _SpecialistCard extends StatelessWidget {
  final String title; final IconData icon;
  const _SpecialistCard({required this.title, required this.icon});
  @override Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: AppColors.surfaceWhite, borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.cardBorder)),
    child: Column(children: [
      Icon(icon, color: AppColors.primary, size: 24),
      const SizedBox(height: 6),
      Text(title, style: AppTextStyles.smallText.copyWith(fontWeight: FontWeight.w600),
        textAlign: TextAlign.center),
    ]),
  );
}

class _EvidenceRow extends StatelessWidget {
  final String text;
  const _EvidenceRow({required this.text});
  @override Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(children: [
      Container(width: 6, height: 6, decoration: const BoxDecoration(
        color: AppColors.riskHigh, shape: BoxShape.circle)),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: AppTextStyles.cardSubtitle)),
    ]),
  );
}

// ─── Screen 28: Clinical Summary PDF Preview ─────────────────────────────────
class ClinicalPdfScreen extends StatefulWidget {
  const ClinicalPdfScreen({super.key});
  @override State<ClinicalPdfScreen> createState() => _ClinicalPdfState();
}

class _ClinicalPdfState extends State<ClinicalPdfScreen> {
  int _version = 0; // 0=Patient, 1=Clinician

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context)),
        title: Text('Clinical Summary Report', style: AppTextStyles.cardTitle),
        actions: [
          TextButton(onPressed: () {},
            child: Text('Regenerate', style: AppTextStyles.linkText.copyWith(fontSize: 13))),
        ],
      ),
      body: Column(children: [
        // Version toggle
        Container(color: AppColors.surfaceWhite,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Container(
            decoration: BoxDecoration(color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.cardBorder)),
            child: Row(children: [
              _VersionTab(label: 'Patient Version',   selected: _version == 0, onTap: () => setState(() => _version = 0)),
              _VersionTab(label: 'Clinician Version', selected: _version == 1, onTap: () => setState(() => _version = 1)),
            ]),
          )),

        // PDF preview
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: AppColors.surfaceWhite, borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0,4))]),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Header
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('AI-MSHM', style: AppTextStyles.splashBrand),
                  Text('Clinical Summary Report', style: AppTextStyles.smallText),
                ]),
                const Icon(Icons.shield_outlined, color: AppColors.primary, size: 32),
              ]),
              const Divider(height: 24),
              _PdfRow(label: 'Patient', value: 'Jane Smith'),
              _PdfRow(label: 'Date',    value: 'March 12, 2026'),
              _PdfRow(label: 'Report ID', value: 'RPT-2026-0312-001'),
              const Divider(height: 24),

              // Risk gauge visual
              Row(children: [
                Container(width: 60, height: 50,
                  child: CustomPaint(painter: GaugePainter(value: 0.67))),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Risk Score: 0.67', style: AppTextStyles.featureTitle),
                  const RiskBadge(tier: 'Moderate'),
                ]),
              ]),
              const Divider(height: 24),

              Text('Top Contributing Factors', style: AppTextStyles.inputLabel),
              const SizedBox(height: 10),
              ...[
                'LH/FSH Ratio: 2.8 (+18%)',
                'Irregular cycle length (+15%)',
                'mFG Score 7 (+12%)',
                'HRV RMSSD 42ms (−8%)',
                'Fasting Glucose 94 mg/dL (−5%)',
              ].map((t) => Padding(padding: const EdgeInsets.only(bottom: 6),
                child: Row(children: [
                  Container(width: 6, height: 6, decoration: const BoxDecoration(
                    color: AppColors.primary, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Text(t, style: AppTextStyles.smallText),
                ]))),

              const Divider(height: 24),
              Text('Criterion Flags', style: AppTextStyles.inputLabel),
              const SizedBox(height: 8),
              _PdfRow(label: 'Criterion 1 (Oligo/Anovulation)',   value: 'Positive'),
              _PdfRow(label: 'Criterion 2 (Hyperandrogenism)',     value: 'Positive'),
              _PdfRow(label: 'Criterion 3 (PCOM)',                 value: 'Positive'),
              const Divider(height: 24),

              Text('Recommended Action', style: AppTextStyles.inputLabel),
              const SizedBox(height: 8),
              Text('Refer to Gynaecologist or Endocrinologist within 2 weeks for clinical confirmation of PCOS diagnosis.',
                style: AppTextStyles.bodyText),

              if (_version == 1) ...[
                const Divider(height: 24),
                Text('Full SHAP Table (Clinician)', style: AppTextStyles.inputLabel),
                const SizedBox(height: 8),
                Text('Full SHAP vector, LSTM temporal features, and inference metadata available in clinician export.',
                  style: AppTextStyles.bodyText.copyWith(color: AppColors.textLight)),
              ],

              const Divider(height: 24),
              Text('AI-MSHM is an assistive tool. This report does not constitute a clinical diagnosis. All findings must be confirmed by a qualified healthcare professional.',
                style: AppTextStyles.smallText.copyWith(fontSize: 11, fontStyle: FontStyle.italic)),
            ])),
        )),

        // Action bar
        Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: const BoxDecoration(color: AppColors.surfaceWhite,
            border: Border(top: BorderSide(color: AppColors.divider))),
          child: Row(children: [
            _ActionBtn(icon: Icons.download_outlined,     label: 'Download', onTap: () {}),
            const SizedBox(width: 10),
            _ActionBtn(icon: Icons.email_outlined,        label: 'Email',    onTap: () {}),
            const SizedBox(width: 10),
            _ActionBtn(icon: Icons.share_outlined,        label: 'Share',    onTap: () {}),
            const SizedBox(width: 10),
            _ActionBtn(icon: Icons.copy_outlined,         label: 'Copy',     onTap: () {}),
          ])),
      ]),
    );
  }
}

class _VersionTab extends StatelessWidget {
  final String label; final bool selected; final VoidCallback onTap;
  const _VersionTab({required this.label, required this.selected, required this.onTap});
  @override Widget build(BuildContext context) => Expanded(
    child: GestureDetector(onTap: onTap, child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: selected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(11)),
      child: Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 13,
        fontWeight: FontWeight.w600, color: selected ? Colors.white : AppColors.textMedium)))));
}

class _PdfRow extends StatelessWidget {
  final String label, value;
  const _PdfRow({required this.label, required this.value});
  @override Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: AppTextStyles.sectionLabel),
      Text(value, style: AppTextStyles.cardSubtitle.copyWith(fontWeight: FontWeight.w600, color: AppColors.textDark)),
    ]));
}

class _ActionBtn extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.label, required this.onTap});
  @override Widget build(BuildContext context) => Expanded(
    child: GestureDetector(onTap: onTap,
      child: Container(padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.cardBorder)),
        child: Column(children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.stepLabel.copyWith(color: AppColors.primary)),
        ]))));
}