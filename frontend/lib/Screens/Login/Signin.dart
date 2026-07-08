import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fundfinderff/Screens/Login/login.dart';
import 'package:fundfinderff/services/api_exception.dart';
import 'package:fundfinderff/state/auth_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fundfinderff/Screens/UserInfo/userinfo.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  bool textvisible = true;
  bool isSubmitting = false;
  String email = "", password = "", name = "";

  TextEditingController namecontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();
  TextEditingController mailcontroller = new TextEditingController();

  final _formkey = GlobalKey<FormState>();

  Future<void> registration() async {
    setState(() => isSubmitting = true);
    try {
      await context.read<AuthProvider>().register(name, email, password);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Registered Successfully",
          style: TextStyle(fontSize: 20.0),
        ),
      ));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Userinfo()),
      );
    } on ApiException catch (e) {
      String message = e.message;
      if (e.statusCode == 409) {
        message = "An account with that email already exists";
      } else if (e.statusCode == 400) {
        message = "Password must be at least 8 characters";
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.orangeAccent,
        content: Text(message, style: TextStyle(fontSize: 16.0)),
      ));
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
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
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "FundFinder",
                        style: GoogleFonts.megrim(
                          color: Color.fromARGB(235, 20, 20, 20),
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Material(
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
                            borderRadius: BorderRadius.circular(20)),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 30.0,
                              ),
                              Text(
                                "Sign up",
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              TextFormField(
                                controller: namecontroller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Name';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: 'Name',
                                    hintStyle: GoogleFonts.poppins(
                                        color: Colors.black54,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500),
                                    prefixIcon: Icon(Icons.person_outlined)),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              TextFormField(
                                controller: mailcontroller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter E-mail';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: 'Email',
                                    hintStyle: GoogleFonts.poppins(
                                        color: Colors.black54,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500),
                                    prefixIcon: Icon(Icons.email_outlined)),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              TextFormField(
                                controller: passwordcontroller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Password';
                                  }
                                  if (value.length < 8) {
                                    return 'Password must be at least 8 characters';
                                  }
                                  return null;
                                },
                                obscureText: textvisible,
                                decoration: InputDecoration(
                                    hintText: 'Password',
                                    hintStyle: GoogleFonts.poppins(
                                        color: Colors.black54,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500),
                                    prefixIcon: Icon(Icons.password_outlined),
                                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            textvisible = !textvisible;
                          });
                        },
                        icon: textvisible
                            ? Icon(Icons.visibility, color: Colors.black54)
                            : Icon(
                                Icons.visibility_off,
                                color: Colors.black54,
                              )),
                                    ),
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
                                            email = mailcontroller.text.trim();
                                            name = namecontroller.text.trim();
                                            password = passwordcontroller.text.trim();
                                          });
                                          registration();
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
                                                "SIGN UP",
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
                    SizedBox(
                      height: 70.0,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Text(
                          "Already have an account? Login",
                          style: GoogleFonts.poppins(
                              color: Colors.black54,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500),
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
