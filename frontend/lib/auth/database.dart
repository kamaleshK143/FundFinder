import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  // Adds basic user info to "users" collection
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  // Adds detailed user info to "UserDetails" collection
  Future addUserDetail(Map<String, dynamic> detailInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("UserDetails")
        .doc(id)
        .set(detailInfoMap);
  }

  // Fetch user detail from "UserDetails" collection using UID
  Future<Map<String, dynamic>?> getUserDetail(String id) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("UserDetails")
          .doc(id)
          .get();

      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching user details: $e");
      return null;
    }
  }
}

// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// //import 'package:firebase_core/firebase_core.dart';

// class DatabaseMethods {
//   Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
//     return await FirebaseFirestore.instance
//         .collection("users")
//         .doc(id)
//         .set(userInfoMap);
//   }
//   Future addUserDetail(
//       Map<String, dynamic> calorieInfoMap, String id) async {
//     return await FirebaseFirestore.instance
//         .collection("UserDetails")
//         .doc(id)
//         .set(calorieInfoMap);
//   }
// }
