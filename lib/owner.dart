import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_profile.dart';
import 'login_screen.dart';
import 'addplace.dart';    // Ensure this file defines the AddPlace widget.
import 'manageplace.dart'; // Ensure this file defines the ManagePlace widget.

class OwnerPage extends StatefulWidget {
  const OwnerPage({super.key});

  @override
  State<OwnerPage> createState() => _OwnerPageState();
}

class _OwnerPageState extends State<OwnerPage> with TickerProviderStateMixin {
  late final AnimationController _bodyAnimationController;
  late final Animation<double> _bodyFadeAnimation;

  @override
  void initState() {
    super.initState();
    // Animate the body content on load.
    _bodyAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _bodyFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _bodyAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    _bodyAnimationController.forward();

    // Show the info popup with a custom design after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInfoPopup();
    });
  }

  @override
  void dispose() {
    _bodyAnimationController.dispose();
    super.dispose();
  }

  void _showInfoPopup() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'InfoPopup',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with title and close button.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Owner Dashboard",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Descriptive message.
                  const Text(
                    "Welcome to the Owner Dashboard. Here you can manage your property, view bookings, and more.",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Custom action button.
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Got It"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
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
          MaterialPageRoute(builder: (_) => const ManagePlace(documentId: '',)),
        );
        break;
      case 'logout':
        Navigator.pushReplacementNamed(context, '/login');
        break;
      default:
        break;
    }
  }

  PopupMenuItem<String> _buildMenuItem(
      String title, String value, IconData iconData, Color color) {
    return PopupMenuItem(
      value: value,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: color.withOpacity(0.8), width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(iconData, color: color, size: 28),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: color,
              ),
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
            // App logo.
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
            // Popup menu with a dedicated button showing the user's initial.
            PopupMenuButton<String>(
              onSelected: _onMenuItemSelected,
              color: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              itemBuilder: (context) => [
                _buildMenuItem('User', 'user', Icons.person, Colors.blueAccent),
                _buildMenuItem('Add Place', 'add', Icons.add_business, Colors.green),
                _buildMenuItem('Manage Place', 'manage', Icons.settings, Colors.orange),
                _buildMenuItem('Logout', 'logout', Icons.logout, Colors.redAccent),
              ],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey,
                  child: menuLabel.isNotEmpty
                      ? Text(
                          menuLabel,
                          style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      : const Icon(Icons.account_circle,
                          size: 28, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
      body: FadeTransition(
        opacity: _bodyFadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Enhanced search bar.
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
              // Main content placeholder.
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
      ),
    );
  }
}
