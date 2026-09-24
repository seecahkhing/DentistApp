import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../ui/features/bookings/views/booking_detail_screen.dart';
import '../ui/features/bookings/views/booking_form_screen.dart';
import '../ui/features/bookings/views/home_screen.dart';
import '../ui/features/bookings/view_models/bookings_view_model.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter() {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'bookings/new',
            builder: (context, state) => const BookingFormScreen(),
          ),
          GoRoute(
            path: 'bookings/:id',
            builder: (context, state) {
              final id = int.parse(state.pathParameters['id']!);
              return BookingDetailScreen(bookingId: id);
            },
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  final booking = context.read<BookingsViewModel>().byId(id);
                  return BookingFormScreen(booking: booking);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
