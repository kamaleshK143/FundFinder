import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fundfinderff/models/scholarship.dart';
import 'package:fundfinderff/Screens/Scholarship/scholarship_details.dart';

class ScholarshipCard extends StatelessWidget {
  final Scholarship scholarship;

  const ScholarshipCard({super.key, required this.scholarship});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF8F9FE),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      shadowColor: Colors.grey.shade300,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color(0xFFE9F1FE),
                    child: Icon(Icons.school, color: const Color(0xFF4F8ED5)),
                  ),
                ),
                Expanded(
                  child: Text(
                    scholarship.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            if (scholarship.providerName != null) ...[
              const SizedBox(height: 8),
              _infoRow("Provider:", scholarship.providerName!),
            ],
            if (scholarship.rewardAmountText != null) ...[
              const SizedBox(height: 4),
              _infoRow("Reward:", scholarship.rewardAmountText!),
            ],
            const SizedBox(height: 4),
            _infoRow("Deadline:", scholarship.deadlineLabel),
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
                child: Text("View Details", style: TextStyle(color: Color(0xFF4F8ED5))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13.0, fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
