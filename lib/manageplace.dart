import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ManagePlace extends StatefulWidget {
  final String documentId; // For simulation purposes.
  const ManagePlace({super.key, required this.documentId});

  @override
  State<ManagePlace> createState() => _ManagePlaceState();
}

class _ManagePlaceState extends State<ManagePlace> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Pre-populated controllers simulating existing data.
  final TextEditingController _nameController = TextEditingController(text: "Existing PG/Hostel Name");
  final TextEditingController _addressController = TextEditingController(text: "Existing Address");
  final TextEditingController _phoneController = TextEditingController(text: "1234567890");
  final TextEditingController _rentController = TextEditingController(text: "5000");
  final TextEditingController _tokenController = TextEditingController(text: "500");

  // Default property type.
  String _selectedPropertyType = "PG/Hostel";

  // Simulated trade certificate status.
  final String _tradeCertificateStatus = "Uploaded";

  // New images to update (UI only).
  List<File> _propertyImages = [];
  // Simulated existing images URLs.
  final List<String> _existingImages = [
    "https://via.placeholder.com/150",
    "https://via.placeholder.com/150",
  ];

  bool _foodAvailable = true;
  bool _wifiAvailable = false;
  bool _roomsAvailable = true;

  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize animation.
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  Future<void> _pickPropertyImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null && images.isNotEmpty) {
      setState(() {
        _propertyImages = images.map((e) => File(e.path)).toList();
      });
    }
  }

  void _updatePlace() {
    if (_formKey.currentState!.validate()) {
      debugPrint("Updated Property Type: $_selectedPropertyType");
      debugPrint("Updated Name: ${_nameController.text}");
      debugPrint("Updated Address: ${_addressController.text}");
      debugPrint("Updated Phone: ${_phoneController.text}");
      debugPrint("Updated Rent: ${_rentController.text}");
      debugPrint("Updated Token: ${_tokenController.text}");
      debugPrint("Amenities: Food=$_foodAvailable, Wifi=$_wifiAvailable, Rooms=$_roomsAvailable");
      debugPrint("New Images Count: ${_propertyImages.length}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Place updated successfully! (UI only)")),
      );
    }
  }

  void _deletePlace() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Delete Place",
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Are you sure you want to delete this place?",
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {
                debugPrint("Place deleted");
                Navigator.of(context).pop(); // Dismiss dialog
                Navigator.of(context).pop(); // Navigate back after deletion
              },
              child: const Text("Delete", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
          backgroundColor: Colors.white,
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _rentController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const poppinsTextStyle = TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    final darkBlue = Colors.blue.shade900;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Manage Place",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: darkBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Property Type Selection.
                const Text(
                  "Select Property Type",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text("Room", style: TextStyle(fontFamily: 'Poppins')),
                        value: "Room",
                        groupValue: _selectedPropertyType,
                        onChanged: (value) {
                          setState(() {
                            _selectedPropertyType = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text("PG/Hostel", style: TextStyle(fontFamily: 'Poppins')),
                        value: "PG/Hostel",
                        groupValue: _selectedPropertyType,
                        onChanged: (value) {
                          setState(() {
                            _selectedPropertyType = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Name Field.
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: _selectedPropertyType == "Room"
                        ? "Name of Room"
                        : "Name of PG/Hostel",
                    prefixIcon: const Icon(Icons.home),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? "Enter a name" : null,
                ),
                const SizedBox(height: 16),
                // Address Field.
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: "Address",
                    prefixIcon: Icon(Icons.location_on),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? "Enter address" : null,
                ),
                const SizedBox(height: 16),
                // Phone Number Field.
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) => value == null || value.isEmpty ? "Enter phone number" : null,
                ),
                const SizedBox(height: 16),
                // Rent Amount Field.
                TextFormField(
                  controller: _rentController,
                  decoration: const InputDecoration(
                    labelText: "Rent Amount",
                    prefixIcon: Icon(Icons.currency_rupee),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? "Enter rent amount" : null,
                ),
                const SizedBox(height: 16),
                // Conditional: Trade Certificate info (for PG/Hostel).
                if (_selectedPropertyType == "PG/Hostel")
                  Row(
                    children: [
                      const Icon(Icons.upload_file, color: Colors.grey),
                      const SizedBox(width: 8),
                      const Text("Trade Certificate: ", style: TextStyle(fontFamily: 'Poppins')),
                      Text(
                        _tradeCertificateStatus,
                        style: const TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                      ),
                    ],
                  ),
                if (_selectedPropertyType == "PG/Hostel")
                  const SizedBox(height: 16),
                // Property Images Upload.
                ElevatedButton.icon(
                  onPressed: _pickPropertyImages,
                  icon: const Icon(Icons.image),
                  label: const Text("Update Property Images"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 185, 183, 175),
                    textStyle: poppinsTextStyle,
                  ),
                ),
                const SizedBox(height: 8),
                _propertyImages.isNotEmpty
                    ? SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _propertyImages.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.all(4),
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Image.file(_propertyImages[index], fit: BoxFit.cover),
                            );
                          },
                        ),
                      )
                    : const Text("No new images selected", style: TextStyle(fontFamily: 'Poppins')),
                const SizedBox(height: 16),
                // Amenities Section.
                const Text(
                  "Amenities",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 8),
                // Food Toggle.
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: const [
                          Icon(Icons.fastfood),
                          SizedBox(width: 8),
                          Text("Food", style: TextStyle(fontFamily: 'Poppins')),
                        ],
                      ),
                    ),
                    Switch(
                      value: _foodAvailable,
                      onChanged: (val) {
                        setState(() {
                          _foodAvailable = val;
                        });
                      },
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Wifi Toggle.
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: const [
                          Icon(Icons.wifi),
                          SizedBox(width: 8),
                          Text("Wifi", style: TextStyle(fontFamily: 'Poppins')),
                        ],
                      ),
                    ),
                    Switch(
                      value: _wifiAvailable,
                      onChanged: (val) {
                        setState(() {
                          _wifiAvailable = val;
                        });
                      },
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Rooms Available Toggle.
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: const [
                          Icon(Icons.meeting_room),
                          SizedBox(width: 8),
                          Text("Rooms Available", style: TextStyle(fontFamily: 'Poppins')),
                        ],
                      ),
                    ),
                    Switch(
                      value: _roomsAvailable,
                      onChanged: (val) {
                        setState(() {
                          _roomsAvailable = val;
                        });
                      },
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Token Amount Payment Field.
                TextFormField(
                  controller: _tokenController,
                  decoration: const InputDecoration(
                    labelText: "Token Amount Payment",
                    prefixIcon: Icon(Icons.payment),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                // Buttons for Update and Delete.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _isLoading ? null : _updatePlace,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 185, 183, 175),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                        textStyle: poppinsTextStyle,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text("Update Place"),
                    ),
                    ElevatedButton(
                      onPressed: _deletePlace,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                        textStyle: poppinsTextStyle,
                      ),
                      child: const Text("Delete Place"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
