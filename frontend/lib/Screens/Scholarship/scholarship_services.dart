import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:fundfinderff/Screens/Scholarship/scholarship.dart';

class ScholarshipService {
  // Load and parse the scholarships from the JSON file
  Future<List<Scholarship>> fetchScholarships() async {
    try {
      print("Loading JSON file...");

      // Load JSON file as a string
      final String response =
          await rootBundle.loadString('assets/scholarship_data.json');

      print("JSON Loaded Successfully!");

      // Decode the JSON properly
      final List<dynamic> data = json.decode(response);

      print("Decoded Data: $data"); // Debugging

      // Ensure JSON structure matches Scholarship model
      return data.map((json) => Scholarship.fromJson(json)).toList();
    } catch (e) {
      print("Error loading scholarships: $e");
      return [];
    }
  }
}
