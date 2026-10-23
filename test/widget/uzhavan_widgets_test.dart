import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uzhavan360/data/models/user_role.dart';
import 'package:uzhavan360/ui/common/uzhavan_button.dart';
import 'package:uzhavan360/ui/common/role_badge.dart';
import 'package:uzhavan360/ui/common/stat_card.dart';

void main() {
  group('UI Widget Tests for Senior-Friendly Components', () {
    testWidgets('UzhavanButton displays text and triggers callback', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UzhavanButton(
              label: 'தொடரவும்',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('தொடரவும்'), findsOneWidget);
      await tester.tap(find.byType(UzhavanButton));
      expect(tapped, isTrue);
    });

    testWidgets('UzhavanButton displays loading indicator when isLoading is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UzhavanButton(
              label: 'ஏற்றுகிறது',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('ஏற்றுகிறது'), findsNothing);
    });

    testWidgets('RoleBadge displays Tamil role title and verified badge for official', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RoleBadge(
              role: AppRole.panchayatOfficial,
              isVerified: true,
              isSelected: true,
            ),
          ),
        ),
      );

      expect(find.text('பஞ்சாயத்து அலுவலக அதிகாரி'), findsOneWidget);
      expect(find.byIcon(Icons.verified), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('StatCard displays title, subtitle and badge', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatCard(
              title: 'வேளாண் வேலைகள்',
              subtitle: '10 வேலைகள் உள்ளன',
              badgeText: 'புதியது',
              icon: Icons.work,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('வேளாண் வேலைகள்'), findsOneWidget);
      expect(find.text('10 வேலைகள் உள்ளன'), findsOneWidget);
      expect(find.text('புதியது'), findsOneWidget);

      await tester.tap(find.byType(StatCard));
      expect(tapped, isTrue);
    });
  });
}
