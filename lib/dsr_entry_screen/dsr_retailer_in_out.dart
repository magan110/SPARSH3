import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class DsrRetailerInOut extends StatefulWidget {
  const DsrRetailerInOut({super.key});

  @override
  State<DsrRetailerInOut> createState() => _DsrRetailerInOutState();
}

class _DsrRetailerInOutState extends State<DsrRetailerInOut>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // State variables
  String? _purchaserRetailerItem = 'Select';
  String? _areaCode = 'Select';
  DateTime? _selectedDate;

  // Controllers
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _yourLatitudeController = TextEditingController();
  final TextEditingController _yourLongitudeController = TextEditingController();
  final TextEditingController _custLatitudeController = TextEditingController();
  final TextEditingController _custLongitudeController = TextEditingController();
  final TextEditingController _codeSearchController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Color scheme
  final Color _primaryColor = const Color(0xFF2962FF);
  final Color _secondaryColor = const Color(0xFF448AFF);
  final Color _accentColor = const Color(0xFF82B1FF);
  final Color _backgroundColor = const Color(0xFFF5F7FA);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF263238);
  final Color _hintColor = const Color(0xFF90A4AE);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    // Set initial date to today
    _selectedDate = DateTime.now();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _dateController.dispose();
    _yourLatitudeController.dispose();
    _yourLongitudeController.dispose();
    _custLatitudeController.dispose();
    _custLongitudeController.dispose();
    _codeSearchController.dispose();
    _customerNameController.dispose();
    super.dispose();
  }

  // Dropdown items
  final List<String> _purchaserRetailerItems = [
    'Select',
    'AD',
    'Stokiest/Urban Stokiest',
    'Direct Dealer',
    'Retailer',
    'Rural Stokiest',
  ];

  final List<String> _majorCitiesInIndia = [
    'Select',
    'Mumbai',
    'Delhi',
    'Bengaluru',
    'Hyderabad',
    'Ahmedabad',
    'Chennai',
    'Kolkata',
    'Pune',
    'Jaipur',
    'Surat',
    'Lucknow',
    'Kanpur',
    'Nagpur',
    'Indore',
    'Thane',
    'Bhopal',
    'Visakhapatnam',
    'Pimpri-Chinchwad',
    'Patna',
    'Vadodara',
    // ...etc. (truncated for brevity)
  ];

  // City coordinates mapping
  final Map<String, Map<String, double>> _cityCoordinates = {
    'Mumbai': {'latitude': 19.0760, 'longitude': 72.8777},
    'Delhi': {'latitude': 28.7041, 'longitude': 77.1025},
    'Bengaluru': {'latitude': 12.9716, 'longitude': 77.5946},
    'Hyderabad': {'latitude': 17.3850, 'longitude': 78.4867},
    'Ahmedabad': {'latitude': 23.0225, 'longitude': 72.5714},
    'Chennai': {'latitude': 13.0827, 'longitude': 80.2707},
    'Kolkata': {'latitude': 22.5726, 'longitude': 88.3639},
    'Pune': {'latitude': 18.5204, 'longitude': 73.8567},
    'Jaipur': {'latitude': 26.9124, 'longitude': 75.7873},
    'Surat': {'latitude': 21.1702, 'longitude': 72.8311},
    // Add more as needed
  };

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw ('Location services are disabled. Please enable them.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw ('Location permissions are denied. Please grant permissions in settings.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw ('Location permissions are permanently denied. Please enable them in app settings.');
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> _captureYourLocation() async {
    try {
      final pos = await _determinePosition();
      setState(() {
        _yourLatitudeController.text = pos.latitude.toStringAsFixed(6);
        _yourLongitudeController.text = pos.longitude.toStringAsFixed(6);
      });
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _captureCustomerLocation() async {
    try {
      final pos = await _determinePosition();
      setState(() {
        _custLatitudeController.text = pos.latitude.toStringAsFixed(6);
        _custLongitudeController.text = pos.longitude.toStringAsFixed(6);
      });
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showError(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: _primaryColor,
              onPrimary: Colors.white,
              onSurface: _textColor,
            ),
            dialogTheme: const DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  // —— Stubbed submit method ——
  void _onSubmit(String entryType) {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Form validated. Entry type: $entryType'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DSR Retailer IN OUT',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Daily Sales Report Entry',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Help information for DSR Retailer IN OUT'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
        ],
        backgroundColor: _primaryColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Purchaser/Retailer Card
                _buildCard(
                  title: 'Purchaser / Retailer',
                  child: DropdownButtonFormField<String>(
                    value: _purchaserRetailerItem,
                    decoration: _inputDecoration(),
                    items: _purchaserRetailerItems
                        .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                        .toList(),
                    onChanged: (val) => setState(() => _purchaserRetailerItem = val),
                    validator: (value) =>
                    (value == null || value == 'Select') ? 'Please select a type' : null,
                  ),
                ),

                // Area Code Card
                _buildCard(
                  title: 'Area Code',
                  child: DropdownSearch<String>(
                    selectedItem: _areaCode,
                    items: _majorCitiesInIndia,
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: _inputDecoration(hintText: 'Search...')
                            .copyWith(prefixIcon: const Icon(Icons.search)),
                      ),
                    ),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: _inputDecoration(),
                    ),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _areaCode = val;
                          if (_cityCoordinates.containsKey(val)) {
                            _custLatitudeController.text =
                                _cityCoordinates[val]!['latitude']!.toStringAsFixed(6);
                            _custLongitudeController.text =
                                _cityCoordinates[val]!['longitude']!.toStringAsFixed(6);
                          }
                        });
                      }
                    },
                  ),
                ),

                // Code Search Card
                _buildCard(
                  title: 'Code Search',
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _codeSearchController,
                          decoration: _inputDecoration(hintText: 'Enter code'),
                          validator: (value) =>
                          (value == null || value.isEmpty) ? 'Please enter a code' : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: _secondaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.search, color: Colors.white),
                          onPressed: () {
                            // no-op
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Customer Details Card
                _buildCard(
                  title: 'Customer Details',
                  child: TextFormField(
                    controller: _customerNameController,
                    decoration: _inputDecoration(hintText: 'Customer Name'),
                    validator: (value) =>
                    (value == null || value.isEmpty) ? 'Please enter customer name' : null,
                  ),
                ),

                // Date Card
                _buildCard(
                  title: 'Date',
                  child: TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: _inputDecoration(hintText: 'Select Date').copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today, color: _primaryColor),
                        onPressed: _pickDate,
                      ),
                    ),
                    validator: (value) =>
                    (value == null || value.isEmpty) ? 'Please select a date' : null,
                  ),
                ),

                // Location Details Card
                _buildCard(
                  title: 'Location Details',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Your Location
                      Text(
                        'Your Location',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: _textColor.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _yourLatitudeController,
                              readOnly: true,
                              decoration: _inputDecoration(labelText: 'Latitude'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _yourLongitudeController,
                              readOnly: true,
                              decoration: _inputDecoration(labelText: 'Longitude'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildElevatedButton(
                        icon: Icons.my_location,
                        label: 'Capture Your Location',
                        onPressed: _captureYourLocation,
                      ),
                      const SizedBox(height: 16),

                      // Customer Location
                      Text(
                        'Customer Location',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: _textColor.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _custLatitudeController,
                              readOnly: true,
                              decoration: _inputDecoration(labelText: 'Latitude'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _custLongitudeController,
                              readOnly: true,
                              decoration: _inputDecoration(labelText: 'Longitude'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildElevatedButton(
                        icon: Icons.location_on,
                        label: 'Capture Customer Location',
                        onPressed: _captureCustomerLocation,
                      ),
                    ],
                  ),
                ),

                // Action Buttons
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        label: 'IN',
                        color: _primaryColor,
                        onPressed: () => _onSubmit("IN"),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildActionButton(
                        label: 'Exception Entry',
                        color: Colors.orange,
                        onPressed: () => _onSubmit("Exception"),
                      ),
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

  // Helper methods for building UI components

  Widget _buildCard({required String title, required Widget child}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: _textColor)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({String? hintText, String? labelText}) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      filled: true,
      fillColor: _cardColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: TextStyle(color: _hintColor),
      labelStyle: TextStyle(color: _textColor.withOpacity(0.6)),
    );
  }

  Widget _buildElevatedButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: _secondaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        elevation: 2,
      ),
      child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}
