/// These mirror the backend's Java enums exactly (same identifier spelling)
/// so a value's `.name` can be sent to/parsed from the API with no mapping
/// table to keep in sync.

enum EducationLevel {
  CLASS_8_AND_BELOW,
  CLASS_9,
  CLASS_10,
  CLASS_11,
  CLASS_12,
  UNDERGRADUATE,
  POSTGRADUATE,
  PHD,
}

extension EducationLevelLabel on EducationLevel {
  String get label {
    switch (this) {
      case EducationLevel.CLASS_8_AND_BELOW:
        return 'Class 8 and below';
      case EducationLevel.CLASS_9:
        return 'Class 9';
      case EducationLevel.CLASS_10:
        return 'Class 10';
      case EducationLevel.CLASS_11:
        return 'Class 11';
      case EducationLevel.CLASS_12:
        return 'Class 12';
      case EducationLevel.UNDERGRADUATE:
        return 'Undergraduate';
      case EducationLevel.POSTGRADUATE:
        return 'Postgraduate';
      case EducationLevel.PHD:
        return 'PhD';
    }
  }
}

enum Category { GENERAL, OBC, SC, ST, EWS, MINORITY }

extension CategoryLabel on Category {
  String get label => name;
}

enum Gender { MALE, FEMALE, OTHER }

extension GenderLabel on Gender {
  String get label {
    switch (this) {
      case Gender.MALE:
        return 'Male';
      case Gender.FEMALE:
        return 'Female';
      case Gender.OTHER:
        return 'Other';
    }
  }
}

EducationLevel educationLevelFromString(String value) =>
    EducationLevel.values.firstWhere((e) => e.name == value);

Category categoryFromString(String value) =>
    Category.values.firstWhere((e) => e.name == value);

Gender genderFromString(String value) =>
    Gender.values.firstWhere((e) => e.name == value);

const List<String> indianStates = [
  "Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chhattisgarh",
  "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jharkhand", "Karnataka",
  "Kerala", "Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya",
  "Mizoram", "Nagaland", "Odisha", "Punjab", "Rajasthan", "Sikkim",
  "Tamil Nadu", "Telangana", "Tripura", "Uttar Pradesh", "Uttarakhand",
  "West Bengal"
];
