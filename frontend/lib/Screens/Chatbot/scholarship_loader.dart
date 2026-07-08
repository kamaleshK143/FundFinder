import 'dart:convert';
import 'package:flutter/services.dart';

class Scholarship {
  final String name;
  final String about;
  final String reward;
  final String link;
  final List<String> eligibility;

  Scholarship({
    required this.name,
    required this.about,
    required this.reward,
    required this.link,
    required this.eligibility,
  });

  factory Scholarship.fromJson(Map<String, dynamic> json) {
    return Scholarship(
      name: json['name'] ?? 'Unknown',
      about: json['about'] ?? 'No details available.',
      reward: json['reward'] ?? 'Not specified',
      link: json['link'] ?? '#',
      eligibility: List<String>.from(json['Eligible'] ?? []),
    );
  }
}

class ScholarshipLoader {
  static List<Scholarship> _cachedScholarships = [];

  /// Loads scholarships from JSON file
  static Future<void> loadScholarships() async {
    if (_cachedScholarships.isNotEmpty) return;

    try {
      final String response =
      await rootBundle.loadString('assets/scholarship.json');
      final List<dynamic> data = json.decode(response);
      _cachedScholarships =
          data.map((json) => Scholarship.fromJson(json)).toList();
    } catch (e) {
      print("Error loading scholarships: $e");
    }
  }

  /// Filters scholarships based on user's answers
  static List<Scholarship> filterScholarships(List<String> userAnswers) {
    return _cachedScholarships.where((scholarship) {
      return userAnswers.any((answer) =>
          scholarship.eligibility.any(
                  (criteria) =>
                  criteria.toLowerCase().contains(answer.toLowerCase())));
    }).toList();
  }

  /// Searches for a scholarship by name
  static Scholarship searchScholarshipByName(String name) {
    try {
      return _cachedScholarships.firstWhere(
            (scholarship) =>
        scholarship.name.toLowerCase() == name.toLowerCase(),
        orElse: () =>
            Scholarship(
              name: "Not Found",
              about: "No matching scholarship found.",
              reward: "-",
              link: "#",
              eligibility: [],
            ),
      );
    } catch (e) {
      print("Error searching for scholarship: $e");
      return Scholarship(
        name: "Error",
        about: "An error occurred while searching.",
        reward: "-",
        link: "#",
        eligibility: [],
      );
    }
  }
}