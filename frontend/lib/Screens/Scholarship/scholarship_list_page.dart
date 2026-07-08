import 'package:flutter/material.dart';
import 'package:fundfinderff/Screens/Scholarship/scholarship_details.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fundfinderff/Screens/Scholarship/scholarship.dart';
import 'package:fundfinderff/Screens/Scholarship/scholarship_services.dart';
import 'package:fundfinderff/auth/shared_pref.dart';

class ScholarshipListPage extends StatefulWidget {
  const ScholarshipListPage({Key? key}) : super(key: key);

  @override
  _ScholarshipListPageState createState() => _ScholarshipListPageState();
}

class _ScholarshipListPageState extends State<ScholarshipListPage> {
  String? names;
  late Future<List<Scholarship>> _futureScholarships;
  String? userPresentClass;
  String name = "Buddy"; // default name

  @override
  void initState() {
    super.initState();
    loadUserClassAndData();
    _loadUserPreferences();
  }

  Future<void> _loadUserPreferences() async {
    final SharedPreferenceHelper sharedPrefs = SharedPreferenceHelper();
    final fetchedName = await sharedPrefs.getUserName();

    setState(() {
      name = fetchedName ?? "Buddy";
    });
  }

  Future<void> loadUserClassAndData() async {
    userPresentClass = await SharedPreferenceHelper().getUserPresentClass();

    setState(() {
      _futureScholarships =
          ScholarshipService().fetchScholarships().then((allScholarships) {
        if (userPresentClass == null) return [];
        return allScholarships.where((scholarship) {
          return scholarship.eligibleClasses.contains(userPresentClass);
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Container(
        margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello,",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      name ?? "Buddy",
                      style: GoogleFonts.poppins(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Text(
                      "Bringing Opportunities to Your Doorstep",
                      style: GoogleFonts.poppins(
                        color: Colors.black54,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "assets/appicon.png",
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            const SizedBox(height: .0),
            const Divider(color: Colors.black),
            Expanded(
              child: FutureBuilder<List<Scholarship>>(
                future: _futureScholarships,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text("No scholarships found for your class."));
                  }

                  List<Scholarship> filtered = snapshot.data!;
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: filtered.length + 1, // +1 for the new header
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),
                          color: Colors.white,
                          child: Text(
                            'Scholarships for "$userPresentClass"',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF4F8ED5),
                            ),
                          ),
                        );
                      }

                      final scholarship =
                          filtered[index - 1]; // shift index by -1

                      return Card(
                        color: const Color(0xFFF8F9FE),
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        shadowColor: Colors.grey.shade300,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 10, bottom: 10),
                          child: Column(
                            // your existing card content remains here...

                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: ClipOval(
                                      child: Image.network(
                                        scholarship.logo,
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child; // Image loaded successfully
                                          return Center(
                                            child:
                                                CircularProgressIndicator(), // Shows loading indicator while loading
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            "assets/default_image.webp", // Your default image in assets folder
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      overflow: TextOverflow.ellipsis,
                                      scholarship.name,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Last Date:",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 38),
                                    Expanded(
                                        child: Text(
                                      scholarship.lastDate,
                                      style: GoogleFonts.poppins(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Reward:",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    Expanded(
                                      child: Text(
                                        scholarship.reward,
                                        style: GoogleFonts.poppins(
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Eligibility:",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 38,
                                    ),
                                    Expanded(
                                        child: Text(
                                      scholarship.eligibility,
                                      style: GoogleFonts.poppins(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0, bottom: 10),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(115),
                                        ),
                                        backgroundColor: Color(0xFFE9F1FE),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ScholarshipDetailsPage(
                                                    scholarship: scholarship),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Apply",
                                        style: TextStyle(
                                          color: Color(0xFF4F8ED5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:fundfinderff/Scholarship/scholarship.dart';
// import 'package:fundfinderff/Scholarship/scholarship_details.dart';
// import 'package:fundfinderff/Scholarship/scholarship_services.dart';
// import 'package:fundfinderff/auth/shared_pref.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ScholarshipListPage extends StatefulWidget {
//   const ScholarshipListPage({super.key});

//   @override
//   _ScholarshipListPageState createState() => _ScholarshipListPageState();
// }

// class _ScholarshipListPageState extends State<ScholarshipListPage> {
//   String? profile, name, email;
//   late Future<List<Scholarship>> _scholarships;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserPreferences();
//     _scholarships = ScholarshipService().fetchScholarships();
//   }

//   Future<void> _loadUserPreferences() async {
//     final SharedPreferenceHelper sharedPrefs = SharedPreferenceHelper();
//     final userProfile = await sharedPrefs.getUserProfile();
//     final userName = await sharedPrefs.getUserName();
//     final userEmail = await sharedPrefs.getUserEmail();

//     setState(() {
//       profile = userProfile;
//       name = userName ?? "Buddy";
//       email = userEmail;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFFFFFFF),
//       body: Container(
//         margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Hello,",
//                       style: GoogleFonts.poppins(
//                         color: Colors.black,
//                         fontSize: 20.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       name ?? "Buddy",
//                       style: GoogleFonts.poppins(
//                         color: Colors.black,
//                         fontSize: 24.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: Image.asset(
//                     "assets/appicon.png",
//                     height: 50,
//                     width: 50,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20.0),
//             const Divider(color: Colors.black12),
//             Expanded(
//               child: FutureBuilder<List<Scholarship>>(
//                 future: _scholarships,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return const Center(child: Text('No scholarships found.'));
//                   } else {
//                     final scholarships = snapshot.data!;
//                     return ListView.builder(
//                       padding: EdgeInsets.zero,
//                       itemCount: scholarships.length,
//                       itemBuilder: (context, index) {
//                         final scholarship = scholarships[index];
//                         return Card(
//                           color: Color(0xFFF8F9FE),
//                           margin: const EdgeInsets.symmetric(vertical: 10.0),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10.0),
//                           ),
//                           elevation: 5,
//                           shadowColor: Colors.grey.shade300,
//                           child: Padding(
//                             padding: const EdgeInsets.only(
//                                 top: 20.0, left: 10, bottom: 10),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Padding(
//                                       padding:
//                                           const EdgeInsets.only(right: 10.0),
//                                       child: ClipOval(
//                                         child: Image.network(
//                                           scholarship.logo,
//                                           height: 50,
//                                           width: 50,
//                                           fit: BoxFit.cover,
//                                           loadingBuilder: (context, child,
//                                               loadingProgress) {
//                                             if (loadingProgress == null)
//                                               return child; // Image loaded successfully
//                                             return Center(
//                                               child:
//                                                   CircularProgressIndicator(), // Shows loading indicator while loading
//                                             );
//                                           },
//                                           errorBuilder:
//                                               (context, error, stackTrace) {
//                                             return Image.asset(
//                                               "assets/default_image.webp", // Your default image in assets folder
//                                               height: 50,
//                                               width: 50,
//                                               fit: BoxFit.cover,
//                                             );
//                                           },
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     Expanded(
//                                       child: Text(
//                                         overflow: TextOverflow.ellipsis,
//                                         scholarship.name,
//                                         style: GoogleFonts.poppins(
//                                           fontSize: 16.0,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         maxLines: 2,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "Last Date:",
//                                         style: GoogleFonts.poppins(
//                                           color: Colors.grey,
//                                           fontSize: 14.0,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       SizedBox(width: 38),
//                                       Expanded(
//                                           child: Text(
//                                         scholarship.last_date,
//                                         style: GoogleFonts.poppins(
//                                           color: const Color.fromARGB(
//                                               255, 0, 0, 0),
//                                           fontSize: 14.0,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ))
//                                     ],
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "Reward:",
//                                         style: GoogleFonts.poppins(
//                                           color: Colors.grey,
//                                           fontSize: 14.0,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 50,
//                                       ),
//                                       Expanded(
//                                         child: Text(
//                                           scholarship.reward,
//                                           style: GoogleFonts.poppins(
//                                             color: const Color.fromARGB(
//                                                 255, 0, 0, 0),
//                                             fontSize: 14.0,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "Eligibility:",
//                                         style: GoogleFonts.poppins(
//                                           color: Colors.grey,
//                                           fontSize: 14.0,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 38,
//                                       ),
//                                       Expanded(
//                                           child: Text(
//                                         scholarship.eligibility,
//                                         style: GoogleFonts.poppins(
//                                           color: const Color.fromARGB(
//                                               255, 0, 0, 0),
//                                           fontSize: 14.0,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ))
//                                     ],
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(
//                                       left: 8.0, right: 8.0, bottom: 10),
//                                   child: Align(
//                                     alignment: Alignment.center,
//                                     child: SizedBox(
//                                       width: double.infinity,
//                                       child: ElevatedButton(
//                                         style: ElevatedButton.styleFrom(
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(115),
//                                           ),
//                                           backgroundColor: Color(0xFFE9F1FE),
//                                         ),
//                                         onPressed: () {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder: (context) =>
//                                                   ScholarshipDetailsPage(
//                                                       scholarship: scholarship),
//                                             ),
//                                           );
//                                         },
//                                         child: Text(
//                                           "Apply",
//                                           style: TextStyle(
//                                             color: Color(0xFF4F8ED5),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
