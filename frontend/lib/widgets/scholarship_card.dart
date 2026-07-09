import 'package:flutter/material.dart';
import 'package:fundfinderff/models/scholarship.dart';
import 'package:fundfinderff/Screens/Scholarship/scholarship_details.dart';
import 'package:fundfinderff/theme/spacing.dart';
import 'package:google_fonts/google_fonts.dart';

class ScholarshipCard extends StatelessWidget {
  final Scholarship scholarship;

  const ScholarshipCard({super.key, required this.scholarship});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Icon(Icons.school, color: colorScheme.onPrimaryContainer),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scholarship.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      if (scholarship.providerName != null)
                        Text(
                          scholarship.providerName!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13.0),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (scholarship.rewardAmountText != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                scholarship.rewardAmountText!,
                style: GoogleFonts.poppins(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.secondary,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                _badge(context, Icons.event_outlined, scholarship.deadlineLabel),
                if (scholarship.eligibleCategories.isNotEmpty)
                  _badge(context, Icons.groups_outlined, scholarship.eligibleCategories.join(', ')),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScholarshipDetailsPage(scholarship: scholarship),
                    ),
                  );
                },
                child: const Text("View Details"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(BuildContext context, IconData icon, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
