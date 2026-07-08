import 'package:flutter/material.dart';
import 'package:fundfinderff/Screens/BottomBar/bottombar.dart';
import 'package:fundfinderff/auth/database.dart';
import 'package:fundfinderff/auth/shared_pref.dart'; // 👈 Make sure this is imported
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';

class Userinfo extends StatefulWidget {
  const Userinfo({super.key});

  @override
  State<Userinfo> createState() => _UserinfoState();
}

class _UserinfoState extends State<Userinfo> {
  String? selectedClass;
  String? selectedGender;
  String? selectedState;
  String? selectedReligion;
  String? selectedLanguage;

  final List<String> classes = [
    "upto class 8",
    "Class 9",
    "Class 10",
    "Class 11",
    "Class 12",
    "Undergraduate",
    "Postgraduate",
  ];

  final List<String> genders = ["Male", "Female", "Other"];

  final List<String> states = [
    "Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chhattisgarh",
    "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jharkhand", "Karnataka",
    "Kerala", "Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya",
    "Mizoram", "Nagaland", "Odisha", "Punjab", "Rajasthan", "Sikkim",
    "Tamil Nadu", "Telangana", "Tripura", "Uttar Pradesh", "Uttarakhand", "West Bengal"
  ];

  final List<String> religions = [
    "Hindu", "Muslim", "Christian", "Sikh", "Buddhist", "Jain", "Other"
  ];

  final List<String> languages = [
    "Tamil", "Hindi", "English", "Telugu", "Kannada", "Malayalam",
    "Bengali", "Punjabi", "Gujarati", "Marathi", "Other"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 251, 248, 252),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Text(
                  "Tell us More",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Complete your profile to explore relevant opportunities!",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 30),
                buildStyledDropdown("Present Class", classes, (value) {
                  setState(() {
                    selectedClass = value;
                  });
                }, selectedClass),
                SizedBox(height: 20.0),
                buildStyledDropdown("Gender", genders, (value) {
                  setState(() {
                    selectedGender = value;
                  });
                }, selectedGender),
                SizedBox(height: 20.0),
                buildStyledDropdown("State", states, (value) {
                  setState(() {
                    selectedState = value;
                  });
                }, selectedState),
                SizedBox(height: 20.0),
                buildStyledDropdown("Religion", religions, (value) {
                  setState(() {
                    selectedReligion = value;
                  });
                }, selectedReligion),
                SizedBox(height: 20.0),
                buildStyledDropdown("Language", languages, (value) {
                  setState(() {
                    selectedLanguage = value;
                  });
                }, selectedLanguage),
                SizedBox(height: 30.0),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    ),
                    onPressed: () async {
                      if (selectedClass == null ||
                          selectedGender == null ||
                          selectedState == null ||
                          selectedReligion == null ||
                          selectedLanguage == null) {
                        Fluttertoast.showToast(
                          msg: "Please fill all the fields",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                        return;
                      }

                      String id = randomAlphaNumeric(10);
                      Map<String, dynamic> userInfoMap = {
                        "Present Class": selectedClass,
                        "Gender": selectedGender,
                        "State": selectedState,
                        "Religion": selectedReligion,
                        "Language": selectedLanguage,
                        "Id": id,
                      };

                      await DatabaseMethods()
                          .addUserDetail(userInfoMap, id)
                          .then((value) async {
                        await SharedPreferenceHelper().saveUserPresentClass(selectedClass!); // 👇 NEW LINE

                        Fluttertoast.showToast(
                          msg: "User Information added successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => BottomNav()),
                        );
                      }).catchError((error) {
                        Fluttertoast.showToast(
                          msg: "Error adding user information: $error",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      });
                    },
                    child: Text(
                      "Submit",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildStyledDropdown(String label, List<String> items,
      ValueChanged<String?> onChanged, String? selectedValue) {
    final TextStyle commonTextStyle = GoogleFonts.poppins(
      color: const Color.fromARGB(137, 0, 0, 0),
      fontSize: 15.0,
      fontWeight: FontWeight.bold,
    );

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: commonTextStyle,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            hintStyle: commonTextStyle,
          ),
          style: commonTextStyle,
          value: selectedValue,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: commonTextStyle),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:fundfinderff/auth/BottomBar/bottombar.dart';
// import 'package:fundfinderff/auth/database.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:random_string/random_string.dart';

// class Userinfo extends StatefulWidget {
//   const Userinfo({super.key});

//   @override
//   State<Userinfo> createState() => _UserinfoState();
// }

// class _UserinfoState extends State<Userinfo> {
//   String? selectedClass; // For Present Class
//   String? selectedGender; // For Gender
//   String? selectedState; // For State
//   String? selectedReligion; // For Religion
//   String? selectedLanguage; // For Language

//   // Data for dropdowns
//   final List<String> classes = [
//   "upto class 8",
//   "Class 9",
//   "Class 10",
//   "Class 11",
//   "Class 12",
//   "Undergraduate",
//   "Postgraduate",
//   "Postgraduation"
//   ];

//   final List<String> genders = ["Male", "Female", "Other"];

//   final List<String> states = [
//     "Andhra Pradesh",
//     "Arunachal Pradesh",
//     "Assam",
//     "Bihar",
//     "Chhattisgarh",
//     "Goa",
//     "Gujarat",
//     "Haryana",
//     "Himachal Pradesh",
//     "Jharkhand",
//     "Karnataka",
//     "Kerala",
//     "Madhya Pradesh",
//     "Maharashtra",
//     "Manipur",
//     "Meghalaya",
//     "Mizoram",
//     "Nagaland",
//     "Odisha",
//     "Punjab",
//     "Rajasthan",
//     "Sikkim",
//     "Tamil Nadu",
//     "Telangana",
//     "Tripura",
//     "Uttar Pradesh",
//     "Uttarakhand",
//     "West Bengal"
//   ];

//   final List<String> religions = [
//     "Hindu",
//     "Muslim",
//     "Christian",
//     "Sikh",
//     "Buddhist",
//     "Jain",
//     "Other"
//   ];

//   final List<String> languages = [
//     "Tamil",
//     "Hindi",
//     "English",
//     "Telugu",
//     "Kannada",
//     "Malayalam",
//     "Bengali",
//     "Punjabi",
//     "Gujarati",
//     "Marathi",
//     "Other"
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 251, 248, 252),
//       resizeToAvoidBottomInset: true,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 40),
//                 Text(
//                   "Tell us More",
//                   style: GoogleFonts.poppins(
//                     color: Colors.black,
//                     fontSize: 24.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   "Complete your profile to explore relevant opportunities!",
//                   style: GoogleFonts.poppins(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                     color: Colors.grey[700],
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 buildStyledDropdown("Present Class", classes, (value) {
//                   setState(() {
//                     selectedClass = value;
//                   });
//                 }, selectedClass),
//                 const SizedBox(height: 20.0),
//                 buildStyledDropdown("Gender", genders, (value) {
//                   setState(() {
//                     selectedGender = value;
//                   });
//                 }, selectedGender),
//                 const SizedBox(height: 20.0),
//                 buildStyledDropdown("State", states, (value) {
//                   setState(() {
//                     selectedState = value;
//                   });
//                 }, selectedState),
//                 const SizedBox(height: 20.0),
//                 buildStyledDropdown("Religion", religions, (value) {
//                   setState(() {
//                     selectedReligion = value;
//                   });
//                 }, selectedReligion),
//                 const SizedBox(height: 20.0),
//                 buildStyledDropdown("Language", languages, (value) {
//                   setState(() {
//                     selectedLanguage = value;
//                   });
//                 }, selectedLanguage),
//                 const SizedBox(height: 30.0),
//                 Center(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 30, vertical: 15),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       backgroundColor: const Color.fromARGB(255, 0, 0, 0),
//                     ),
//                     onPressed: () async {
//                       if (selectedClass == null ||
//                           selectedGender == null ||
//                           selectedState == null ||
//                           selectedReligion == null ||
//                           selectedLanguage == null) {
//                         Fluttertoast.showToast(
//                           msg: "Please fill all the fields",
//                           toastLength: Toast.LENGTH_SHORT,
//                           gravity: ToastGravity.CENTER,
//                           backgroundColor: Colors.red,
//                           textColor: Colors.white,
//                         );
//                         return;
//                       }

//                       String id = randomAlphaNumeric(10);
//                       Map<String, dynamic> userInfoMap = {
//                         "Present Class": selectedClass,
//                         "Gender": selectedGender,
//                         "State": selectedState,
//                         "Religion": selectedReligion,
//                         "Language": selectedLanguage,
//                         "Id": id,
//                       };
//                       await DatabaseMethods()
//                           .addUserDetail(userInfoMap, id)
//                           .then((value) {
//                         Fluttertoast.showToast(
//                           msg: "User Information added successfully",
//                           toastLength: Toast.LENGTH_SHORT,
//                           gravity: ToastGravity.CENTER,
//                           backgroundColor: Colors.green,
//                           textColor: Colors.white,
//                         );

//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(builder: (context) => BottomNav()),
//                         );
//                       }).catchError((error) {
//                         Fluttertoast.showToast(
//                           msg: "Error adding user information: $error",
//                           toastLength: Toast.LENGTH_SHORT,
//                           gravity: ToastGravity.CENTER,
//                           backgroundColor: Colors.red,
//                           textColor: Colors.white,
//                         );
//                       });
//                     },
//                     child: Text(
//                       "Submit",
//                       style: GoogleFonts.poppins(
//                           color: const Color.fromARGB(255, 255, 254, 254),
//                           fontSize: 18.0,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildStyledDropdown(String label, List<String> items,
//       ValueChanged<String?> onChanged, String? selectedValue) {
//     final TextStyle commonTextStyle = GoogleFonts.poppins(
//       color: const Color.fromARGB(137, 0, 0, 0),
//       fontSize: 15.0,
//       fontWeight: FontWeight.bold,
//     );

//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//         child: DropdownButtonFormField<String>(
//           decoration: InputDecoration(
//             labelText: label,
//             labelStyle: commonTextStyle,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(15),
//               borderSide: BorderSide(color: Colors.black, width: 2),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(15),
//               borderSide: BorderSide(color: Colors.black, width: 2),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(15),
//               borderSide: BorderSide(color: Colors.black, width: 2),
//             ),
//             filled: true,
//             fillColor: Colors.white,
//             contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
//             hintStyle: commonTextStyle,
//           ),
//           style: commonTextStyle, // Apply the style to the input text
//           value: selectedValue,
//           items: items.map((String item) {
//             return DropdownMenuItem<String>(
//               value: item,
//               child: Text(item, style: commonTextStyle),
//             );
//           }).toList(),
//           onChanged: onChanged,
//         ),
//       ),
//     );
//   }
// }
