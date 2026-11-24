import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_reservation_app/dashboard_page.dart';

void main() {
  testWidgets('shows error when guest name is empty', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardPage()));

    await tester.ensureVisible(find.byKey(const Key('bookNowButton')));
    await tester.tap(find.byKey(const Key('bookNowButton')));
    await tester.pump();

    expect(find.text('Guest name is required'), findsOneWidget);
  });

  testWidgets('clears guest name error when filled', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardPage()));

    await tester.enterText(find.byKey(const Key('guestName')), 'Aminah');
    await tester.ensureVisible(find.byKey(const Key('bookNowButton')));
    await tester.tap(find.byKey(const Key('bookNowButton')));
    await tester.pump();

    expect(find.text('Guest name is required'), findsNothing);
  });

  testWidgets('shows error when email is invalid', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardPage()));

    await tester.enterText(find.byKey(const Key('guestName')), 'Aminah');
    await tester.enterText(find.byKey(const Key('guestEmail')), 'aminah.com');
    await tester.ensureVisible(find.byKey(const Key('bookNowButton')));
    await tester.tap(find.byKey(const Key('bookNowButton')));
    await tester.pump();

    expect(find.text('Enter a valid email'), findsOneWidget);
  });

  testWidgets('shows error when check-out is not after check-in',
      (tester) async {
    final sameDay = DateTime(2026, 12, 1);
    await tester.pumpWidget(
      MaterialApp(
        home: DashboardPage(
          initialCheckIn: sameDay,
          initialCheckOut: sameDay,
        ),
      ),
    );

    await tester.enterText(find.byKey(const Key('guestName')), 'Aminah');
    await tester.enterText(
      find.byKey(const Key('guestEmail')),
      'aminah@example.com',
    );
    await tester.ensureVisible(find.byKey(const Key('bookNowButton')));
    await tester.tap(find.byKey(const Key('bookNowButton')));
    await tester.pump();

    expect(find.text('Check-out must be after check-in'), findsOneWidget);
  });

  testWidgets('shows confirmation when all booking fields are valid',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardPage()));

    await tester.enterText(find.byKey(const Key('guestName')), 'Aminah');
    await tester.enterText(
      find.byKey(const Key('guestEmail')),
      'aminah@example.com',
    );
    await tester.ensureVisible(find.byKey(const Key('bookNowButton')));
    await tester.tap(find.byKey(const Key('bookNowButton')));
    await tester.pump();

    expect(find.text('Booking confirmed for Aminah'), findsOneWidget);
    expect(find.text('Reservation Summary'), findsOneWidget);
  });

  testWidgets('shows error when email is empty', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardPage()));

    await tester.enterText(find.byKey(const Key('guestName')), 'Aminah');
    await tester.ensureVisible(find.byKey(const Key('bookNowButton')));
    await tester.tap(find.byKey(const Key('bookNowButton')));
    await tester.pump();

    expect(find.text('Email is required'), findsOneWidget);
  });

  testWidgets('no email error when email is valid', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardPage()));

    await tester.enterText(find.byKey(const Key('guestName')), 'Aminah');
    await tester.enterText(
      find.byKey(const Key('guestEmail')),
      'aminah@example.com',
    );
    await tester.ensureVisible(find.byKey(const Key('bookNowButton')));
    await tester.tap(find.byKey(const Key('bookNowButton')));
    await tester.pump();

    expect(find.text('Enter a valid email'), findsNothing);
    expect(find.text('Email is required'), findsNothing);
  });

  testWidgets('no date error when check-out is after check-in',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: DashboardPage(
          initialCheckIn: DateTime(2026, 12, 1),
          initialCheckOut: DateTime(2026, 12, 3),
        ),
      ),
    );

    await tester.enterText(find.byKey(const Key('guestName')), 'Aminah');
    await tester.enterText(
      find.byKey(const Key('guestEmail')),
      'aminah@example.com',
    );
    await tester.ensureVisible(find.byKey(const Key('bookNowButton')));
    await tester.tap(find.byKey(const Key('bookNowButton')));
    await tester.pump();

    expect(find.text('Check-out must be after check-in'), findsNothing);
  });
}
