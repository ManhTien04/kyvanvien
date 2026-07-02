import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kyvanvien/main.dart';
import 'package:kyvanvien/view/LoginRegisterPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Login test', (WidgetTester tester) async {
    // Mock the SharedPreferences
    SharedPreferences.setMockInitialValues({});

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(homePage: LoginRegisterPage()));

    // Verify the login form is shown
    expect(find.byType(LoginRegisterPage), findsOneWidget);

    // Fill out the form
    await tester.enterText(find.byKey(Key('emailField')), 'test@example.com');
    await tester.enterText(find.byKey(Key('passwordField')), 'password');

    // Tap the login button and trigger a frame
    await tester.tap(find.byKey(Key('loginButton')));
    await tester.pumpAndSettle();

    // Verify that token is stored in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    expect(token, isNotNull);
  });
}