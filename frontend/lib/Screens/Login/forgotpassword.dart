import 'package:flutter/material.dart';
import 'package:fundfinderff/Screens/Login/Signin.dart';

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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Password reset isn't available yet. Please contact support.",
          style: TextStyle(fontSize: 16.0),
        ),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: SafeArea(
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            "Password Recovery",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            "Enter your email",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Form(
              key: _formkey,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white70, width: 2.0),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextFormField(
                        controller: mailcontroller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Email",
                          hintStyle: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white54,
                          ),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.white70,
                            size: 30.0,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    GestureDetector(
                      onTap: () {
                        if (_formkey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          showComingSoon();
                        }
                      },
                      child: Container(
                        width: 140,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Send Email",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style:
                              TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        SizedBox(width: 5.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Signin(),
                              ),
                            );
                          },
                          child: Text(
                            "Create",
                            style: TextStyle(
                              color: Color.fromARGB(225, 184, 166, 6),
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
