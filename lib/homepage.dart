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
    // Use showGeneralDialog for a smooth fade-and-scale transition.
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
      barrierDismissible: false, // User must choose a role.
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
    // Fetch the user’s displayName to show initial if no photoURL.
    final user = FirebaseAuth.instance.currentUser;
    final String? photoUrl = user?.photoURL;
    final String? displayName = user?.displayName;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 40,
              width: 40,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.home, color: Colors.white, size: 40);
              },
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
          // 1) Show the user's DP or initial in a CircleAvatar:
          GestureDetector(
            onTap: () {
              // Optionally navigate to user profile directly if desired:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserProfilePage()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: photoUrl == null ? Colors.black87 : Colors.transparent,
                backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                child: photoUrl == null
                    ? (displayName != null && displayName.isNotEmpty
                        ? Text(
                            displayName[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const Icon(Icons.person, size: 20, color: Colors.white))
                    : null,
              ),
            ),
          ),

          // 2) A dedicated Flutter icon (3-dot menu) to open the popup:
          PopupMenuButton<String>(
            tooltip: 'Options',
            icon: const Icon(Icons.more_vert, color: Colors.white, size: 28),
            onSelected: _onMenuItemSelected,
            color: Colors.white.withOpacity(0.95),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'user',
                height: 50,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.blueAccent.withOpacity(0.8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: Colors.blueAccent, size: 24),
                      const SizedBox(width: 6),
                      Text(
                        'User',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              PopupMenuItem(
                value: 'wishlist',
                height: 50,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.deepPurpleAccent.withOpacity(0.8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.favorite, color: Colors.deepPurpleAccent, size: 24),
                      const SizedBox(width: 6),
                      Text(
                        'Wishlist',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                height: 50,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.redAccent.withOpacity(0.8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.logout, color: Colors.redAccent, size: 24),
                      const SizedBox(width: 6),
                      Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
              // Main content placeholder with smooth transition on filter changes.
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
