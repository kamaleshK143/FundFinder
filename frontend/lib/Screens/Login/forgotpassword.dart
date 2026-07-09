import 'package:flutter/material.dart';
import 'package:fundfinderff/Screens/Login/Signin.dart';
import 'package:fundfinderff/theme/spacing.dart';
import 'package:fundfinderff/widgets/app_snackbar.dart';

/// Password reset has no backend endpoint yet (out of scope for this
/// rebuild) - rather than wire this button to nothing or silently remove a
/// visible nav entry point, it's kept as a real screen that's honest about
/// not being implemented yet.
class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  final TextEditingController mailcontroller = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  void showComingSoon() {
    AppSnackBar.show(
      context,
      "Password reset isn't available yet. Please contact support.",
      type: SnackBarType.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Password Recovery")),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.lock_reset_rounded, size: 40, color: colorScheme.primary),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          "Enter your email and we'll help you get back in",
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        TextFormField(
                          controller: mailcontroller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                showComingSoon();
                              }
                            },
                            child: const Text("Send Email"),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Signin()));
                            },
                            child: const Text("Don't have an account? Create one"),
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
