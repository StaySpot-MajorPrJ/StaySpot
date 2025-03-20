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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                // Changed from gradient to a solid off-white color.
                color: const Color(0xFFF8F8F8),
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
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.black87),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Descriptive message.
                  const Text(
                    "Welcome to the Owner Dashboard. Here you can manage your property, view bookings, and more.",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Custom action button.
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
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
          MaterialPageRoute(builder: (_) => const ManagePlace(documentId: '')),
        );
        break;
      case 'logout':
        Navigator.pushReplacementNamed(context, '/login');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get user details from Firebase.
    final user = FirebaseAuth.instance.currentUser;
    final String? displayName = user?.displayName;
    final String? email = user?.email;

    return Scaffold(
      key: _scaffoldKey,
      // Disable swipe to open the endDrawer to ensure only our manual icon triggers it.
      endDrawerEnableOpenDragGesture: false,
      // Only one endDrawer is defined.
      endDrawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          children: [
            // Drawer header with user details.
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.blue,
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : null,
                  child: user?.photoURL == null
                      ? (displayName != null && displayName.isNotEmpty
                          ? Text(
                              displayName[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.person,
                              size: 28, color: Colors.white))
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName ?? 'User Name',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email ?? '',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Animated sidebar menu items.
            AnimatedMenuItem(
              icon: Icons.person,
              title: 'User',
              iconColor: Colors.blue,
              backgroundColor: Colors.blue[50]!,
              onTap: () {
                Navigator.pop(context);
                _onMenuItemSelected('user');
              },
            ),
            AnimatedMenuItem(
              icon: Icons.add_business,
              title: 'Add Place',
              iconColor: Colors.green,
              backgroundColor: Colors.green[50]!,
              onTap: () {
                Navigator.pop(context);
                _onMenuItemSelected('add');
              },
            ),
            AnimatedMenuItem(
              icon: Icons.settings,
              title: 'Manage Place',
              iconColor: Colors.orange,
              backgroundColor: Colors.orange[50]!,
              onTap: () {
                Navigator.pop(context);
                _onMenuItemSelected('manage');
              },
            ),
            AnimatedMenuItem(
              icon: Icons.logout,
              title: 'Logout',
              iconColor: Colors.redAccent,
              backgroundColor: Colors.red[50]!,
              onTap: () {
                Navigator.pop(context);
                _onMenuItemSelected('logout');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100, // Bigger header.
        backgroundColor: Colors.blue,
        // Title now only shows the logo and app name.
        title: Row(
          children: [
            // Logo in a circular container.
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.home, color: Colors.blue, size: 30);
                  },
                ),
              ),
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
          ],
        ),
        // Only one menu icon (hamburger) is provided along with the unchanged profile icon.
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserProfilePage()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : null,
                child: user?.photoURL == null
                    ? (displayName != null && displayName.isNotEmpty
                        ? Text(
                            displayName[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const Icon(Icons.account_circle,
                            size: 28, color: Colors.blue))
                    : null,
              ),
            ),
          ),
        ],
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
                  border: Border.all(color: Colors.blue, width: 1),
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

/// A custom widget that adds a hover animation to sidebar menu items.
class AnimatedMenuItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback onTap;

  const AnimatedMenuItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.iconColor,
    required this.backgroundColor,
    required this.onTap,
  }) : super(key: key);

  @override
  _AnimatedMenuItemState createState() => _AnimatedMenuItemState();
}

class _AnimatedMenuItemState extends State<AnimatedMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() {
        _isHovered = true;
      }),
      onExit: (event) => setState(() {
        _isHovered = false;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(widget.icon, color: widget.iconColor),
          title: Text(
            widget.title,
            style: const TextStyle(color: Colors.black87),
          ),
          onTap: widget.onTap,
        ),
      ),
    );
  }
}
