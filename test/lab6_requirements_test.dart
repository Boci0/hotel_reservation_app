import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_reservation_app/dashboard_page.dart';
import 'package:hotel_reservation_app/login_page.dart';
import 'package:hotel_reservation_app/main.dart';
import 'package:hotel_reservation_app/room_list_page.dart';
import 'package:hotel_reservation_app/signup_page.dart';

void main() {
  group('Page 1 - Signup Page', () {
    testWidgets('contains required fields, icons, validation, and login link',
        (tester) async {
      await tester.pumpWidget(const HotelReservationApp());

      await tester.ensureVisible(find.byKey(const Key('loginToSignupButton')));
      await tester.tap(find.byKey(const Key('loginToSignupButton')));
      await tester.pumpAndSettle();

      expect(find.byType(SignupPage), findsOneWidget);
      expect(find.byKey(const Key('signupName')), findsOneWidget);
      expect(find.byKey(const Key('signupEmail')), findsOneWidget);
      expect(find.byKey(const Key('signupPassword')), findsOneWidget);
      expect(find.byKey(const Key('signupConfirmPassword')), findsOneWidget);
      expect(find.byKey(const Key('signupSubmit')), findsOneWidget);
      expect(find.byKey(const Key('signupToLoginButton')), findsOneWidget);

      await tester.enterText(find.byKey(const Key('signupName')), 'Rakib');
      await tester.enterText(
          find.byKey(const Key('signupEmail')), 'rakib@example.com');
      await tester.enterText(find.byKey(const Key('signupPhone')), '0123456789');
      await tester.enterText(
          find.byKey(const Key('signupPassword')), 'password123');
      await tester.enterText(
          find.byKey(const Key('signupConfirmPassword')), 'different123');

      await tester.ensureVisible(find.byKey(const Key('signupSubmit')));
      await tester.tap(find.byKey(const Key('signupSubmit')));
      await tester.pump();
      expect(find.text('Passwords do not match'), findsOneWidget);

      await tester.ensureVisible(find.byKey(const Key('signupToLoginButton')));
      await tester.tap(find.byKey(const Key('signupToLoginButton')));
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
    });
  });

  group('Page 2 - Login Page', () {
    testWidgets('accepts username or email and navigates to dashboard',
        (tester) async {
      await tester.pumpWidget(const HotelReservationApp());

      expect(find.byKey(const Key('loginEmail')), findsOneWidget);
      expect(find.byKey(const Key('loginPassword')), findsOneWidget);
      expect(find.byKey(const Key('loginSubmit')), findsOneWidget);
      expect(find.byKey(const Key('loginToSignupButton')), findsOneWidget);

      await tester.enterText(find.byKey(const Key('loginEmail')), 'rakib_user');
      await tester.enterText(
          find.byKey(const Key('loginPassword')), 'secret123');
      await tester.ensureVisible(find.byKey(const Key('loginSubmit')));
      await tester.tap(find.byKey(const Key('loginSubmit')));
      await tester.pumpAndSettle();

      expect(find.byType(DashboardPage), findsOneWidget);
    });
  });

  group('Page 3 - Dashboard Page', () {
    testWidgets('shows welcome, hotel info, images, date pickers, and nav',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          initialRoute: '/dashboard',
          routes: {
            '/': (_) => const LoginPage(),
            '/dashboard': (_) => const DashboardPage(),
            '/rooms': (_) => const RoomListPage(),
            '/signup': (_) => const SignupPage(),
          },
        ),
      );

      expect(find.text('Welcome back, Guest!'), findsOneWidget);
      expect(find.text('Borneo Crest Hotel'), findsOneWidget);
      expect(find.text('About Borneo Crest Hotel'), findsOneWidget);
      expect(find.byType(Image), findsNWidgets(2));
      expect(find.byType(NavigationBar), findsOneWidget);

      await tester.ensureVisible(find.byKey(const Key('checkInButton')));
      await tester.tap(find.byKey(const Key('checkInButton')));
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(const Key('navRoomsButton')));
      await tester.tap(find.byKey(const Key('navRoomsButton')));
      await tester.pumpAndSettle();
      expect(find.byType(RoomListPage), findsOneWidget);
    });
  });

  group('Page 4 - Room List Page', () {
    testWidgets(
        'renders room images, slider, radio buttons, checkboxes, and ExpansionPanelList',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: RoomListPage()));

      expect(find.byKey(const Key('roomPriceSlider')), findsOneWidget);
      expect(find.byKey(const Key('roomTypeRadio_All')), findsOneWidget);
      expect(find.byKey(const Key('roomTypeRadio_Single')), findsOneWidget);
      expect(find.byKey(const Key('roomTypeRadio_Double')), findsOneWidget);
      expect(find.byKey(const Key('roomTypeRadio_Suite')), findsOneWidget);
      expect(find.byKey(const Key('facilityCheckbox_Wi-Fi')), findsOneWidget);
      expect(
          find.byKey(const Key('facilityCheckbox_Breakfast')), findsOneWidget);
      expect(find.byKey(const Key('facilityCheckbox_Parking')), findsOneWidget);
      expect(find.byKey(const Key('facilityCheckbox_Swimming Pool')),
          findsOneWidget);
      expect(find.byType(ExpansionPanelList), findsWidgets);
      expect(find.byType(Image), findsWidgets);

      // Filter by Radio Button (Single)
      await tester.tap(find.byKey(const Key('roomTypeRadio_Single')));
      await tester.pumpAndSettle();
      expect(find.text('Showing 1 of 4 Rooms'), findsOneWidget);
      expect(find.text('Standard Garden Room'), findsOneWidget);
      expect(find.text('Deluxe Riverfront Twin'), findsNothing);

      // Expand ExpansionPanel for additional room details
      ExpansionPanelList panelListBefore =
          tester.widget<ExpansionPanelList>(find.byType(ExpansionPanelList));
      expect(panelListBefore.children.first.isExpanded, isFalse);

      await tester.drag(find.byType(ListView), const Offset(0, -350));
      await tester.pumpAndSettle();
      await tester
          .tap(find.byKey(const Key('expandRoom_Standard Garden Room')));
      await tester.pumpAndSettle();

      ExpansionPanelList panelListAfter =
          tester.widget<ExpansionPanelList>(find.byType(ExpansionPanelList));
      expect(panelListAfter.children.first.isExpanded, isTrue);
      expect(find.text('28 sqm'), findsOneWidget);
      expect(find.text('Select This Room'), findsOneWidget);

      // Filter by Checkbox (Swimming Pool) combined with Single -> empty state
      await tester.drag(find.byType(ListView), const Offset(0, 400));
      await tester.pumpAndSettle();
      await tester
          .tap(find.byKey(const Key('facilityCheckbox_Swimming Pool')));
      await tester.pumpAndSettle();
      expect(find.text('No rooms match your current filters'), findsOneWidget);

      // Reset restores all 4 rooms
      await tester.drag(find.byType(ListView), const Offset(0, 500));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('resetRoomFilters')));
      await tester.pumpAndSettle();
      expect(find.text('Showing 4 of 4 Rooms'), findsOneWidget);

      // Filter by Checkbox (Swimming Pool) alone -> 2 suites
      await tester
          .tap(find.byKey(const Key('facilityCheckbox_Swimming Pool')));
      await tester.pumpAndSettle();
      expect(find.text('Showing 2 of 4 Rooms'), findsOneWidget);

      // Slider filtering reduces visible rooms by budget
      final sliderFinder = find.byKey(const Key('roomPriceSlider'));
      final slider = tester.widget<Slider>(sliderFinder);
      slider.onChanged!(400);
      await tester.pumpAndSettle();
      expect(find.text('Showing 0 of 4 Rooms'), findsOneWidget);
    });
  });
}
