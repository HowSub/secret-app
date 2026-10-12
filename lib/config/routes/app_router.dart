import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:secret/core/service/auth_service.dart';
import 'package:secret/features/auth/presentation/screens/login_screen.dart';
import 'package:secret/features/auth/presentation/screens/register_screen.dart';
import 'package:secret/features/auth/presentation/screens/username_screen.dart';
import 'package:secret/features/chat/presentation/screens/chat_screen.dart';
import 'package:secret/features/home/presentation/screens/home_screen.dart';
import 'package:secret/features/profile/presentation/screens/profile_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  refreshListenable: GetIt.I<AuthService>(),
  redirect: (context, state) {
    final bool isInitialized = GetIt.I<AuthService>().isInitialized;
    final bool isLoggedIn = GetIt.I<AuthService>().isLoggedIn;
    final bool hasUsername = GetIt.I<AuthService>().hasUsername;

    final bool loggingIn =
        state.matchedLocation == '/register' ||
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/username';

    final bool isSplash = state.matchedLocation == '/splash';

    if (!isInitialized) {
      return isSplash ? null : '/splash';
    }

    if (isLoggedIn && !hasUsername) {
      return '/username';
    }

    if (!isLoggedIn) {
      return loggingIn ? null : '/login';
    }

    if (loggingIn || isSplash) {
      return '/home';
    }

    if (loggingIn && hasUsername) {
      return '/home';
    }

    return null;
  },

  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Image.asset('assets/images/app_icon/app_icon_loading.gif'),
        ),
      ),
    ),
    GoRoute(path: '/register', builder: (context, state) => RegisterScreen()),
    GoRoute(path: '/username', builder: (context, state) => UsernameScreen()),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
    GoRoute(path: '/profile', builder: (context, state) => ProfileScreen()),
    GoRoute(
      path: '/chat/:chatRoomId/:partnerName/:partnerId',
      builder: (context, state) {
        final chatRoomId = state.pathParameters['chatRoomId']!;
        final partnerName = state.pathParameters['partnerName']!;
        final partnerId = state.pathParameters['partnerId']!;

        return ChatScreen(
          chatRoomId: chatRoomId,
          partnerName: partnerName,
          partnerId: partnerId,
        );
      },
    ),
  ],
);
