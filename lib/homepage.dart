import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_profile.dart';
import 'wishlist.dart';
import 'login_screen.dart'; // Import your login screen if using direct navigation
import 'owner.dart'; // Import your OwnerPage

enum FilterOptions { boys, girls, govtHostels, apartments, rooms }

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with TickerProviderStateMixin {
  FilterOptions? _selectedFilter;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final AnimationController _bodyAnimationController;
  late final Animation<double> _bodyFadeAnimation;

  @override
  void initState() {
    super.initState();
    // Animate the homepage body on load.
    _bodyAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _bodyFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bodyAnimationController, curve: Curves.easeInOut),
    );
    _bodyAnimationController.forward();

    // Show the instructions overlay after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInstructionsOverlay();
    });
  }

  @override
  void dispose() {
    _bodyAnimationController.dispose();
    super.dispose();
  }

  void _showInstructionsOverlay() {
    showGeneralDialog(
      barrierDismissible: false,
      barrierLabel: 'Instructions',
      context: context,
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, anim1, anim2) => const SizedBox(),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: anim1,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                "Welcome to StaySpot!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              content: const Text(
                "Use the search bar to filter properties. Tap the user profile icon for more options. "
                "Before proceeding, please select your role.",
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showRoleSelectionDialog();
                  },
                  child: const Text("Continue", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showRoleSelectionDialog() {
    showGeneralDialog(
      barrierDismissible: false,
      barrierLabel: 'Role Selection',
      context: context,
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, anim1, anim2) => const SizedBox(),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: anim1,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                "Select Your Role",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.school, color: Colors.white),
                    label: const Text("Student", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.business, color: Colors.white),
                    label: const Text("Owner", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40),
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const OwnerPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _onMenuItemSelected(String value) async {
    switch (value) {
      case 'user':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const UserProfilePage()),
        );
        break;
      case 'wishlist':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const WishlistPage()),
        );
        break;
      case 'logout':
        try {
          await FirebaseAuth.instance.signOut();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (Route<dynamic> route) => false,
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Logout error: $e")),
          );
        }
        break;
      default:
        break;
    }
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Filter Options',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Divider(),
                  RadioListTile<FilterOptions>(
                    value: FilterOptions.boys,
                    groupValue: _selectedFilter,
                    title: const Text("Boys", style: TextStyle(fontSize: 16)),
                    secondary: const Icon(Icons.male, color: Colors.blue, size: 28),
                    onChanged: (value) {
                      setModalState(() {
                        _selectedFilter = value;
                      });
                      setState(() {});
                    },
                  ),
                  RadioListTile<FilterOptions>(
                    value: FilterOptions.girls,
                    groupValue: _selectedFilter,
                    title: const Text("Girls", style: TextStyle(fontSize: 16)),
                    secondary: const Icon(Icons.female, color: Colors.pink, size: 28),
                    onChanged: (value) {
                      setModalState(() {
                        _selectedFilter = value;
                      });
                      setState(() {});
                    },
                  ),
                  RadioListTile<FilterOptions>(
                    value: FilterOptions.govtHostels,
                    groupValue: _selectedFilter,
                    title: const Text("Govt. Hostels", style: TextStyle(fontSize: 16)),
                    secondary: const Icon(Icons.apartment, color: Colors.green, size: 28),
                    onChanged: (value) {
                      setModalState(() {
                        _selectedFilter = value;
                      });
                      setState(() {});
                    },
                  ),
                  RadioListTile<FilterOptions>(
                    value: FilterOptions.apartments,
                    groupValue: _selectedFilter,
                    title: const Text("Apartments", style: TextStyle(fontSize: 16)),
                    secondary: const Icon(Icons.home_work, color: Colors.orange, size: 28),
                    onChanged: (value) {
                      setModalState(() {
                        _selectedFilter = value;
                      });
                      setState(() {});
                    },
                  ),
                  RadioListTile<FilterOptions>(
                    value: FilterOptions.rooms,
                    groupValue: _selectedFilter,
                    title: const Text("Rooms", style: TextStyle(fontSize: 16)),
                    secondary: const Icon(Icons.meeting_room, color: Colors.purple, size: 28),
                    onChanged: (value) {
                      setModalState(() {
                        _selectedFilter = value;
                      });
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Apply Filters", style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Fetch user details directly from Firebase.
    final user = FirebaseAuth.instance.currentUser;
    final String? photoUrl = user?.photoURL;
    final String? displayName = user?.displayName;
    final String? email = user?.email;

    return Scaffold(
      key: _scaffoldKey,
      // Sidebar with white background.
      endDrawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          children: [
            // Sidebar header with user details.
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.blue,
                  backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                  child: photoUrl == null
                      ? (displayName != null && displayName.isNotEmpty
                          ? Text(
                              displayName[0].toUpperCase(),
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                            )
                          : const Icon(Icons.person, size: 28, color: Colors.white))
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName ?? 'User Name',
                        style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email ?? '',
                        style: const TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Animated sidebar items with lighter palettes.
            AnimatedMenuItem(
              icon: Icons.person,
              title: 'User',
              iconColor: Colors.blue[700]!,
              backgroundColor: Colors.blue[50]!,
              onTap: () {
                Navigator.pop(context);
                _onMenuItemSelected('user');
              },
            ),
            AnimatedMenuItem(
              icon: Icons.favorite,
              title: 'Wishlist',
              // Updated to use a light green palette.
              iconColor: Colors.green[700]!,
              backgroundColor: Colors.green[50]!,
              onTap: () {
                Navigator.pop(context);
                _onMenuItemSelected('wishlist');
              },
            ),
            AnimatedMenuItem(
              icon: Icons.logout,
              title: 'Logout',
              iconColor: Colors.red[700]!,
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
        automaticallyImplyLeading: false, // Remove the back arrow.
        toolbarHeight: 80,
        backgroundColor: Colors.blue,
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
            const SizedBox(width: 8),
            const Text(
              'StaySpot',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          // Icon to open the sidebar.
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
          // User profile icon.
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
                radius: 20,
                backgroundColor: Colors.white,
                backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                child: photoUrl == null
                    ? (displayName != null && displayName.isNotEmpty
                        ? Text(
                            displayName[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const Icon(Icons.person, size: 20, color: Colors.blue))
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
              // Search bar with filter icon.
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.filter_list, color: Colors.blue),
                      onPressed: _showFilterOptions,
                    ),
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search for properties...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Icon(Icons.search, color: Colors.grey, size: 28),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Main content placeholder.
              Expanded(
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      _selectedFilter == null
                          ? 'No filter selected. Showing all properties.'
                          : 'Showing ${_selectedFilter.toString().split('.').last} properties.',
                      key: ValueKey(_selectedFilter),
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
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

/// A custom widget that adds a hover animation to menu items.
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
            style: TextStyle(color: widget.iconColor),
          ),
          onTap: widget.onTap,
        ),
      ),
    );
  }
}
