import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fundfinderff/models/scholarship.dart';

class ScholarshipDetailsPage extends StatelessWidget {
  final Scholarship scholarship;

  const ScholarshipDetailsPage({Key? key, required this.scholarship}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          scholarship.name,
          style: GoogleFonts.poppins(
            color: const Color.fromARGB(255, 0, 0, 0),
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (scholarship.providerName != null) ...[
                Text(
                  scholarship.providerName!,
                  style: GoogleFonts.poppins(color: Colors.grey[700], fontSize: 14.0, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 16),
              ],
              if (scholarship.description != null) ...[
                Text(
                  scholarship.description!,
                  style: GoogleFonts.poppins(fontSize: 14.0, color: Colors.black87),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 20),
              ],
              if (scholarship.rewardAmountText != null)
                _sectionTile(Icons.card_giftcard, "REWARD", scholarship.rewardAmountText!),
              _sectionTile(Icons.calendar_today, "DEADLINE", scholarship.deadlineLabel),
              _sectionTile(Icons.fact_check, "WHY YOU MATCHED", scholarship.eligibilitySummary),
              SizedBox(height: 80),
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
                backgroundColor: Color(0xFF0466C9),
                icon: Icon(Icons.send, color: Colors.white),
                label: Text(
                  "Apply Now",
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _sectionTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20),
              SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(fontSize: 13.0, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
