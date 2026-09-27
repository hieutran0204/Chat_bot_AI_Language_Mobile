// name: app_router.dart
// description: GoRouter configuration with auth guard redirect.
//              Checks AuthCubit state to protect /chat and other authenticated routes.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';

// Placeholder screen until chat feature is built
class PlaceholderChatPage extends StatelessWidget {
  const PlaceholderChatPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.chat_bubble_outline, size: 64, color: Colors.white54),
              const SizedBox(height: 16),
              const Text('Chat coming soon...', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => context.read<AuthCubit>().logout(),
                child: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
              ),
            ],
          ),
        ),
      );
}

GoRouter createRouter(AuthCubit authCubit) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: _AuthCubitListenable(authCubit),
    redirect: (context, state) {
      final authState = authCubit.state;
      final isOnAuth  = state.matchedLocation == '/login' ||
                        state.matchedLocation == '/register';

      if (authState is AuthLoading || authState is AuthInitial) {
        return null; // Don't redirect while session is being checked
      }

      final isAuthenticated = authState is AuthAuthenticated;

      if (isAuthenticated && isOnAuth) {
        return '/chat';
      }

      if (!isAuthenticated && !isOnAuth) {
        return '/login';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) => const PlaceholderChatPage(),
      ),
    ],
  );
}

/// Makes GoRouter listen to AuthCubit state changes for redirect.
class _AuthCubitListenable extends ChangeNotifier {
  late final StreamSubscription<AuthState> _subscription;

  _AuthCubitListenable(AuthCubit cubit) {
    _subscription = cubit.stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
