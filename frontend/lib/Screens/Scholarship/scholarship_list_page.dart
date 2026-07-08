import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fundfinderff/Screens/UserInfo/userinfo.dart';
import 'package:fundfinderff/state/auth_provider.dart';
import 'package:fundfinderff/state/match_provider.dart';
import 'package:fundfinderff/widgets/scholarship_card.dart';

class ScholarshipListPage extends StatefulWidget {
  const ScholarshipListPage({Key? key}) : super(key: key);

  @override
  _ScholarshipListPageState createState() => _ScholarshipListPageState();
}

class _ScholarshipListPageState extends State<ScholarshipListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MatchProvider>().fetchMatches();
      context.read<AuthProvider>().fetchCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello,",
                          style: GoogleFonts.poppins(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          auth.currentUser?.fullName ?? "there",
                          style: GoogleFonts.poppins(
                              color: const Color.fromARGB(255, 0, 0, 0), fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15.0),
                        Text(
                          "Bringing Opportunities to Your Doorstep",
                          style: GoogleFonts.poppins(color: Colors.black54, fontSize: 14.0, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset("assets/appicon.png", height: 50, width: 50, fit: BoxFit.cover),
                  ),
                ],
              ),
              const Divider(color: Colors.black),
              Expanded(
                child: Consumer<MatchProvider>(
                  builder: (context, matchProvider, _) {
                    if (matchProvider.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (matchProvider.needsProfile) {
                      return _completeProfilePrompt(context);
                    }

                    if (matchProvider.error != null) {
                      return Center(child: Text("Error: ${matchProvider.error}"));
                    }

                    if (matchProvider.matches.isEmpty) {
                      return const Center(child: Text("No matching scholarships found right now."));
                    }

                    return RefreshIndicator(
                      onRefresh: () => matchProvider.fetchMatches(),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: matchProvider.matches.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                '${matchProvider.matches.length} scholarships you\'re eligible for',
                                style: GoogleFonts.poppins(
                                    fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF4F8ED5)),
                              ),
                            );
                          }
                          return ScholarshipCard(scholarship: matchProvider.matches[index - 1]);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _completeProfilePrompt(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.assignment_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "Complete your profile to see matched scholarships",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Userinfo()),
                );
                if (context.mounted) context.read<MatchProvider>().fetchMatches();
              },
              child: Text("Complete Profile"),
            ),
          ],
        ),
      ),
    );
  }
}
