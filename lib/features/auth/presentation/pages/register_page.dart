// name: register_page.dart
// description: Registration screen with email, username, and password fields.
//              Connects to AuthCubit and auto-logs-in after successful register.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/app_button.dart';
import '../widgets/auth_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey       = GlobalKey<FormState>();
  final _emailCtrl     = TextEditingController();
  final _usernameCtrl  = TextEditingController();
  final _passwordCtrl  = TextEditingController();
  final _confirmCtrl   = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().register(
          email: _emailCtrl.text.trim(),
          username: _usernameCtrl.text.trim(),
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
                  vertical: context.h(28),
                ),
                child: ResponsiveContainer(
                  maxWidth: 460,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Back Navigation Button ───────────
                        IconButton(
                          onPressed: () => context.go('/login'),
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppColors.textSecondary,
                            size: context.w(18),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        SizedBox(height: context.h(12)),

                        // ── Heading & Subheading ─────────────
                        Text(
                          'Create account ✨',
                          style: AppTypography.displayMedium.copyWith(
                            fontSize: context.sp(26),
                          ),
                        ),
                        AppSpacing.vGapXs,
                        Text(
                          'Start your English learning journey',
                          style: AppTypography.bodyMedium.copyWith(
                            fontSize: context.sp(14),
                          ),
                        ),
                        SizedBox(height: context.h(28)),

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
                        SizedBox(height: context.h(16)),
                        AuthTextField(
                          label: 'Username',
                          hint: 'your_username',
                          controller: _usernameCtrl,
                          validator: (v) =>
                              (v == null || v.trim().length < 3) ? 'Min 3 characters' : null,
                        ),
                        SizedBox(height: context.h(16)),
                        AuthTextField(
                          label: 'Password',
                          hint: '••••••••',
                          controller: _passwordCtrl,
                          isPassword: true,
                          validator: (v) =>
                              (v == null || v.length < 8) ? 'Min 8 characters' : null,
                        ),
                        SizedBox(height: context.h(16)),
                        AuthTextField(
                          label: 'Confirm Password',
                          hint: '••••••••',
                          controller: _confirmCtrl,
                          isPassword: true,
                          textInputAction: TextInputAction.done,
                          validator: (v) =>
                              v != _passwordCtrl.text ? 'Passwords do not match' : null,
                        ),
                        SizedBox(height: context.h(28)),

                        // ── Action Button ────────────────────
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) => AppButton(
                            label: 'Create Account',
                            isLoading: state is AuthLoading,
                            onPressed: state is AuthLoading ? null : _submit,
                          ),
                        ),
                        SizedBox(height: context.h(18)),

                        // ── Login Navigation Link ────────────
                        Center(
                          child: TextButton(
                            onPressed: () => context.go('/login'),
                            child: RichText(
                              text: TextSpan(
                                text: 'Already have an account? ',
                                style: AppTypography.bodyMedium,
                                children: [
                                  TextSpan(
                                    text: 'Login',
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
