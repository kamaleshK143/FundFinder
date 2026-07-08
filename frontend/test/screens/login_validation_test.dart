import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundfinderff/Screens/Login/login.dart';

void main() {
  testWidgets('Login shows validation errors on empty submit without calling the network',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Login()));

    // Submitting with both fields empty must stay on the validation path -
    // AuthProvider.login() is only ever called after the form validates, so if
    // it tried to reach the network here (with no Provider in the widget tree)
    // this test would throw instead of showing validation text.
    await tester.tap(find.text('LOGIN'));
    await tester.pump();

    expect(find.text('Please Enter Email'), findsOneWidget);
    expect(find.text('Please Enter Password'), findsOneWidget);
  });

  testWidgets('Login shows only the password error when email is filled in', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Login()));

    await tester.enterText(find.byType(TextFormField).first, 'student@example.com');
    await tester.tap(find.text('LOGIN'));
    await tester.pump();

    expect(find.text('Please Enter Email'), findsNothing);
    expect(find.text('Please Enter Password'), findsOneWidget);
  });
}
