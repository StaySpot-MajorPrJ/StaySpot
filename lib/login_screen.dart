import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'common_widgets.dart'; // Contains AppTitle & showCustomDialog
import 'homepage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _linkController = TextEditingController(); // For pasting the email link

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

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  /// Sends a sign-in email link to the provided email address.
  Future<void> sendSignInEmail() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      showCustomDialog(
        context: context,
        title: "Error",
        message: "Please enter an email address.",
      );
      return;
    }

    // IMPORTANT: Update the URL below to match your authorized domain.
    // For example, if your app is deployed on Firebase Hosting, use:
    // 'https://stayspot.web.app/finishSignUp?email=$email'
    final actionCodeSettings = ActionCodeSettings(
      url: 'https://stayspot.web.app/finishSignUp?email=$email',
      handleCodeInApp: true,
      iOSBundleId: 'com.example.ios',           // Replace with your iOS bundle ID
      androidPackageName: 'com.example.stayspot', // Replace with your Android package name
      androidInstallApp: true,
      androidMinimumVersion: '12',
    );

    try {
      print("Attempting to send sign-in link to $email");
      await FirebaseAuth.instance.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );
      showCustomDialog(
        context: context,
        title: "Verification Email Sent",
        message:
            "A sign-in link has been sent to $email. Please check your inbox (and spam folder) and then paste the complete link below to finish signing in.",
      );
    } catch (e) {
      print("Error sending email: $e");
      showCustomDialog(
        context: context,
        title: "Error Sending Email",
        message: e.toString(),
      );
    }
  }

  /// Verifies the email link and signs in the user.
  Future<void> verifyEmailLinkAndSignIn() async {
    final email = _emailController.text.trim();
    final emailLink = _linkController.text.trim();

    if (emailLink.isEmpty) {
      showCustomDialog(
        context: context,
        title: "Error",
        message: "Please paste the sign-in link you received in the email.",
      );
      return;
    }

    try {
      print("Attempting to sign in with email link for $email");
      await FirebaseAuth.instance.signInWithEmailLink(
        email: email,
        emailLink: emailLink,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Homepage()),

      );
    } catch (e) {
      print("Error verifying email link: $e");
      showCustomDialog(
        context: context,
        title: "Verification Failed",
        message: e.toString(),
      );
    }
  }

  /// Combined flow: send email link, then prompt user to paste the link.
  Future<void> handleEmailVerificationFlow() async {
    await sendSignInEmail();
    // Prompt the user to paste the sign-in link.
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter Verification Link"),
          content: TextField(
            controller: _linkController,
            decoration: const InputDecoration(
              hintText: "Paste the complete sign-in link here",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog
                await verifyEmailLinkAndSignIn();
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  // Google Sign-In remains unchanged.
  Future<void> handleGoogleLogin() async {
    try {
      if (kIsWeb) {
        final googleProvider = GoogleAuthProvider();
        await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final googleUser = await googleSignIn.signIn();
        if (googleUser == null) return; // User cancelled
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
      }
      Navigator.pushReplacement(
        context,
          MaterialPageRoute(builder: (context) => const Homepage()),
      );
    } catch (e) {
      showCustomDialog(
        context: context,
        title: "Google Login Error",
        message: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f4f4),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SlideTransition(
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppTitle(),
                      const SizedBox(height: 20),
                      // ------------------ Email Link Authentication ------------------
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "Email Address",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: handleEmailVerificationFlow,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // ------------------------ OR ------------------------
                      Row(
                        children: const [
                          Expanded(child: Divider(thickness: 1)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text("OR"),
                          ),
                          Expanded(child: Divider(thickness: 1)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // ------------------ Continue with Google ------------------
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: Image.asset(
                            'assets/images/google-logo.png',
                            width: 20,
                            height: 20,
                          ),
                          label: const Text(
                            "Continue with Google",
                            style: TextStyle(color: Colors.black),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Colors.grey.shade400),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: handleGoogleLogin,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // -------------- Register Link (Optional) --------------
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/register'),
                        child: const Text(
                          "Don't have an account? Register",
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
        ),
      ),
    );
  }
}
