import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  // Keys
  static String userIdKey = "USERIDKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userProfileKey = "USERPROFILEKEY";
  static String userPresentClassKey = "USERPRESENTCLASS";
  static String userGenderKey = "USERGENDER";
  static String userStateKey = "USERSTATE";
  static String userReligionKey = "USERRELIGION";

  // Save methods
  Future<bool> saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userIdKey, userId);
  }

  Future<bool> saveUserName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userNameKey, name);
  }

  Future<bool> saveUserEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userEmailKey, email);
  }

  Future<bool> saveUserProfile(String profile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userProfileKey, profile);
  }

  Future<bool> saveUserPresentClass(String presentClass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userPresentClassKey, presentClass);
  }

  Future<bool> saveUserGender(String gender) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userGenderKey, gender);
  }

  Future<bool> saveUserState(String state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userStateKey, state);
  }

  Future<bool> saveUserReligion(String religion) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userReligionKey, religion);
  }

  // Get methods
  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  Future<String?> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userProfileKey);
  }

  Future<String?> getUserPresentClass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userPresentClassKey);
  }

  Future<String?> getUserGender() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userGenderKey);
  }

  Future<String?> getUserState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userStateKey);
  }

  Future<String?> getUserReligion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userReligionKey);
  }

  // Remove all (for logout)
  Future<bool> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }
}


// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPreferenceHelper {
//   static String userIdKey = "USERKEY";
//   static String userNameKey = "USERNAMEKEY";
//   static String userEmailKey = "USEREMAILKEY";
//   static String userProfileKey = "USERPROFILEKEY"; 

//   Future<bool> saveUserId(String getUserId) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.setString(userIdKey, getUserId);
//   }

//   Future<bool> saveUserName(String getUserName) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.setString(userNameKey, getUserName);
//   }

//   Future<bool> saveUserEmail(String getUserEmail) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.setString(userEmailKey, getUserEmail);
//   }
//    Future<bool> saveUserProfile(String getUserProfile) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.setString(userProfileKey, getUserProfile);
//   }

//   Future<String?> getUserId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(userIdKey);
//   }

//   Future<String?> getUserName() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(userNameKey);
//   }

//   Future<String?> getUserEmail() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(userEmailKey);
//   }
//    Future<String?> getUserProfile() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(userProfileKey);
//   }
// }
