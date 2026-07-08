import 'package:flutter/material.dart';
import 'package:fundfinderff/Screens/Chatbot/chat_screen.dart';
import 'package:fundfinderff/Screens/Scholarship/scholarship_list_page.dart';
//import 'package:fundfinderff/Screens/Home/Home.dart';
//import 'package:fundfinderff/Screens/Explore/explore.dart';
import 'package:fundfinderff/Screens/Profile/Profile.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  late Widget currentPage;

  @override
  void initState() {
    super.initState();
    // Initialize the pages and currentPage
    pages = [ScholarshipListPage(), ChatScreen(), Profile()];
    currentPage = pages[currentTabIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage,
      bottomNavigationBar: Container(
        color: Color(0xFFFFFFFF),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            backgroundColor: Color(0xFFFFFFFF),
            color: Color(0xFF8796B5),
            activeColor: Color(0xFF0461C9),
            tabBackgroundColor: Color(0xFFEFF8FF),
            gap: 8,
            padding: const EdgeInsets.all(16),
            onTabChange: (index) {
              setState(() {
                currentTabIndex = index;
                currentPage = pages[index];
              });
            },
            tabs: const [
              GButton(
                icon: Icons.home,
                text: "Home",
              ),
              GButton(
                icon: Icons.search,
                text: "ChatBot",
              ),
              GButton(
                icon: Icons.person,
                text: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
