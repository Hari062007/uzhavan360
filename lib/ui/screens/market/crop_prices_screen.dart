import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../data/models/user_role.dart';
import '../../../state/crop_price_provider.dart';
import '../../../state/profile_provider.dart';
import '../../common/voice_speaker_button.dart';
import 'upload_crop_price_screen.dart';
import 'record_transaction_screen.dart';

class CropPricesScreen extends StatelessWidget {
  final bool isTab;

  const CropPricesScreen({super.key, this.isTab = false});

  @override
  Widget build(BuildContext context) {
    final cropProv = Provider.of<CropPriceProvider>(context);
    final profile = Provider.of<ProfileProvider>(context);
    final isTrader = profile.selectedRole == AppRole.trader ||
        profile.selectedRole == AppRole.landownerTrader;

    return DefaultTabController(
      length: 2,
      initialIndex: cropProv.selectedTabIndex,
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        appBar: isTab
            ? AppBar(
                toolbarHeight: 0,
                bottom: TabBar(
                  indicatorColor: AppColors.primaryGreen,
                  labelColor: AppColors.primaryGreen,
                  unselectedLabelColor: AppColors.textMuted,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  tabs: [
                    Tab(icon: const Icon(Icons.storefront), text: context.tr('crop_price_offers')),
                    Tab(icon: const Icon(Icons.verified_outlined), text: context.tr('actual_transactions')),
                  ],
                  onTap: (idx) => cropProv.setSelectedTab(idx),
                ),
              )
            : AppBar(
                title: Text(context.tr('crop_market_prices')),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: VoiceSpeakerButton(textToSpeak: context.tr('crop_market_voice')),
                  ),
                ],
                bottom: TabBar(
                  indicatorColor: AppColors.primaryGreen,
                  labelColor: AppColors.primaryGreen,
                  unselectedLabelColor: AppColors.textMuted,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  tabs: [
                    Tab(icon: const Icon(Icons.storefront), text: context.tr('crop_price_offers')),
                    Tab(icon: const Icon(Icons.verified_outlined), text: context.tr('actual_transactions')),
                  ],
                  onTap: (idx) => cropProv.setSelectedTab(idx),
                ),
              ),
        body: TabBarView(
          children: [
            // TAB 1: TRADER OFFER QUOTES (3-Tier Quality Levels)
            _buildOffersTab(context, cropProv),

            // TAB 2: ACTUAL COMPLETED TRANSACTIONS
            _buildTransactionsTab(context, cropProv),
          ],
        ),
        floatingActionButton: isTrader
            ? FloatingActionButton.extended(
                backgroundColor: const Color(0xFFD97706),
                foregroundColor: Colors.white,
                icon: const Icon(Icons.add_chart),
                label: Text(context.tr('upload_price_now_btn'), style: const TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UploadCropPriceScreen()),
                  );
                },
              )
            : null,
      ),
    );
  }

  Widget _buildOffersTab(BuildContext context, CropPriceProvider cropProv) {
    final lang = Localizations.localeOf(context).languageCode;

    return Column(
      children: [
        // Crucial Transparency Disclaimer Notice
        Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFDE68A)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Color(0xFFB45309), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  context.tr('disclaimer_offers'),
                  style: const TextStyle(fontSize: 12, color: Color(0xFF92400E), height: 1.3),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: cropProv.traderOffers.isEmpty
              ? Center(child: Text(context.tr('no_offers')))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  itemCount: cropProv.traderOffers.length,
                  itemBuilder: (context, index) {
                    final item = cropProv.traderOffers[index];
                    final cropTitle = lang == 'ta' ? item.cropNameTa : item.cropNameEn;
                    final secondaryTitle = lang == 'ta' ? item.cropNameEn : item.cropNameTa;
                    final unitLabel = item.priceUnit == 'quintal' ? context.tr('unit_quintal') : context.tr('unit_kg');

                    return Card(
                      margin: const EdgeInsets.only(bottom: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: AppColors.borderSubtle),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  cropTitle,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.greenLightBg,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '1 $unitLabel',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryGreen,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              secondaryTitle,
                              style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textMuted),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    item.marketOrVillage,
                                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // 3-Tier Quality Price Grid
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceWarmWhite,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildGradeColumn(context.tr('grade_1'), item.grade1Price, const Color(0xFF16A34A)),
                                  Container(height: 36, width: 1, color: AppColors.borderSubtle),
                                  _buildGradeColumn(context.tr('grade_2'), item.grade2Price, const Color(0xFF2563EB)),
                                  Container(height: 36, width: 1, color: AppColors.borderSubtle),
                                  _buildGradeColumn(context.tr('grade_3'), item.grade3Price, const Color(0xFFD97706)),
                                ],
                              ),
                            ),

                            if (item.notes.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Text(
                                '${context.tr('notes_label')}: ${item.notes}',
                                style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontStyle: FontStyle.italic),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTransactionsTab(BuildContext context, CropPriceProvider cropProv) {
    return Column(
      children: [
        // Actual Transaction Banner
        Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFBBF7D0)),
          ),
          child: Row(
            children: [
              const Icon(Icons.verified, color: AppColors.primaryGreen, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  context.tr('disclaimer_actual'),
                  style: const TextStyle(fontSize: 12, color: AppColors.primaryGreenDark, height: 1.3),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RecordTransactionScreen()),
                  );
                },
                child: Text(context.tr('record_sale_btn'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ],
          ),
        ),

        Expanded(
          child: cropProv.actualTransactions.isEmpty
              ? Center(child: Text(context.tr('no_transactions')))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  itemCount: cropProv.actualTransactions.length,
                  itemBuilder: (context, index) {
                    final tx = cropProv.actualTransactions[index];
                    final unitLabel = tx.priceUnit == 'quintal' ? context.tr('unit_quintal') : context.tr('unit_kg');

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: AppColors.borderSubtle),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  tx.cropName,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: tx.isVerified ? AppColors.greenLightBg : const Color(0xFFFEF3C7),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        tx.isVerified ? Icons.verified : Icons.help_outline,
                                        size: 13,
                                        color: tx.isVerified ? AppColors.primaryGreen : const Color(0xFFB45309),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        tx.isVerified ? context.tr('verified') : context.tr('unverified'),
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: tx.isVerified ? AppColors.primaryGreen : const Color(0xFFB45309),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              tx.qualityGradeLabelTa,
                              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.currency_rupee, color: AppColors.primaryGreen, size: 20),
                                    Text(
                                      tx.transactionPrice.toStringAsFixed(0),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.primaryGreenDark,
                                      ),
                                    ),
                                    Text(
                                      ' / $unitLabel',
                                      style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${context.tr('date_label')}: ${tx.transactionDate.day}/${tx.transactionDate.month}/${tx.transactionDate.year}',
                                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${context.tr('location_label')}: ${tx.marketOrVillage}',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildGradeColumn(String label, double price, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.currency_rupee, size: 14, color: color),
            Text(
              price.toStringAsFixed(0),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: color),
            ),
          ],
        ),
      ],
    );
  }
}
