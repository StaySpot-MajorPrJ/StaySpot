import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'custom_text_input.dart';
import 'custom_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'common_widgets.dart'; // Assuming the AppTitle and showCustomDialog are in this file

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  String userType = "student";
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();

  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  Future<void> handleRegister() async {
    if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
      showCustomDialog(
        context: context,
        title: "Error",
        message: "Passwords do not match!",
      );
      return;
    }
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      showCustomDialog(
        context: context,
        title: "Success",
        message: "Registration Successful 🎉",
        onOkPressed: () {
          Navigator.of(context).pop();
          Navigator.pushReplacementNamed(context, '/');
        },
      );
    } catch (e) {
      showCustomDialog(
        context: context,
        title: "Error",
        message: e.toString(),
      );
    }
  }

  Widget userTypeButton(String type, Icon icon) {
    final bool isActive = userType == type;
    return GestureDetector(
      onTap: () => setState(() => userType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xff007BFF) : Colors.transparent,
          border: Border.all(color: const Color(0xff007BFF)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              type == "student" ? "Student" : "PG/Hostel Owner",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.white : const Color(0xff007BFF),
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f4f4),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppTitle(),
              const SizedBox(height: 25),
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        children: [
                          const Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff007BFF),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 20),
                          // User Type Selection
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              userTypeButton(
                                "student",
                                Icon(
                                  FontAwesomeIcons.graduationCap,
                                  size: 20,
                                  color: userType == "student"
                                      ? Colors.white
                                      : const Color(0xff007BFF),
                                ),
                              ),
                              userTypeButton(
                                "owner",
                                Icon(
                                  Icons.apartment,
                                  size: 22,
                                  color: userType == "owner"
                                      ? Colors.white
                                      : const Color(0xff007BFF),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          if (userType == "owner") ...[
                            CustomTextInput(
                              controller: _usernameController,
                              hintText: "Enter Name",
                            ),
                            CustomTextInput(
                              controller: _phoneController,
                              hintText: "Enter Phone",
                              keyboardType: TextInputType.phone,
                            ),
                          ],
                          CustomTextInput(
                            controller: _emailController,
                            hintText: "Enter Email",
                            keyboardType: TextInputType.emailAddress,
                          ),
                          CustomTextInput(
                            controller: _passwordController,
                            hintText: "Enter Password",
                            obscureText: true,
                          ),
                          CustomTextInput(
                            controller: _confirmPasswordController,
                            hintText: "Confirm Password",
                            obscureText: true,
                          ),
                          CustomButton(
                            title: "Register",
                            onPressed: handleRegister,
                          ),
                          const SizedBox(height: 15),
                          GestureDetector(
                            onTap: () => Navigator.pushReplacementNamed(context, '/'),
                            child: const Text(
                              "Already registered? Login",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff007BFF),
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
