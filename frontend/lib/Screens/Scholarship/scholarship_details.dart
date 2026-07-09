import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fundfinderff/models/scholarship.dart';
import 'package:fundfinderff/theme/spacing.dart';

class ScholarshipDetailsPage extends StatelessWidget {
  final Scholarship scholarship;

  const ScholarshipDetailsPage({Key? key, required this.scholarship}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(scholarship.name)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (scholarship.providerName != null) ...[
                Text(
                  scholarship.providerName!,
                  style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14.0, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              if (scholarship.description != null) ...[
                Text(
                  scholarship.description!,
                  style: const TextStyle(fontSize: 14.0),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              if (scholarship.rewardAmountText != null)
                _sectionTile(context, Icons.card_giftcard, "REWARD", scholarship.rewardAmountText!),
              _sectionTile(context, Icons.calendar_today, "DEADLINE", scholarship.deadlineLabel),
              _sectionTile(context, Icons.fact_check, "WHY YOU MATCHED", scholarship.eligibilitySummary),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: scholarship.officialLink == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FloatingActionButton.extended(
                onPressed: () {
                  launchUrl(Uri.parse(scholarship.officialLink!), mode: LaunchMode.externalApplication);
                },
                backgroundColor: colorScheme.primary,
                icon: const Icon(Icons.send, color: Colors.white),
                label: Text(
                  "Apply Now",
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _sectionTile(BuildContext context, IconData icon, String title, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: colorScheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: const TextStyle(fontSize: 13.0)),
        ],
      ),
    );
  }
}
