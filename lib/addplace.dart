import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPlace extends StatefulWidget {
  const AddPlace({Key? key}) : super(key: key);

  @override
  State<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _rentController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();

  File? _tradeCertificate;
  List<File> _propertyImages = [];
  bool _foodAvailable = false;
  bool _wifiAvailable = false;
  bool _roomsAvailable = false;

  // Property type selection: "Room" or "PG/Hostel"
  String _selectedPropertyType = "Room";

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickTradeCertificate() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _tradeCertificate = File(file.path);
      });
    }
  }

  Future<void> _pickPropertyImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null && images.isNotEmpty) {
      setState(() {
        _propertyImages = images.map((e) => File(e.path)).toList();
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      debugPrint("Property Type: $_selectedPropertyType");
      debugPrint("Name: ${_nameController.text}");
      debugPrint("Address: ${_addressController.text}");
      debugPrint("Phone: ${_phoneController.text}");
      debugPrint("Rent: ${_rentController.text}");
      debugPrint("Token: ${_tokenController.text}");
      if (_selectedPropertyType == "PG/Hostel") {
        debugPrint("Trade Certificate: ${_tradeCertificate != null ? 'Uploaded' : 'Not Uploaded'}");
      }
      debugPrint("Images Count: ${_propertyImages.length}");
      debugPrint("Amenities: Food=$_foodAvailable, Wifi=$_wifiAvailable, Rooms Available=$_roomsAvailable");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Place added successfully!")),
      );
      // Reset form or navigate as needed.
    }
  }

  @override
  Widget build(BuildContext context) {
    final darkBlue = Colors.blue.shade900;
    final offWhite = Colors.grey.shade200;
    const orangeColor = Colors.orange;
    const poppinsTextStyle = TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Place",
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Property Type Selection
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
              // Name Field (label updates based on property type)
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: _selectedPropertyType == "Room"
                      ? "Name of Room"
                      : "Name of PG/Hostel",
                  prefixIcon: const Icon(Icons.home),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Please enter a name" : null,
              ),
              const SizedBox(height: 16),
              // Address Field
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: "Address",
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Please enter an address" : null,
              ),
              const SizedBox(height: 16),
              // Phone Number Field
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value == null || value.isEmpty ? "Please enter a phone number" : null,
              ),
              const SizedBox(height: 16),
              // Rent Amount Field with INR icon
              TextFormField(
                controller: _rentController,
                decoration: const InputDecoration(
                  labelText: "Rent Amount",
                  prefixIcon: Icon(Icons.currency_rupee),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? "Please enter rent amount" : null,
              ),
              const SizedBox(height: 16),
              // Conditional: Trade Certificate Upload for PG/Hostel only.
              if (_selectedPropertyType == "PG/Hostel") ...[
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickTradeCertificate,
                      icon: const Icon(Icons.upload_file),
                      label: const Text("Upload Trade Certificate"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: offWhite,
                        textStyle: poppinsTextStyle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _tradeCertificate != null
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const Icon(Icons.cancel, color: Colors.red),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  "Trade Certificate must be legitimate as per Karnataka Govt law, Section 420, IPC - Cheating: Any person who cheats and dishonestly induces another to deliver property or secure an undue advantage shall be subject to imprisonment and/or fine.",
                  style: TextStyle(color: Colors.red, fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 16),
              ],
              // Property Images Upload
              ElevatedButton.icon(
                onPressed: _pickPropertyImages,
                icon: const Icon(Icons.image),
                label: const Text("Upload Property Images"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: offWhite,
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
                  : const Text("No images selected", style: TextStyle(fontFamily: 'Poppins')),
              const SizedBox(height: 16),
              // Amenities Section with toggles
              const Text(
                "Amenities",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 8),
              // Food Toggle
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
              // Wifi Toggle
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
              // Rooms Available Toggle
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
              // Token Amount Payment Field
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
              // Submit Button (Only "Add Place" is Orange)
              Center(
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeColor,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    textStyle: poppinsTextStyle,
                  ),
                  child: const Text("Add Place"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
