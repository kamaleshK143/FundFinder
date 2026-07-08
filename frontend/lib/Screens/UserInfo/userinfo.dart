import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fundfinderff/Screens/BottomBar/bottombar.dart';
import 'package:fundfinderff/models/enums.dart';
import 'package:fundfinderff/models/profile.dart';
import 'package:fundfinderff/state/profile_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 251, 248, 252),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Text(
                  "Tell us More",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Complete your profile to see scholarships you're actually eligible for!",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 30),
                buildStyledDropdown<EducationLevel>(
                  "Education Level",
                  EducationLevel.values,
                  (level) => level.label,
                  (value) => setState(() => selectedEducationLevel = value),
                  selectedEducationLevel,
                ),
                SizedBox(height: 20.0),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: TextFormField(
                      controller: incomeController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15),
                      decoration: InputDecoration(
                        labelText: "Annual Family Income (₹)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                buildStyledDropdown<Category>(
                  "Category",
                  Category.values,
                  (category) => category.label,
                  (value) => setState(() => selectedCategory = value),
                  selectedCategory,
                ),
                SizedBox(height: 20.0),
                buildStyledDropdown<Gender>(
                  "Gender",
                  Gender.values,
                  (gender) => gender.label,
                  (value) => setState(() => selectedGender = value),
                  selectedGender,
                ),
                SizedBox(height: 20.0),
                buildStyledDropdown<String>(
                  "State",
                  indianStates,
                  (state) => state,
                  (value) => setState(() => selectedState = value),
                  selectedState,
                ),
                SizedBox(height: 20.0),
                buildStyledDropdown<String>(
                  "Do you have a disability?",
                  yesNo,
                  (value) => value,
                  (value) => setState(() => selectedDisability = value),
                  selectedDisability,
                ),
                SizedBox(height: 30.0),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    ),
                    onPressed: isSubmitting ? null : submit,
                    child: isSubmitting
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text(
                            "Submit",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
      Fluttertoast.showToast(
        msg: "Please fill all the fields correctly",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
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

      Fluttertoast.showToast(
        msg: "Profile saved successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNav()),
      );
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error saving profile: $error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
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
    final TextStyle commonTextStyle = GoogleFonts.poppins(
      color: const Color.fromARGB(137, 0, 0, 0),
      fontSize: 15.0,
      fontWeight: FontWeight.bold,
    );

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: DropdownButtonFormField<T>(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: commonTextStyle,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            hintStyle: commonTextStyle,
          ),
          style: commonTextStyle,
          value: selectedValue,
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(labelOf(item), style: commonTextStyle),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
