// ignore_for_file: unnecessary_import

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fundfinderff/auth/shared_pref.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? profile, name, email;
  bool isLoading = true;

  getthesharedpref() async {
    profile = await SharedPreferenceHelper().getUserProfile();
    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();
  }

  onthisload() async {
    await getthesharedpref();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    onthisload();
    super.initState();
  }

  Future<void> _showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(dialogContext),
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.pop(dialogContext);
                onConfirm();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "FundFinder",
          style: GoogleFonts.megrim(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 45.0, left: 20.0, right: 20.0),
                        height: MediaQuery.of(context).size.height / 4.3,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.elliptical(MediaQuery.of(context).size.width, 105.0),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 6.5),
                          child: Material(
                            elevation: 10.0,
                            borderRadius: BorderRadius.circular(60),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.asset(
                                "assets/appicon.png",
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 70.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              name ?? "User",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 23.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20.0),

                  buildInfoTile(Icons.person, "Name", name ?? "User"),
                  const SizedBox(height: 20.0),

                  buildInfoTile(Icons.email, "Email", email ?? "user@example.com"),
                  const SizedBox(height: 20.0),

                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Terms & Conditions"),
                          content: SingleChildScrollView(
                            child: Text(
                              "By using FundFinder, you agree to the following:\n\n"
                              "1. Your data is used only to suggest scholarships.\n"
                              "2. We do not sell or share your data.\n"
                              "3. You are responsible for the data you provide.\n"
                              "4. FundFinder is not liable for external links or offers.\n\n"
                              "For help, contact: support@fundfinder.com",
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: Text("Close"),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    },
                    child: buildActionTile(Icons.description, "Terms & Conditions"),
                  ),

                  const SizedBox(height: 20.0),

                  GestureDetector(
                    onTap: () {
                      _showConfirmationDialog(
                        context: context,
                        title: "Delete Account",
                        content: "Are you sure you want to delete your account permanently?",
                        onConfirm: () async {
                          try {
                            await FirebaseAuth.instance.currentUser?.delete();
                            await SharedPreferenceHelper().clearUserData();
                            Navigator.pushReplacementNamed(context, "/signin");
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'requires-recent-login') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Please log in again to delete your account."),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error: ${e.message}")),
                              );
                            }
                          }
                        },
                      );
                    },
                    child: buildActionTile(Icons.delete, "Delete Account"),
                  ),

                  const SizedBox(height: 20.0),

                  GestureDetector(
                    onTap: () {
                      _showConfirmationDialog(
                        context: context,
                        title: "Logout",
                        content: "Are you sure you want to logout?",
                        onConfirm: () async {
                          await SharedPreferenceHelper().clearUserData();
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushReplacementNamed(context, "/login");
                        },
                      );
                    },
                    child: buildActionTile(Icons.logout, "Logout"),
                  ),

                  const SizedBox(height: 30.0),
                ],
              ),
            ),
    );
  }

  Widget buildInfoTile(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 2.0,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.black),
              const SizedBox(width: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildActionTile(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 2.0,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.black),
              const SizedBox(width: 20.0),
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// // ignore_for_file: unnecessary_import

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fundfinderff/auth/shared_pref.dart';
// import 'package:google_fonts/google_fonts.dart';

// class Profile extends StatefulWidget {
//   const Profile({super.key});

//   @override
//   State<Profile> createState() => _ProfileState();
// }

// class _ProfileState extends State<Profile> {
//   String? profile, name, email;
//   bool isLoading = true;

//   getthesharedpref() async {
//     profile = await SharedPreferenceHelper().getUserProfile();
//     name = await SharedPreferenceHelper().getUserName();
//     email = await SharedPreferenceHelper().getUserEmail();
//   }

//   onthisload() async {
//     await getthesharedpref();
//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     onthisload();
//     super.initState();
//   }

//   Future<void> _showConfirmationDialog({
//     required BuildContext context,
//     required String title,
//     required String content,
//     required VoidCallback onConfirm,
//   }) {
//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: Text(title),
//           content: Text(content),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () => Navigator.pop(dialogContext),
//             ),
//             TextButton(
//               child: const Text('Confirm'),
//               onPressed: () {
//                 Navigator.pop(dialogContext);
//                 onConfirm();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text(
//           "FundFinder",
//           style: GoogleFonts.megrim(
//             color: Colors.white,
//             fontSize: 40,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.black,
//         elevation: 0,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Stack(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.only(top: 45.0, left: 20.0, right: 20.0),
//                         height: MediaQuery.of(context).size.height / 4.3,
//                         width: MediaQuery.of(context).size.width,
//                         decoration: BoxDecoration(
//                           color: Colors.black,
//                           borderRadius: BorderRadius.vertical(
//                             bottom: Radius.elliptical(MediaQuery.of(context).size.width, 105.0),
//                           ),
//                         ),
//                       ),
//                       Center(
//                         child: Container(
//                           margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 6.5),
//                           child: Material(
//                             elevation: 10.0,
//                             borderRadius: BorderRadius.circular(60),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(60),
//                               child: Image.asset(
//                                 "assets/appicon.png",
//                                 height: 120,
//                                 width: 120,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 70.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               name ?? "Kamalesh",
//                               style: GoogleFonts.poppins(
//                                 color: Colors.white,
//                                 fontSize: 23.0,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             )
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                   const SizedBox(height: 20.0),

//                   // Name Tile
//                   buildInfoTile(Icons.person, "Name", name ?? "Kamalesh"),

//                   const SizedBox(height: 20.0),

//                   // Email Tile
//                   buildInfoTile(Icons.email, "Email", email ?? "kamaleshkumar@gmail.com"),

//                   const SizedBox(height: 20.0),

//                   // Terms Tile
//                   buildInfoTile(Icons.description, "Terms and Condition", ""),

//                   const SizedBox(height: 20.0),

//                   // Delete Account
//                   GestureDetector(
//                     onTap: () {
//                       _showConfirmationDialog(
//                         context: context,
//                         title: "Delete Account",
//                         content: "Are you sure you want to delete your account permanently?",
//                         onConfirm: () async {
//                           try {
//                             await FirebaseAuth.instance.currentUser?.delete();
//                             // Optionally clear shared preferences here
//                             Navigator.pushReplacementNamed(context, "/login");
//                           } catch (e) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text("Error deleting account: $e")),
//                             );
//                           }
//                         },
//                       );
//                     },
//                     child: buildActionTile(Icons.delete, "Delete Account"),
//                   ),

//                   const SizedBox(height: 20.0),

//                   // Logout
//                   GestureDetector(
//                     onTap: () {
//                       _showConfirmationDialog(
//                         context: context,
//                         title: "Logout",
//                         content: "Are you sure you want to logout?",
//                         onConfirm: () async {
//                           await FirebaseAuth.instance.signOut();
//                           Navigator.pushReplacementNamed(context, "/login");
//                         },
//                       );
//                     },
//                     child: buildActionTile(Icons.logout, "Logout"),
//                   ),

//                   const SizedBox(height: 30.0),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget buildInfoTile(IconData icon, String title, String subtitle) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20.0),
//       child: Material(
//         borderRadius: BorderRadius.circular(10),
//         elevation: 2.0,
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Row(
//             children: [
//               Icon(icon, color: Colors.black),
//               const SizedBox(width: 20.0),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: GoogleFonts.poppins(
//                       color: Colors.black,
//                       fontSize: 16.0,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   if (subtitle.isNotEmpty)
//                     Text(
//                       subtitle,
//                       style: GoogleFonts.poppins(
//                         color: Colors.black,
//                         fontSize: 16.0,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildActionTile(IconData icon, String label) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20.0),
//       child: Material(
//         borderRadius: BorderRadius.circular(10),
//         elevation: 2.0,
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Row(
//             children: [
//               Icon(icon, color: Colors.black),
//               const SizedBox(width: 20.0),
//               Text(
//                 label,
//                 style: GoogleFonts.poppins(
//                   color: Colors.black,
//                   fontSize: 16.0,
//                   fontWeight: FontWeight.w600,
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
