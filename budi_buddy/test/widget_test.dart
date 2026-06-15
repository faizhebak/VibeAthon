import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:budi_buddy/main.dart';
import 'package:budi_buddy/providers/auth_provider.dart';

void main() {
  testWidgets('App starts on the splash screen and navigates to login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
        child: const BudiBuddyApp(),
      ),
    );

    expect(find.text('BudiBuddy'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
