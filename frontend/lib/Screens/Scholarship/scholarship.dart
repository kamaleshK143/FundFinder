class Scholarship {
  final String name;
  final String lastDate;
  final String reward;
  final String eligibility;
  final String about;
  final String deadline;
  final List<dynamic> eligible;
  final List<dynamic> note;
  final String benefits;
  final String logo;
  final List<dynamic> documents;
  final List<dynamic> howToApply;
  final String source;
  final String sourceName;
  final String link;
  final List<String> eligibleClasses;
  final List<dynamic> eligibleGenders;
  final List<dynamic> eligibleStates;

  Scholarship({
    required this.name,
    required this.lastDate,
    required this.reward,
    required this.eligibility,
    required this.about,
    required this.deadline,
    required this.eligible,
    required this.note,
    required this.benefits,
    required this.logo,
    required this.documents,
    required this.howToApply,
    required this.source,
    required this.sourceName,
    required this.link,
    required this.eligibleClasses,
    required this.eligibleGenders,
    required this.eligibleStates,
  });

  factory Scholarship.fromJson(Map<String, dynamic> json) {
    return Scholarship(
      name: json['name'] ?? '',
      lastDate: json['last_date'] ?? '',
      reward: json['reward'] ?? '',
      eligibility: json['eligibility'] ?? '',
      about: json['about'] ?? '',
      deadline: json['deadline'] ?? '',
     eligible: List<String>.from(json['Eligible'] ?? []),
note: List<String>.from(json['note'] ?? []),
      benefits: json['benefits'] ?? '',
      logo: json['logo'] ?? '',
      documents: List<String>.from(json['documents'] ?? []),
howToApply: List<String>.from(json['How_to_apply'] ?? []),
      source: json['source'] ?? '',
      sourceName: json['source_name'] ?? '',
      link: json['link'] ?? '',
      eligibleClasses: List<String>.from(json['eligible_classes'] ?? []),
      eligibleGenders: List<String>.from(json['eligible_genders'] ?? []),
eligibleStates: List<String>.from(json['eligible_states'] ?? []),
    );
  }
}

// class Scholarship {
//   final String name;
//   final String last_date;
//   final String reward;
//   final String eligibility;
//   final String about;
//   final String deadline;
//   final List<dynamic> Eligible;
//   final List<dynamic> note;
//   final String benefits;
//   final String logo;
//   final List<dynamic> documents;
//   final List<dynamic> How_to_apply;
//   final String source;
//   final String source_name;
//   final String link;
//   final List<dynamic> eligible_classes;
//   final List<dynamic> eligible_genders;
//   final List<dynamic> eligible_states;


//   Scholarship({
//     required this.name,
//     required this.last_date,
//     required this.reward,
//     required this.eligibility,
//     required this.about,
//     required this.deadline,
//     required this.Eligible,
//     required this.note,
//     required this.benefits,
//     required this.logo,
//     required this.documents,
//     required this.How_to_apply,
//     required this.source,
//     required this.source_name,
//     required this.link,
//     required this.eligible_classes,
//     required this.eligible_genders,
//     required this.eligible_states,
//   });

//   factory Scholarship.fromJson(Map<String, dynamic> json) {
//     return Scholarship(
//       name: json['name'],
//       last_date: json['last_date'],
//       reward: json['reward'],
//       eligibility: json['eligibility'],
//       about: json['about'],
//       deadline: json['deadline'],
//       Eligible: json['Eligible'] ?? [],
//       note: json['note'] ?? [],
//       benefits: json['benefits'],
//       logo: json['logo'],
//       documents: json['documents'] ?? [],
//       How_to_apply: json['How_to_apply'] ?? [],
//       source: json['source'],
//       source_name: json['source_name'],
//       link: json['link'],
//       eligible_classes: json['eligible_classes'] ?? [],
//       eligible_genders: json['eligible_genders'] ?? [],
//       eligible_states: json['eligible_states'] ?? [],
//     );
//   }

//   static empty() {}
// }
