// name: login_page.dart
// description: Login screen with email + password fields matching FastAPI schema.
//              Connects to AuthCubit and redirects on AuthAuthenticated.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/app_button.dart';
import '../widgets/auth_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey       = GlobalKey<FormState>();
  final _emailCtrl     = TextEditingController();
  final _passwordCtrl  = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().login(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go('/chat');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: AppSpacing.roundedSm),
            ),
          );
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppColors.bgGradient),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(28),
                  vertical: context.h(32),
                ),
                child: ResponsiveContainer(
                  maxWidth: 460,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Brand Logo Icon ──────────────────
                        Center(
                          child: Container(
                            width: context.w(68),
                            height: context.w(68),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(context.r(20)),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.35),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                              size: context.w(30),
                            ),
                          ),
                        ),
                        SizedBox(height: context.h(28)),

                        // ── Heading & Subheading ─────────────
                        Text(
                          'Welcome back 👋',
                          style: AppTypography.displayMedium.copyWith(
                            fontSize: context.sp(26),
                          ),
                        ),
                        AppSpacing.vGapXs,
                        Text(
                          'Login to continue learning English',
                          style: AppTypography.bodyMedium.copyWith(
                            fontSize: context.sp(14),
                          ),
                        ),
                        SizedBox(height: context.h(32)),

                        // ── Form Input Fields ────────────────
                        AuthTextField(
                          label: 'Email',
                          hint: 'you@example.com',
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Required';
                            final emailReg = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,}$');
                            if (!emailReg.hasMatch(v.trim())) return 'Invalid email';
                            return null;
                          },
                        ),
                        SizedBox(height: context.h(18)),
                        AuthTextField(
                          label: 'Password',
                          hint: '••••••••',
                          controller: _passwordCtrl,
                          isPassword: true,
                          textInputAction: TextInputAction.done,
                          validator: (v) =>
                              (v == null || v.length < 8) ? 'Min 8 characters' : null,
                        ),
                        SizedBox(height: context.h(28)),

                        // ── Action Button ────────────────────
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) => AppButton(
                            label: 'Login',
                            isLoading: state is AuthLoading,
                            onPressed: state is AuthLoading ? null : _submit,
                          ),
                        ),
                        SizedBox(height: context.h(18)),

                        // ── Sign Up Navigation Link ──────────
                        Center(
                          child: TextButton(
                            onPressed: () => context.go('/register'),
                            child: RichText(
                              text: TextSpan(
                                text: "Don't have an account? ",
                                style: AppTypography.bodyMedium,
                                children: [
                                  TextSpan(
                                    text: 'Sign up',
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: AppColors.primaryLight,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
