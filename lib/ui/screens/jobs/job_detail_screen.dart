import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/models/job_model.dart';
import '../../../state/job_provider.dart';
import '../../common/uzhavan_button.dart';
import '../../common/voice_speaker_button.dart';

class JobDetailScreen extends StatefulWidget {
  final JobModel job;

  const JobDetailScreen({super.key, required this.job});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  bool _shareContactConsent = true; // Explicit consent toggle
  bool _isApplying = false;

  void _handleApply(JobProvider jobProv) async {
    setState(() => _isApplying = true);

    final phone = StorageService.getPhoneNumber() ?? '';
    final success = await jobProv.applyForJob(
      jobId: widget.job.id,
      shareContactConsent: _shareContactConsent,
      contactPhone: phone,
    );

    setState(() => _isApplying = false);

    if (success && mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.primaryGreen, size: 28),
              SizedBox(width: 10),
              Text('விண்ணப்பம் பதிவானது'),
            ],
          ),
          content: Text(
            _shareContactConsent
                ? 'உங்கள் விண்ணப்பம் மற்றும் தொலைபேசி எண் வேலை தரும் முதலாளிக்கு வெற்றிகரமாக அனுப்பப்பட்டது.'
                : 'உங்கள் விண்ணப்பம் சமர்ப்பிக்கப்பட்டது. உங்கள் தனியுரிமை விருப்பப்படி தொலைபேசி எண் பகிரப்படவில்லை.',
            style: const TextStyle(fontSize: 15, height: 1.3),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: const Text('சரி (OK)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final jobProv = Provider.of<JobProvider>(context);
    final hasApplied = jobProv.hasApplied(widget.job.id);
    final voiceText =
        '${widget.job.titleTa}. ஊர்: ${widget.job.village}. கூலி: நாள் ஒன்றுக்கு ரூபாய் ${widget.job.wageAmount.toStringAsFixed(0)}. பணி நேரம்: ${widget.job.workingHours}.';

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('வேலை விவரம்'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: VoiceSpeakerButton(textToSpeak: voiceText),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Badge & Title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.greenLightBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.job.workType == 'harvesting' ? 'அறுவடை பணி' : 'வேளாண் பணி',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.job.isOpen ? 'திறந்துள்ளது' : 'நிறைவடைந்தது',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: widget.job.isOpen ? AppColors.primaryGreen : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                widget.job.titleTa,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.job.titleEn,
                style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
              ),
              const SizedBox(height: 20),

              // Wage & Hours Highlight Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWarmWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('தினக்கூலி', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.currency_rupee, color: AppColors.primaryGreen, size: 20),
                            Text(
                              widget.job.wageAmount.toStringAsFixed(0),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primaryGreenDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(height: 36, width: 1, color: AppColors.borderSubtle),
                    Column(
                      children: [
                        const Text('பணி நேரம்', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                        const SizedBox(height: 4),
                        Text(
                          widget.job.workingHours,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Detail List
              _buildDetailRow(Icons.location_on_outlined, 'இடம்', '${widget.job.village}, ${widget.job.taluk} வட்டம், ${widget.job.district}'),
              _buildDetailRow(Icons.calendar_month_outlined, 'வேலை நாள்', '${widget.job.workDate.day}/${widget.job.workDate.month}/${widget.job.workDate.year}'),
              _buildDetailRow(Icons.group_outlined, 'தேவைப்படும் ஆட்கள்', '${widget.job.workersRequired} நபர்கள் (சேர்க்கப்பட்டவர்கள்: ${widget.job.workersHired})'),

              if (widget.job.description.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Text('கூடுதல் விவரம்:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWarmWhite,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.job.description,
                    style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.4),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Privacy & Contact Consent Box (Mandatory Requirement 27)
              if (!hasApplied) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.privacy_tip_outlined, color: AppColors.primaryGreen, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'தனியுரிமை மற்றும் தொடர்பு ஒப்புதல்',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGreenDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        activeColor: AppColors.primaryGreen,
                        value: _shareContactConsent,
                        onChanged: (val) {
                          setState(() => _shareContactConsent = val ?? false);
                        },
                        title: const Text(
                          'வேலை அளிக்கும் முதலாளி என்னை நேரடியாகத் தொடர்புகொள்ள என் மொபைல் எண்ணைப் பகிர ஒப்புக்கொள்கிறேன்.',
                          style: TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Action Button
              if (hasApplied)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Color(0xFF0284C7)),
                      SizedBox(width: 8),
                      Text(
                        'நீங்கள் இந்த வேலைக்கு ஏற்கனவே விண்ணப்பித்துள்ளீர்கள்',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0369A1),
                        ),
                      ),
                    ],
                  ),
                )
              else
                UzhavanButton(
                  label: context.tr('apply_job_btn'),
                  icon: Icons.check,
                  isLoading: _isApplying,
                  onPressed: () => _handleApply(jobProv),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primaryGreen),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
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
