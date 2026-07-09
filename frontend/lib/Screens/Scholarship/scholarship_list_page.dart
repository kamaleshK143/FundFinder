import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fundfinderff/Screens/UserInfo/userinfo.dart';
import 'package:fundfinderff/state/auth_provider.dart';
import 'package:fundfinderff/state/match_provider.dart';
import 'package:fundfinderff/theme/spacing.dart';
import 'package:fundfinderff/widgets/scholarship_card.dart';
import 'package:google_fonts/google_fonts.dart';

class ScholarshipListPage extends StatefulWidget {
  const ScholarshipListPage({Key? key}) : super(key: key);

  @override
  _ScholarshipListPageState createState() => _ScholarshipListPageState();
}

class _ScholarshipListPageState extends State<ScholarshipListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MatchProvider>().fetchMatches();
      context.read<AuthProvider>().fetchCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello,",
                          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 16.0),
                        ),
                        Text(
                          auth.currentUser?.fullName ?? "there",
                          style: GoogleFonts.poppins(fontSize: 22.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          "Bringing opportunities to your doorstep",
                          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13.0),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: colorScheme.primaryContainer,
                    child: Icon(Icons.school_rounded, color: colorScheme.onPrimaryContainer),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              const Divider(),
              Expanded(
                child: Consumer<MatchProvider>(
                  builder: (context, matchProvider, _) {
                    if (matchProvider.loading) {
                      return _loadingState(context);
                    }

                    if (matchProvider.needsProfile) {
                      return _completeProfilePrompt(context);
                    }

                    if (matchProvider.error != null) {
                      return _errorState(context, matchProvider);
                    }

                    if (matchProvider.matches.isEmpty) {
                      return _emptyState(context);
                    }

                    return RefreshIndicator(
                      onRefresh: () => matchProvider.fetchMatches(),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: matchProvider.matches.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                              child: Text(
                                '${matchProvider.matches.length} scholarship${matchProvider.matches.length == 1 ? '' : 's'} you\'re eligible for',
                                style: GoogleFonts.poppins(
                                    fontSize: 15, fontWeight: FontWeight.w600, color: colorScheme.primary),
                              ),
                            );
                          }
                          return ScholarshipCard(scholarship: matchProvider.matches[index - 1]);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: AppSpacing.md),
          Text(
            "Finding scholarships for you...",
            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: AppSpacing.md),
            Text(
              "No matching scholarships found right now",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              "Check back later - new scholarships are added regularly.",
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorState(BuildContext context, MatchProvider matchProvider) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: colorScheme.error),
            const SizedBox(height: AppSpacing.md),
            Text(
              "Something went wrong while fetching scholarships",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              matchProvider.error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: () => matchProvider.fetchMatches(),
              child: const Text("Try again"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _completeProfilePrompt(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.assignment_outlined, size: 48, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: AppSpacing.md),
            Text(
              "Complete your profile to see matched scholarships",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Userinfo()),
                );
                if (context.mounted) context.read<MatchProvider>().fetchMatches();
              },
              child: const Text("Complete Profile"),
            ),
          ],
        ),
      ),
    );
  }
}
