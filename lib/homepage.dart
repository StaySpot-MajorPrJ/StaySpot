import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_profile.dart';
import 'wishlist.dart';
import 'login_screen.dart'; // Import your login screen if using direct navigation
import 'owner.dart'; // Import your OwnerPage

enum FilterOptions { boys, girls, govtHostels, apartments, rooms }

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  FilterOptions? _selectedFilter;

  @override
  void initState() {
    super.initState();
    // First, show instructions overlay, then the role selection dialog.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInstructionsOverlay();
    });
  }

  void _showInstructionsOverlay() {
    // Make this overlay non-dismissible by tapping outside to force a role selection flow.
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
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
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showRoleSelectionDialog();
              },
              child: const Text("Continue"),
            ),
          ],
        );
      },
    );
  }

  void _showRoleSelectionDialog() {
    // This dialog forces the user to choose a role.
    showDialog(
      context: context,
      barrierDismissible: false, // Must choose a role.
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Select Your Role",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.school),
                label: const Text("Student"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                ),
                onPressed: () {
                  // Student role: stay on Homepage.
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.business),
                label: const Text("Owner"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                ),
                onPressed: () {
                  // Owner role: navigate to OwnerPage.
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const OwnerPage()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _onMenuItemSelected(String value) async {
    switch (value) {
      case 'user':
        // Navigate to the user profile management page.
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const UserProfilePage()),
        );
        break;
      case 'wishlist':
        // Navigate to the wishlist page.
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const WishlistPage()),
        );
        break;
      case 'logout':
        // Logout and redirect to the LoginScreen.
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
                        color: Colors.black87),
                  ),
                  const Divider(),
                  RadioListTile<FilterOptions>(
                    value: FilterOptions.boys,
                    groupValue: _selectedFilter,
                    title: const Text("Boys", style: TextStyle(fontSize: 16)),
                    secondary:
                        const Icon(Icons.male, color: Colors.blue, size: 28),
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
                    secondary:
                        const Icon(Icons.female, color: Colors.pink, size: 28),
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
                    title: const Text("Govt. Hostels",
                        style: TextStyle(fontSize: 16)),
                    secondary: const Icon(Icons.apartment,
                        color: Colors.green, size: 28),
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
                    title: const Text("Apartments",
                        style: TextStyle(fontSize: 16)),
                    secondary: const Icon(Icons.home_work,
                        color: Colors.orange, size: 28),
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
                    secondary: const Icon(Icons.meeting_room,
                        color: Colors.purple, size: 28),
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
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Apply Filters",
                        style: TextStyle(fontSize: 16)),
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
    // Use FirebaseAuth to fetch user's photoURL and displayName.
    final user = FirebaseAuth.instance.currentUser;
    final String? photoUrl = user?.photoURL;
    final String? displayName = user?.displayName;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            // Use the original app logo from asset.
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
          PopupMenuButton<String>(
            onSelected: _onMenuItemSelected,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                child: photoUrl == null
                    ? (displayName != null && displayName.isNotEmpty
                        ? Text(
                            displayName[0].toUpperCase(),
                            style: const TextStyle(fontSize: 20, color: Colors.white),
                          )
                        : const Icon(Icons.account_circle, size: 28, color: Colors.white))
                    : null,
              ),
            ),
            color: Colors.white.withOpacity(0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'user',
                height: 60,
                child: Row(
                  children: const [
                    Icon(Icons.person, color: Colors.black, size: 28),
                    SizedBox(width: 12),
                    Text(
                      'User',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'wishlist',
                height: 60,
                child: Row(
                  children: const [
                    Icon(Icons.favorite, color: Colors.red, size: 28),
                    SizedBox(width: 12),
                    Text(
                      'Wishlist',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                height: 60,
                child: Row(
                  children: const [
                    Icon(Icons.logout, color: Colors.black, size: 28),
                    SizedBox(width: 12),
                    Text(
                      'Logout',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search bar with filter icon.
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
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
                child: Text(
                  _selectedFilter == null
                      ? 'No filter selected. Showing all properties.'
                      : 'Showing ${_selectedFilter.toString().split('.').last} properties.',
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
