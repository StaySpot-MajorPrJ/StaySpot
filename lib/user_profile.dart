import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _emailController.text = user.email ?? "";
      _nameController.text = user.displayName ?? "";
      // For phone number, retrieve it from your backend if available.
      _phoneController.text = "";
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateDisplayName(_nameController.text);
        // Optionally, update phone number in your backend if needed.
        await user.reload();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile Updated Successfully")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating profile: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current user and its photoURL.
    final user = FirebaseAuth.instance.currentUser;
    final String? photoUrl = user?.photoURL;

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
          child: Column(
            children: [
              // Profile picture with a circular border and shadow.
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blueAccent, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor:
                      photoUrl == null ? Colors.black87 : Colors.transparent,
                  backgroundImage:
                      photoUrl != null ? NetworkImage(photoUrl) : null,
                  child: photoUrl == null
                      ? (user?.displayName != null &&
                              user!.displayName!.isNotEmpty
                          ? Text(
                              user.displayName![0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 60,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const Icon(Icons.person,
                              size: 60, color: Colors.white))
                      : null,
                ),
              ),
              const SizedBox(height: 32),
              // Name text field.
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: const Icon(Icons.person, color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Email text field (visible but read-only).
              TextField(
                controller: _emailController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email, color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Phone number text field.
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: const Icon(Icons.phone, color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Update Profile button.
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updateProfile,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          "Update Profile",
                          style: TextStyle(fontSize: 18, color: Colors.white),
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
