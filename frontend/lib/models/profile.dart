import 'enums.dart';

class Profile {
  final EducationLevel educationLevel;
  final double annualFamilyIncome;
  final Category category;
  final Gender gender;
  final String state;
  final bool hasDisability;

  Profile({
    required this.educationLevel,
    required this.annualFamilyIncome,
    required this.category,
    required this.gender,
    required this.state,
    required this.hasDisability,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      educationLevel: educationLevelFromString(json['educationLevel']),
      annualFamilyIncome: (json['annualFamilyIncome'] as num).toDouble(),
      category: categoryFromString(json['category']),
      gender: genderFromString(json['gender']),
      state: json['state'],
      hasDisability: json['hasDisability'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'educationLevel': educationLevel.name,
      'annualFamilyIncome': annualFamilyIncome,
      'category': category.name,
      'gender': gender.name,
      'state': state,
      'hasDisability': hasDisability,
    };
  }
}
