import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fundfinderff/Screens/UserInfo/userinfo.dart';
import 'package:fundfinderff/Screens/BottomBar/bottombar.dart';
import 'package:fundfinderff/Screens/Login/Signin.dart';
import 'package:fundfinderff/Screens/Login/forgotpassword.dart';
import 'package:fundfinderff/services/api_exception.dart';
import 'package:fundfinderff/state/auth_provider.dart';
import 'package:fundfinderff/state/profile_provider.dart';
import 'package:fundfinderff/theme/spacing.dart';
import 'package:fundfinderff/widgets/app_snackbar.dart';
import 'package:fundfinderff/widgets/fade_slide_route.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool textvisible = true;
  bool isSubmitting = false;
  String email = "", password = "";

  final _formkey = GlobalKey<FormState>();

  TextEditingController useremailcontroller = new TextEditingController();
  TextEditingController userpasswordcontroller = new TextEditingController();

  Future<void> userLogin() async {
    setState(() => isSubmitting = true);
    try {
      await context.read<AuthProvider>().login(email, password);

      // Route to the profile form if this user hasn't completed it yet,
      // otherwise straight to the dashboard.
      final profileProvider = context.read<ProfileProvider>();
      await profileProvider.fetchProfile();
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        fadeSlideRoute(profileProvider.hasProfile ? BottomNav() : Userinfo()),
      );
    } on ApiException catch (e) {
      AppSnackBar.show(
        context,
        e.statusCode == 401 ? "Incorrect email or password" : e.message,
        type: SnackBarType.error,
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.school_rounded, size: 56, color: colorScheme.primary),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    "FundFinder",
                    style: GoogleFonts.poppins(
                      color: colorScheme.primary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    "Scholarships matched to you",
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Login",
                              style: GoogleFonts.poppins(fontSize: 22.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            TextFormField(
                              controller: useremailcontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Email';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            TextFormField(
                              controller: userpasswordcontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Password';
                                }
                                return null;
                              },
                              obscureText: textvisible,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.password_outlined),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      textvisible = !textvisible;
                                    });
                                  },
                                  icon: Icon(textvisible ? Icons.visibility : Icons.visibility_off),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPass()));
                                },
                                child: const Text("Forgot Password?"),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isSubmitting
                                    ? null
                                    : () {
                                        if (_formkey.currentState!.validate()) {
                                          setState(() {
                                            email = useremailcontroller.text.trim();
                                            password = userpasswordcontroller.text.trim();
                                          });
                                          userLogin();
                                        }
                                      },
                                child: isSubmitting
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                      )
                                    : const Text("LOGIN"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Signin()));
                    },
                    child: const Text("Don't have an account? Sign up"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
