import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fundfinderff/Screens/Scholarship/scholarship.dart';

class ScholarshipDetailsPage extends StatelessWidget {
  final Scholarship scholarship;

  const ScholarshipDetailsPage({Key? key, required this.scholarship})
      : super(key: key);

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('Could not launch $url');
      throw 'Could not launch $url';
    }
  }

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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Image.asset("assets/output.jpg"),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 300,
                  child: Text(
                    scholarship.name,
                    style: GoogleFonts.poppins(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Image.network(
                    scholarship.logo,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null)
                        return child; // Image loaded successfully
                      return Center(
                        child: CircularProgressIndicator(), // While loading
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/default_image.webp", // Default image path
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoContainer(scholarship.eligibility, Colors.black,
                    Colors.white, [Color(0xFFA5418A), Color(0xFFF78093)]),
                _buildInfoContainer(
                    scholarship.reward,
                    Color.fromARGB(255, 95, 34, 78),
                    Color.fromARGB(255, 95, 34, 78),
                    [Colors.white, Colors.white]),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              scholarship.about,
              style: GoogleFonts.poppins(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              children: [
                Text(
                  "Source:",
                  style: GoogleFonts.poppins(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    launchUrl(Uri.parse(scholarship.link));
                  },
                  child: Text(
                    scholarship.sourceName,
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.calendar_today),
                SizedBox(width: 10),
                Text(
                  "DEADLINE",
                  style: GoogleFonts.poppins(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              scholarship.deadline,
              style: GoogleFonts.poppins(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.person),
                SizedBox(width: 10),
                Text(
                  "ELIGIBILITY",
                  style: GoogleFonts.poppins(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "To be eligible , an applicant must:",
              style: GoogleFonts.poppins(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align to left side
                children: scholarship.eligible.map((e) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check, size: 14),
                        SizedBox(width: 5), // Small space between icon and text
                        Expanded(
                          child: Text(
                            e,
                            style: GoogleFonts.poppins(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )).toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "NOTE:-",
              style: GoogleFonts.poppins(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align to left side
                children: scholarship.note
                    .map((e) => Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.check, size: 14),
                            SizedBox(
                                width: 5), // Small space between icon and text
                            Expanded(
                              child: Text(
                                e,
                                style: GoogleFonts.poppins(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.verified),
                SizedBox(width: 10),
                Text(
                  "BENEFITS",
                  style: GoogleFonts.poppins(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              scholarship.benefits,
              style: GoogleFonts.poppins(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.document_scanner_sharp),
                SizedBox(width: 10),
                Text(
                  "DOCUMENTS",
                  style: GoogleFonts.poppins(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align to left side
                children: scholarship.documents
                    .map((e) => Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.check, size: 14),
                            SizedBox(
                                width: 5), // Small space between icon and text
                            Expanded(
                              child: Text(
                                e,
                                style: GoogleFonts.poppins(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.thumb_up),
                SizedBox(width: 10),
                Text(
                  "HOW TO APPLY",
                  style: GoogleFonts.poppins(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align to left side
                children: scholarship.howToApply.map((e) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check, size: 14),
                        SizedBox(width: 5), // Small space between icon and text
                        Expanded(
                          child: Text(
                            e,
                            style: GoogleFonts.poppins(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )).toList(),
              ),
            ),
          ),
        ]),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10), // Adjust button position
        child: FloatingActionButton.extended(
          onPressed: () {
            launchUrl(Uri.parse(scholarship.link));
          }, // Open application link
          backgroundColor: Color(0xFF0466C9),
          icon: Icon(Icons.send, color: Colors.white),
          label: Text(
            "Apply Now",
            style: GoogleFonts.poppins(
              color: const Color.fromARGB(255, 255, 255, 255),
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerFloat, // Place button at bottom center
    );
  }

  Widget _buildInfoContainer(
      String text, Color borderColor, Color textColor, List<Color> gradient) {
    return Container(
      width: 170,
      height: 30,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 1, top: 4),
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 11.0, fontWeight: FontWeight.bold, color: textColor),
        ),
      ),
    );
  }
}
