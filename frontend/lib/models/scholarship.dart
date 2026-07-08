import 'enums.dart';

/// Mirrors the backend's ScholarshipResponse. Fields the old bundled JSON
/// used to have (logo URL, long free-text "about", "note", "benefits",
/// "documents", "howToApply") don't exist anymore - the new backend model
/// trades that unstructured text for the genuinely structured eligibility
/// fields the matching engine actually reads.
class Scholarship {
  final int id;
  final String name;
  final String? providerName;
  final String? description;
  final String? rewardAmountText;
  final String? officialLink;
  final String? applicationDeadline;
  final bool isAlwaysOpen;
  final EducationLevel minEducationLevel;
  final EducationLevel maxEducationLevel;
  final double? maxAnnualIncome;
  final String requiredGender;
  final bool requiresDisability;
  final List<String> eligibleCategories;
  final List<String> eligibleStates;

  Scholarship({
    required this.id,
    required this.name,
    this.providerName,
    this.description,
    this.rewardAmountText,
    this.officialLink,
    this.applicationDeadline,
    required this.isAlwaysOpen,
    required this.minEducationLevel,
    required this.maxEducationLevel,
    this.maxAnnualIncome,
    required this.requiredGender,
    required this.requiresDisability,
    required this.eligibleCategories,
    required this.eligibleStates,
  });

  factory Scholarship.fromJson(Map<String, dynamic> json) {
    return Scholarship(
      id: json['id'],
      name: json['name'],
      providerName: json['providerName'],
      description: json['description'],
      rewardAmountText: json['rewardAmountText'],
      officialLink: json['officialLink'],
      applicationDeadline: json['applicationDeadline'],
      isAlwaysOpen: json['isAlwaysOpen'] ?? false,
      minEducationLevel: educationLevelFromString(json['minEducationLevel']),
      maxEducationLevel: educationLevelFromString(json['maxEducationLevel']),
      maxAnnualIncome: json['maxAnnualIncome'] == null
          ? null
          : (json['maxAnnualIncome'] as num).toDouble(),
      requiredGender: json['requiredGender'] ?? 'ANY',
      requiresDisability: json['requiresDisability'] ?? false,
      eligibleCategories: List<String>.from(json['eligibleCategories'] ?? []),
      eligibleStates: List<String>.from(json['eligibleStates'] ?? []),
    );
  }

  String get eligibilitySummary {
    final parts = <String>[];
    parts.add(minEducationLevel == maxEducationLevel
        ? minEducationLevel.label
        : '${minEducationLevel.label} - ${maxEducationLevel.label}');
    parts.add(maxAnnualIncome == null
        ? 'No income limit'
        : 'Family income up to ₹${maxAnnualIncome!.toStringAsFixed(0)}');
    parts.add(eligibleCategories.isEmpty
        ? 'All categories'
        : eligibleCategories.join(', '));
    parts.add(eligibleStates.isEmpty ? 'Open pan-India' : eligibleStates.join(', '));
    if (requiredGender != 'ANY') parts.add('$requiredGender only');
    if (requiresDisability) parts.add('Requires disability status');
    return parts.join(' • ');
  }

  String get deadlineLabel =>
      isAlwaysOpen ? 'Always open' : (applicationDeadline ?? 'Not specified');
}
