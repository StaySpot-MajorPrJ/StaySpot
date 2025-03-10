import 'package:flutter/material.dart';
import 'homepage.dart'; // Import your homepage file

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage>
    with SingleTickerProviderStateMixin {
  bool wishlistExists = false; // Toggle for demo purposes

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Controller for fading in the screen content.
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  /// If the wishlist has items, show them in a ListView (placeholder content).
  Widget _buildWishlistContent() {
    return ListView(
      key: const ValueKey("wishlistExists"),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: const Icon(Icons.favorite, color: Colors.red),
            title: const Text("Wishlist Item 1"),
            subtitle: const Text("Description of item 1"),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.grey),
              onPressed: () {
                // Handle removing item from wishlist
              },
            ),
          ),
        ),
        // Add or generate more items as needed
      ],
    );
  }

  /// If the wishlist is empty, show a logo with a message below it.
  Widget _buildEmptyWishlistView() {
    return Center(
      key: const ValueKey("emptyWishlist"),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace with your own asset image or a relevant icon
            Image.asset(
              'assets/images/empty_wishlist.png',
              height: 150,
              width: 150,
              fit: BoxFit.contain,
              // Fallback if image not found:
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.favorite_border,
                    color: Colors.grey, size: 100);
              },
            ),
            const SizedBox(height: 24),
            const Text(
              "Your wishlist is empty",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Add items you love to your wishlist\nfor quick access anytime.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Redirect to homepage.dart when "Browse Items" is clicked.
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Homepage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Browse Items",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // An AppBar with a consistent theme color.
      appBar: AppBar(
        title: const Text("Wishlist"),
        backgroundColor: Colors.blue,
        elevation: 2,
      ),
      // Main body with a subtle background gradient.
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFE3F2FD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: wishlistExists
                ? _buildWishlistContent()
                : _buildEmptyWishlistView(),
          ),
        ),
      ),
    );
  }
}
