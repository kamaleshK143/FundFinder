import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundfinderff/models/enums.dart';
import 'package:fundfinderff/models/scholarship.dart';
import 'package:fundfinderff/widgets/scholarship_card.dart';

Scholarship buildScholarship({
  String name = "Test Scholarship",
  String? providerName = "Test Provider",
  String? rewardAmountText = "Rs 10,000/year",
  bool isAlwaysOpen = false,
  String? applicationDeadline = "2026-12-31",
}) {
  return Scholarship(
    id: 1,
    name: name,
    providerName: providerName,
    description: "A description",
    rewardAmountText: rewardAmountText,
    officialLink: "https://example.com",
    applicationDeadline: applicationDeadline,
    isAlwaysOpen: isAlwaysOpen,
    minEducationLevel: EducationLevel.UNDERGRADUATE,
    maxEducationLevel: EducationLevel.POSTGRADUATE,
    maxAnnualIncome: 450000,
    requiredGender: "ANY",
    requiresDisability: false,
    eligibleCategories: const [],
    eligibleStates: const [],
  );
}

void main() {
  testWidgets('ScholarshipCard renders name, provider, reward and deadline', (tester) async {
    final scholarship = buildScholarship();

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: ScholarshipCard(scholarship: scholarship)),
    ));

    expect(find.text('Test Scholarship'), findsOneWidget);
    expect(find.text('Test Provider'), findsOneWidget);
    expect(find.text('Rs 10,000/year'), findsOneWidget);
    expect(find.text('2026-12-31'), findsOneWidget);
  });

  testWidgets('ScholarshipCard shows "Always open" when isAlwaysOpen is true', (tester) async {
    final scholarship = buildScholarship(isAlwaysOpen: true, applicationDeadline: null);

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: ScholarshipCard(scholarship: scholarship)),
    ));

    expect(find.text('Always open'), findsOneWidget);
  });

  testWidgets('Tapping "View Details" navigates to the details page', (tester) async {
    final scholarship = buildScholarship();

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: ScholarshipCard(scholarship: scholarship)),
    ));

    await tester.tap(find.text('View Details'));
    await tester.pumpAndSettle();

    // The details page shows the scholarship name in its AppBar.
    expect(find.text('Test Scholarship'), findsOneWidget);
    expect(find.text('WHY YOU MATCHED'), findsOneWidget);
  });
}
