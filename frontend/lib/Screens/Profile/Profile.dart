import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fundfinderff/Screens/Login/login.dart';
import 'package:fundfinderff/state/auth_provider.dart';
import 'package:fundfinderff/state/profile_provider.dart';
import 'package:fundfinderff/state/theme_provider.dart';
import 'package:fundfinderff/theme/spacing.dart';
import 'package:fundfinderff/widgets/fade_slide_route.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await context.read<AuthProvider>().fetchCurrentUser();
    await context.read<ProfileProvider>().fetchProfile();
    if (mounted) setState(() => isLoading = false);
  }

  Future<void> _showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(dialogContext),
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.pop(dialogContext);
                onConfirm();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final colorScheme = Theme.of(context).colorScheme;
    final name = auth.currentUser?.fullName;
    final email = auth.currentUser?.email;

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: const Text("Profile")),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 44,
                          backgroundColor: colorScheme.primaryContainer,
                          child: Icon(Icons.person, size: 44, color: colorScheme.onPrimaryContainer),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          name ?? "User",
                          style: GoogleFonts.poppins(fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _sectionLabel(context, "Account"),
                  const SizedBox(height: AppSpacing.sm),
                  buildInfoTile(context, Icons.person_outline, "Name", name ?? "User"),
                  const SizedBox(height: AppSpacing.sm),
                  buildInfoTile(context, Icons.email_outlined, "Email", email ?? "user@example.com"),
                  const SizedBox(height: AppSpacing.xl),
                  _sectionLabel(context, "Preferences"),
                  const SizedBox(height: AppSpacing.sm),
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, _) => Card(
                      child: SwitchListTile(
                        secondary: const Icon(Icons.dark_mode_outlined),
                        title: const Text("Dark Mode"),
                        value: themeProvider.isDarkMode,
                        onChanged: (value) => themeProvider.setDarkMode(value),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _sectionLabel(context, "More"),
                  const SizedBox(height: AppSpacing.sm),
                  buildActionTile(
                    context,
                    Icons.description_outlined,
                    "Terms & Conditions",
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Terms & Conditions"),
                          content: const SingleChildScrollView(
                            child: Text(
                              "By using FundFinder, you agree to the following:\n\n"
                              "1. Your data is used only to suggest scholarships.\n"
                              "2. We do not sell or share your data.\n"
                              "3. You are responsible for the data you provide.\n"
                              "4. FundFinder is not liable for external links or offers.\n\n"
                              "For help, contact: support@fundfinder.com",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text("Close"),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  buildActionTile(
                    context,
                    Icons.delete_outline,
                    "Delete Account",
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Account deletion isn't available yet.")),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  buildActionTile(
                    context,
                    Icons.logout,
                    "Logout",
                    iconColor: colorScheme.error,
                    onTap: () {
                      _showConfirmationDialog(
                        context: context,
                        title: "Logout",
                        content: "Are you sure you want to logout?",
                        onConfirm: () async {
                          await context.read<AuthProvider>().logout();
                          context.read<ProfileProvider>().reset();
                          if (!mounted) return;
                          Navigator.pushAndRemoveUntil(
                            context,
                            fadeSlideRoute(Login()),
                            (route) => false,
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
    );
  }

  Widget _sectionLabel(BuildContext context, String label) {
    return Text(
      label.toUpperCase(),
      style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget buildInfoTile(BuildContext context, IconData icon, String title, String subtitle) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
      ),
    );
  }

  Widget buildActionTile(BuildContext context, IconData icon, String label,
      {required VoidCallback onTap, Color? iconColor}) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: iconColor)),
        onTap: onTap,
      ),
    );
  }
}
