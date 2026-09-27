// name: main.dart
// description: App entry point. Initializes DI, loads .env variables, checks auth status,
//              and builds MaterialApp with GoRouter and AuthCubit at root.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'core/constants/app_theme.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('Warning: .env file not found or failed to load: $e');
  }
  await configureDependencies();
  runApp(const LanguageAIApp());
}

class LanguageAIApp extends StatefulWidget {
  const LanguageAIApp({super.key});

  @override
  State<LanguageAIApp> createState() => _LanguageAIAppState();
}

class _LanguageAIAppState extends State<LanguageAIApp> {
  late final AuthCubit _authCubit;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authCubit = getIt<AuthCubit>();
    _router = createRouter(_authCubit);
    // Check stored JWT on startup
    _authCubit.checkAuthStatus();
  }

  @override
  void dispose() {
    _authCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authCubit,
      child: MaterialApp.router(
        title: 'Language AI — English Tutor',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        routerConfig: _router,
      ),
    );
  }
}
