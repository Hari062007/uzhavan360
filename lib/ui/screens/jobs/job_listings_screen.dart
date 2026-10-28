import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../data/models/user_role.dart';
import '../../../state/job_provider.dart';
import '../../../state/profile_provider.dart';
import '../../common/empty_state_view.dart';
import '../../common/voice_speaker_button.dart';
import 'job_detail_screen.dart';
import 'post_job_screen.dart';

class JobListingsScreen extends StatelessWidget {
  final bool isTab;

  const JobListingsScreen({super.key, this.isTab = false});

  @override
  Widget build(BuildContext context) {
    final jobProv = Provider.of<JobProvider>(context);
    final profile = Provider.of<ProfileProvider>(context);
    final lang = Localizations.localeOf(context).languageCode;
    final canPost = profile.selectedRole == AppRole.owner ||
        profile.selectedRole == AppRole.workerLandowner ||
        profile.selectedRole == AppRole.landownerTrader;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: isTab
          ? null
          : AppBar(
              title: Text(context.tr('jobs_title')),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: VoiceSpeakerButton(textToSpeak: context.tr('job_listings_voice')),
                ),
              ],
            ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                _buildFilterChip(context, jobProv, '', context.tr('all_jobs')),
                const SizedBox(width: 8),
                _buildFilterChip(context, jobProv, 'harvesting', context.tr('harvesting')),
                const SizedBox(width: 8),
                _buildFilterChip(context, jobProv, 'weeding', context.tr('sowing_weeding')),
                const SizedBox(width: 8),
                _buildFilterChip(context, jobProv, 'machinery', context.tr('machinery_climbing')),
              ],
            ),
          ),
          const Divider(height: 1),

          // List of Jobs
          Expanded(
            child: jobProv.isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen))
                : jobProv.jobs.isEmpty
                    ? EmptyStateView(
                        title: context.tr('no_jobs_title'),
                        subtitle: context.tr('no_jobs_sub'),
                        icon: Icons.work_off_outlined,
                      )
                    : RefreshIndicator(
                        color: AppColors.primaryGreen,
                        onRefresh: () => jobProv.loadJobs(),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: jobProv.jobs.length,
                          itemBuilder: (context, index) {
                            final job = jobProv.jobs[index];
                            final hasApplied = jobProv.hasApplied(job.id);
                            final jobTitle = lang == 'ta' ? job.titleTa : job.titleEn;
                            final secondaryTitle = lang == 'ta' ? job.titleEn : job.titleTa;

                            return Card(
                              margin: const EdgeInsets.only(bottom: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: const BorderSide(color: AppColors.borderSubtle),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => JobDetailScreen(job: job),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: AppColors.greenLightBg,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              '${job.village}, ${job.district}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryGreen,
                                              ),
                                            ),
                                          ),
                                          if (hasApplied)
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFE0F2FE),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                context.tr('applied_badge'),
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF0369A1),
                                                ),
                                              ),
                                            )
                                          else
                                            Text(
                                              '${job.workersRequired - job.workersHired} ${context.tr('workers_needed_label')}',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.warning,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        jobTitle,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        secondaryTitle,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.currency_rupee, size: 20, color: AppColors.primaryGreen),
                                              Text(
                                                '${job.wageAmount.toStringAsFixed(0)} ',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w900,
                                                  color: AppColors.primaryGreenDark,
                                                ),
                                              ),
                                              Text(
                                                job.wageBasis == 'daily' ? context.tr('per_day_unit') : context.tr('per_acre'),
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: AppColors.textSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textMuted),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${job.workDate.day}/${job.workDate.month}/${job.workDate.year}',
                                                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: canPost
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: Text(context.tr('post_job_fab'), style: const TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PostJobScreen()),
                );
              },
            )
          : null,
    );
  }

  Widget _buildFilterChip(BuildContext context, JobProvider prov, String code, String label) {
    final isSelected = prov.selectedWorkType == code;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primaryGreen,
      backgroundColor: AppColors.surfaceWarmWhite,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (_) => prov.setWorkTypeFilter(code),
    );
  }
}
