import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/colonies/screens/colonies_list_screen.dart';
import '../features/colonies/screens/colony_detail_screen.dart';
import '../features/cats/screens/cats_list_screen.dart';
import '../features/cats/screens/cat_detail_screen.dart';
import '../features/cats/screens/add_cat_screen.dart';
import '../features/health/screens/health_records_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/colonies',
        builder: (context, state) => const ColoniesListScreen(),
      ),
      GoRoute(
        path: '/colonies/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ColonyDetailScreen(colonyId: id);
        },
      ),
      GoRoute(
        path: '/colonies/:colonyId/cats',
        builder: (context, state) {
          final colonyId = state.pathParameters['colonyId']!;
          return CatsListScreen(colonyId: colonyId);
        },
      ),
      GoRoute(
        path: '/colonies/:colonyId/cats/:catId',
        builder: (context, state) {
          final colonyId = state.pathParameters['colonyId']!;
          final catId = state.pathParameters['catId']!;
          return CatDetailScreen(colonyId: colonyId, catId: catId);
        },
      ),
      GoRoute(
        path: '/colonies/:colonyId/cats/add',
        builder: (context, state) {
          final colonyId = state.pathParameters['colonyId']!;
          return AddCatScreen(colonyId: colonyId);
        },
      ),
      GoRoute(
        path: '/health/:catId',
        builder: (context, state) {
          final catId = state.pathParameters['catId']!;
          return HealthRecordsScreen(catId: catId);
        },
      ),
    ],
  );
});
