// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

//! Keep if not used

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cookapp/main.dart';

void main() {
  testWidgets('Cooking general tests', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app shows a text saying Cooking
    expect(find.text('Cooking'), findsOneWidget);

    // Verify that when the add button is pressed the app changes page
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle(); // Wait for the animation to finish
    //expect to find a cloud upload icon
    expect(find.byIcon(Icons.cloud_upload_outlined), findsOneWidget);

    //!await tester.pumpWidget(const MyApp());
    //!
    //!// Verify that, in the main page, when pressing the shopping list button, it goes to the shopping list page
    //!await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
    //!await tester.pumpAndSettle(); // Wait for the animation to finish
    //!// Expect to find a add icon
    //!expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
