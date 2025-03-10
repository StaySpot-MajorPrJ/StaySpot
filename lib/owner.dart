import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_profile.dart';
import 'login_screen.dart';
import 'addplace.dart';    // Ensure this file defines the AddPlace widget.
import 'manageplace.dart'; // Ensure this file defines the ManagePlace widget.

class OwnerPage extends StatefulWidget {
  const OwnerPage({Key? key}) : super(key: key);

  @override
  State<OwnerPage> createState() => _OwnerPageState();
}

class _OwnerPageState extends State<OwnerPage> {
  @override
  void initState() {
    super.initState();
    // Show info popup after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInfoPopup();
    });
  }

  void _showInfoPopup() {
    showDialog(
      context: context,
      barrierDismissible: true, // Allow dismissal by tapping outside.
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Owner Dashboard",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          content: const Text(
              "Welcome to the Owner Dashboard. Here you can manage your property, view bookings, and more."),
        );
      },
    );
  }

  void _onMenuItemSelected(String value) {
    switch (value) {
      case 'user':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const UserProfilePage()),
        );
        break;
      case 'add':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddPlace()),
        );
        break;
      case 'manage':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ManagePlace()),
        );
        break;
      case 'logout':
        Navigator.pushReplacementNamed(context, '/login');
        break;
      default:
        break;
    }
  }

  PopupMenuItem<String> _buildMenuItem(String title, String value, IconData iconData) {
    return PopupMenuItem(
      value: value,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: const Color(0xFF000080), width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(iconData, color: Colors.black, size: 28),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the first letter of the user's display name.
    final user = FirebaseAuth.instance.currentUser;
    final String? displayName = user?.displayName;
    String menuLabel = "";
    if (displayName != null && displayName.isNotEmpty) {
      menuLabel = displayName[0].toUpperCase();
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100, // Bigger header.
        backgroundColor: const Color(0xFF000080), // Dark navy blue.
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // Original app logo.
            Image.asset(
              'assets/images/logo.png',
              height: 50,
              width: 50,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.home, color: Colors.white, size: 50);
              },
            ),
            const SizedBox(width: 12),
            const Text(
              'StaySpot',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            // Instead of three dots, show first letter of the user name.
            PopupMenuButton<String>(
              onSelected: _onMenuItemSelected,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey,
                  child: menuLabel.isNotEmpty
                      ? Text(
                          menuLabel,
                          style: const TextStyle(fontSize: 24, color: Colors.white),
                        )
                      : const Icon(Icons.account_circle, size: 28, color: Colors.white),
                ),
              ),
              color: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              itemBuilder: (context) => [
                _buildMenuItem('User', 'user', Icons.person),
                _buildMenuItem('Add Place', 'add', Icons.add_business),
                _buildMenuItem('Manage Place', 'manage', Icons.settings),
                _buildMenuItem('Logout', 'logout', Icons.logout),
              ],
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Enhanced search bar with transparent background and dark-blue border.
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                border: Border.all(color: const Color(0xFF000080), width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Icon(Icons.search, color: Colors.grey, size: 28),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for properties...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Owner page main content placeholder.
            const Expanded(
              child: Center(
                child: Text(
                  'Owner Page Content Goes Here',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
