import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fundfinderff/Screens/UserInfo/userinfo.dart';
import 'package:fundfinderff/Screens/BottomBar/bottombar.dart';
import 'package:fundfinderff/Screens/Login/Signin.dart';
import 'package:fundfinderff/Screens/Login/forgotpassword.dart';
import 'package:fundfinderff/services/api_exception.dart';
import 'package:fundfinderff/state/auth_provider.dart';
import 'package:fundfinderff/state/profile_provider.dart';
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
        MaterialPageRoute(
          builder: (context) => profileProvider.hasProfile ? BottomNav() : Userinfo(),
        ),
      );
    } on ApiException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        e.statusCode == 401 ? "Incorrect email or password" : e.message,
        style: TextStyle(fontSize: 18.0, color: Colors.black),
      )));
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                      Color.fromARGB(255, 205, 160, 226),
                      Color.fromARGB(255, 144, 193, 240),
                    ])),
              ),
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 3),
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white,
                            Colors.white,
                          ]),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: Text(""),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    Center(
                        child: Text(
                      "FundFinder",
                      style: GoogleFonts.megrim(
                        color: Colors.black,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    SizedBox(
                      height: 50.0,
                    ),
                    SingleChildScrollView(
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.fromARGB(255, 205, 160, 226),
                                    Color.fromARGB(255, 144, 193, 240),
                                  ]),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Form(
                            key: _formkey,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 30.0,
                                ),
                                Text(
                                  "Login",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                TextFormField(
                                  controller: useremailcontroller,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Email';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      hintText: 'Email',
                                      hintStyle: GoogleFonts.poppins(
                                        color: Colors.black54,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      prefixIcon: Icon(Icons.email_outlined)),
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
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
                                    hintText: 'Password',
                                    hintStyle: GoogleFonts.poppins(
                                      color: Colors.black54,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    prefixIcon: Icon(Icons.password_outlined),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            textvisible = !textvisible;
                                          });
                                        },
                                        icon: textvisible
                                            ? Icon(Icons.visibility,
                                                color: Colors.black54)
                                            : Icon(
                                                Icons.visibility_off,
                                                color: Colors.black54,
                                              )),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ForgotPass()));
                                  },
                                  child: Container(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        "Forgot Password?",
                                        style: GoogleFonts.poppins(
                                          color: Colors.black54,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )),
                                ),
                                SizedBox(
                                  height: 80.0,
                                ),
                                GestureDetector(
                                  onTap: isSubmitting
                                      ? null
                                      : () {
                                          if (_formkey.currentState!.validate()) {
                                            setState(() {
                                              email = useremailcontroller.text.trim();
                                              password =
                                                  userpasswordcontroller.text.trim();
                                            });
                                            userLogin();
                                          }
                                        },
                                  child: Material(
                                    elevation: 5.0,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.0),
                                      width: 200,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Color.fromARGB(
                                                    255, 205, 160, 226),
                                                Color.fromARGB(
                                                    255, 144, 193, 240),
                                              ]),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Center(
                                          child: isSubmitting
                                              ? SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child: CircularProgressIndicator(
                                                      strokeWidth: 2, color: Colors.black),
                                                )
                                              : Text(
                                                  "LOGIN",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight.bold),
                                                )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 70.0,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Signin()));
                        },
                        child: Text(
                          "Don't have an account? Sign up",
                          style: GoogleFonts.poppins(
                            color: Colors.black54,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                          selectionColor: Colors.white,
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
