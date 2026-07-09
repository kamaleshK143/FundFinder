import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fundfinderff/Screens/BottomBar/bottombar.dart';
import 'package:fundfinderff/models/enums.dart';
import 'package:fundfinderff/models/profile.dart';
import 'package:fundfinderff/state/profile_provider.dart';
import 'package:fundfinderff/theme/spacing.dart';
import 'package:fundfinderff/widgets/app_snackbar.dart';
import 'package:fundfinderff/widgets/fade_slide_route.dart';
import 'package:google_fonts/google_fonts.dart';

/// Every field here maps directly onto something EligibilityDecisionEngine
/// actually reads (see backend MatchCriteria) - unlike the old version of
/// this form, which also collected Religion and Language and never used
/// either for matching.
class Userinfo extends StatefulWidget {
  const Userinfo({super.key});

  @override
  State<Userinfo> createState() => _UserinfoState();
}

class _UserinfoState extends State<Userinfo> {
  EducationLevel? selectedEducationLevel;
  Gender? selectedGender;
  String? selectedState;
  Category? selectedCategory;
  String? selectedDisability;
  final TextEditingController incomeController = TextEditingController();
  bool isSubmitting = false;

  final List<String> yesNo = ["No", "Yes"];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tell us more",
                    style: GoogleFonts.poppins(fontSize: 26.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    "Complete your profile to see scholarships you're actually eligible for.",
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _sectionLabel(context, "Education & Income"),
                  const SizedBox(height: AppSpacing.sm),
                  buildStyledDropdown<EducationLevel>(
                    "Education Level",
                    EducationLevel.values,
                    (level) => level.label,
                    (value) => setState(() => selectedEducationLevel = value),
                    selectedEducationLevel,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: incomeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Annual Family Income (₹)",
                      prefixIcon: Icon(Icons.currency_rupee),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _sectionLabel(context, "Personal Details"),
                  const SizedBox(height: AppSpacing.sm),
                  buildStyledDropdown<Category>(
                    "Category",
                    Category.values,
                    (category) => category.label,
                    (value) => setState(() => selectedCategory = value),
                    selectedCategory,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  buildStyledDropdown<Gender>(
                    "Gender",
                    Gender.values,
                    (gender) => gender.label,
                    (value) => setState(() => selectedGender = value),
                    selectedGender,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  buildStyledDropdown<String>(
                    "State",
                    indianStates,
                    (state) => state,
                    (value) => setState(() => selectedState = value),
                    selectedState,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  buildStyledDropdown<String>(
                    "Do you have a disability?",
                    yesNo,
                    (value) => value,
                    (value) => setState(() => selectedDisability = value),
                    selectedDisability,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : submit,
                      child: isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text("Submit"),
                    ),
                  ),
                ],
              ),
            ),
          ),
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

  Future<void> submit() async {
    final income = double.tryParse(incomeController.text.trim());

    if (selectedEducationLevel == null ||
        selectedGender == null ||
        selectedState == null ||
        selectedCategory == null ||
        selectedDisability == null ||
        income == null) {
      AppSnackBar.show(context, "Please fill all the fields correctly", type: SnackBarType.error);
      return;
    }

    setState(() => isSubmitting = true);
    try {
      final profile = Profile(
        educationLevel: selectedEducationLevel!,
        annualFamilyIncome: income,
        category: selectedCategory!,
        gender: selectedGender!,
        state: selectedState!,
        hasDisability: selectedDisability == "Yes",
      );
      await context.read<ProfileProvider>().saveProfile(profile);

      AppSnackBar.show(context, "Profile saved successfully", type: SnackBarType.success);

      if (!mounted) return;
      Navigator.pushReplacement(context, fadeSlideRoute(BottomNav()));
    } catch (error) {
      AppSnackBar.show(context, "Error saving profile: $error", type: SnackBarType.error);
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  Widget buildStyledDropdown<T>(
    String label,
    List<T> items,
    String Function(T) labelOf,
    ValueChanged<T?> onChanged,
    T? selectedValue,
  ) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(labelText: label),
      value: selectedValue,
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(labelOf(item)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
