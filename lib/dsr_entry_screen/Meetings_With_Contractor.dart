import 'dart:io'; // Import for File
import 'package:flutter/material.dart';
import 'package:learning2/dsr_entry_screen/dsr_retailer_in_out.dart';
import 'package:intl/intl.dart';
import 'package:learning2/dsr_entry_screen/phone_call_with_builder.dart';
import 'package:learning2/dsr_entry_screen/phone_call_with_unregisterd_purchaser.dart';
import 'package:learning2/dsr_entry_screen/work_from_home.dart';
import 'Meeting_with_new_purchaser.dart';
import 'any_other_activity.dart';
import 'btl_activites.dart';
import 'check_sampling_at_site.dart';
import 'dsr_entry.dart'; // Assuming DsrEntry is the main entry point
import 'package:dropdown_search/dropdown_search.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker package
import '../theme/app_theme.dart'; // Import AppTheme

import 'internal_team_meeting.dart';
import 'office_work.dart';
import 'on_leave.dart';
// Assuming HomeScreen is not directly navigated to from here, but keep if needed
// import 'package:learning2/screens/Home_screen.dart';

class MeetingsWithContractor extends StatefulWidget {
  const MeetingsWithContractor({super.key});

  @override
  State<MeetingsWithContractor> createState() => _MeetingsWithContractorState();
}

class _MeetingsWithContractorState extends State<MeetingsWithContractor> {
  // State variables for dropdowns and date pickers
  String? _processItem = 'Select';
  final List<String> _processdropdownItems = ['Select', 'Add', 'Update'];

  String? _activityItem =
      'Meetings With Contractor / Stockist'; // Default to this activity
  final List<String> _activityDropDownItems = [
    'Select',
    'Personal Visit',
    'Phone Call with Builder/Stockist',
    'Meetings With Contractor / Stockist',
    'Visit to Get / Check Sampling at Site',
    'Meeting with New Purchaser(Trade Purchaser)/Retailer',
    'BTL Activities',
    'Internal Team Meetings / Review Meetings',
    'Office Work',
    'On Leave / Holiday / Off Day',
    'Work From Home',
    'Any Other Activity',
    'Phone call with Unregistered Purchasers',
  ];

  String? _areaCode = 'Select';
  final List<String> _majorCitiesInIndia = [
    'Select',
    'Agra', 'Ahmedabad', 'Ajmer', 'Akola', 'Aligarh',
    'Allahabad', 'Alwar', 'Ambala', 'Amravati', 'Amritsar',
    'Anand', 'Anantapur', 'Aurangabad', 'Asansol', 'Bareilly',
    'Bengaluru', 'Belgaum', 'Bhagalpur', 'Bhavnagar', 'Bhilai',
    'Bhiwandi', 'Bhopal', 'Bhubaneswar', 'Bikaner', 'Bilaspur',
    'Bokaro Steel City', 'Chandigarh', 'Chennai', 'Coimbatore', 'Cuttack',
    'Dehradun', 'Delhi', 'Dhanbad', 'Durgapur', 'Erode',
    'Faridabad', 'Firozabad', 'Gandhinagar', 'Ghaziabad', 'Gorakhpur',
    'Guntur', 'Gurgaon', 'Guwahati', 'Gwalior', 'Haldwani',
    'Haridwar', 'Hubli-Dharwad', 'Hyderabad', 'Imphal', 'Indore',
    'Itanagar', 'Jabalpur', 'Jaipur', 'Jalandhar', 'Jammu',
    'Jamshedpur', 'Jhansi', 'Jodhpur', 'Junagadh', 'Kakinada',
    'Kalyan-Dombivli', 'Kanpur', 'Kochi', 'Kolhapur', 'Kolkata',
    'Kollam', 'Kota', 'Kozhikode', 'Kurnool', 'Lucknow',
    'Ludhiana', 'Madurai', 'Malappuram', 'Mangalore', 'Meerut',
    'Mira-Bhayandar', 'Moradabad', 'Mumbai', 'Mysuru', 'Nagpur',
    'Nanded', 'Nashik', 'Navi Mumbai', 'Nellore', 'Noida',
    'Patna', 'Pimpri-Chinchwad', 'Prayagraj', 'Pune', 'Raipur',
    'Rajkot', 'Rajahmundry', 'Ranchi', 'Rohtak', 'Rourkela',
    'Saharanpur', 'Salem', 'Sangli-Miraj & Kupwad', 'Shillong', 'Shimla',
    'Siliguri', 'Solapur', 'Srinagar', 'Surat', 'Thane',
    'Thiruvananthapuram',
    'Thrissur',
    'Tiruchirappalli',
    'Tirunelveli',
    'Tiruppur',
    'Udaipur', 'Ujjain', 'Ulhasnagar', 'Vadodara', 'Varanasi',
    'Vasai-Virar', 'Vijayawada', 'Visakhapatnam', 'Warangal', 'Yamunanagar',
    // Add more cities here as required
  ];

  // City coordinates mapping (more cities added for demonstration)
  final Map<String, Map<String, double>> _cityCoordinates = {
    'Agra': {'latitude': 27.1767, 'longitude': 78.0081},
    'Ahmedabad': {'latitude': 23.0225, 'longitude': 72.5714},
    'Ajmer': {'latitude': 26.4499, 'longitude': 74.6399},
    'Akola': {'latitude': 20.7063, 'longitude': 77.0202},
    'Aligarh': {'latitude': 27.8974, 'longitude': 78.0880},
    'Allahabad': {'latitude': 25.4358, 'longitude': 81.8463},
    'Alwar': {'latitude': 27.5663, 'longitude': 76.6345},
    'Ambala': {'latitude': 30.3782, 'longitude': 76.7767},
    'Amravati': {'latitude': 20.9374, 'longitude': 77.7797},
    'Amritsar': {'latitude': 31.6340, 'longitude': 74.8737},
    'Anand': {'latitude': 22.5645, 'longitude': 72.9288},
    'Anantapur': {'latitude': 14.6819, 'longitude': 77.6006},
    'Aurangabad': {'latitude': 19.8762, 'longitude': 75.3433},
    'Asansol': {'latitude': 23.6853, 'longitude': 86.9510},
    'Bareilly': {'latitude': 28.3670, 'longitude': 79.4304},
    'Bengaluru': {'latitude': 12.9716, 'longitude': 77.5946},
    'Belgaum': {'latitude': 15.8500, 'longitude': 74.5000},
    'Bhagalpur': {'latitude': 25.2423, 'longitude': 86.9857},
    'Bhavnagar': {'latitude': 21.7652, 'longitude': 72.1519},
    'Bhilai': {'latitude': 21.2167, 'longitude': 81.3833},
    'Bhiwandi': {'latitude': 19.2808, 'longitude': 73.0658},
    'Bhopal': {'latitude': 23.2599, 'longitude': 77.4126},
    'Bhubaneswar': {'latitude': 20.2961, 'longitude': 85.8245},
    'Bikaner': {'latitude': 28.0229, 'longitude': 73.3119},
    'Bilaspur': {'latitude': 22.0929, 'longitude': 82.1407},
    'Bokaro Steel City': {'latitude': 23.6610, 'longitude': 85.9790},
    'Chandigarh': {'latitude': 30.7333, 'longitude': 76.7794},
    'Chennai': {'latitude': 13.0827, 'longitude': 80.2707},
    'Coimbatore': {'latitude': 11.0168, 'longitude': 76.9558},
    'Cuttack': {'latitude': 20.4625, 'longitude': 85.8830},
    'Dehradun': {'latitude': 30.0668, 'longitude': 78.3427},
    'Delhi': {'latitude': 28.7041, 'longitude': 77.1025},
    'Dhanbad': {'latitude': 23.7957, 'longitude': 86.4304},
    'Durgapur': {'latitude': 23.5204, 'longitude': 87.3119},
    'Erode': {'latitude': 11.3410, 'longitude': 77.7172},
    'Faridabad': {'latitude': 28.4089, 'longitude': 77.3178},
    'Firozabad': {'latitude': 27.1500, 'longitude': 78.4200},
    'Gandhinagar': {'latitude': 23.2156, 'longitude': 72.6369},
    'Ghaziabad': {'latitude': 28.6692, 'longitude': 77.4538},
    'Gorakhpur': {'latitude': 26.7606, 'longitude': 83.3731},
    'Guntur': {'latitude': 16.3067, 'longitude': 80.4428},
    'Gurgaon': {'latitude': 28.4595, 'longitude': 77.0266},
    'Guwahati': {'latitude': 26.1445, 'longitude': 91.7362},
    'Gwalior': {'latitude': 26.2183, 'longitude': 78.1741},
    'Haldwani': {'latitude': 29.2167, 'longitude': 79.5167},
    'Haridwar': {'latitude': 29.9457, 'longitude': 78.1642},
    'Hubli-Dharwad': {'latitude': 15.3647, 'longitude': 75.1240},
    'Hyderabad': {'latitude': 17.3850, 'longitude': 78.4867},
    'Imphal': {'latitude': 24.8170, 'longitude': 93.9368},
    'Indore': {'latitude': 22.7196, 'longitude': 75.8577},
    'Itanagar': {'latitude': 27.1000, 'longitude': 93.6200},
    'Jabalpur': {'latitude': 23.1815, 'longitude': 79.9215},
    'Jaipur': {'latitude': 26.9124, 'longitude': 75.7873},
    'Jalandhar': {'latitude': 31.3260, 'longitude': 75.5762},
    'Jammu': {'latitude': 32.7333, 'longitude': 74.8500},
    'Jamshedpur': {'latitude': 22.8045, 'longitude': 86.2029},
    'Jhansi': {'latitude': 25.4484, 'longitude': 78.5685},
    'Jodhpur': {'latitude': 26.2389, 'longitude': 73.0243},
    'Junagadh': {'latitude': 21.5200, 'longitude': 70.5500},
    'Kakinada': {'latitude': 16.9900, 'longitude': 82.2000},
    'Kalyan-Dombivli': {'latitude': 19.2167, 'longitude': 73.1333},
    'Kanpur': {'latitude': 26.4499, 'longitude': 80.3319},
    'Kochi': {'latitude': 9.9312, 'longitude': 76.2673},
    'Kolhapur': {'latitude': 16.7050, 'longitude': 74.2433},
    'Kolkata': {'latitude': 22.5726, 'longitude': 88.3639},
    'Kollam': {'latitude': 8.8932, 'longitude': 76.6141},
    'Kota': {'latitude': 25.2138, 'longitude': 75.8648},
    'Kozhikode': {'latitude': 11.2588, 'longitude': 75.7804},
    'Kurnool': {'latitude': 15.8281, 'longitude': 78.0369},
    'Lucknow': {'latitude': 26.8467, 'longitude': 80.9462},
    'Ludhiana': {'latitude': 30.9010, 'longitude': 75.8573},
    'Madurai': {'latitude': 9.9252, 'longitude': 78.1149},
    'Malappuram': {'latitude': 11.0590, 'longitude': 76.0730},
    'Mangalore': {'latitude': 12.9141, 'longitude': 74.8560},
    'Meerut': {'latitude': 28.9845, 'longitude': 77.7064},
    'Mira-Bhayandar': {'latitude': 19.2900, 'longitude': 72.8500},
    'Moradabad': {'latitude': 28.8380, 'longitude': 78.7680},
    'Mumbai': {'latitude': 19.0760, 'longitude': 72.8777},
    'Mysuru': {'latitude': 12.2958, 'longitude': 76.6394},
    'Nagpur': {'latitude': 21.1458, 'longitude': 79.0882},
    'Nanded': {'latitude': 19.1387, 'longitude': 77.3224},
    'Nashik': {'latitude': 19.9975, 'longitude': 73.7898},
    'Navi Mumbai': {'latitude': 19.0330, 'longitude': 73.0297},
    'Nellore': {'latitude': 14.4426, 'longitude': 79.9865},
    'Noida': {'latitude': 28.5355, 'longitude': 77.3910},
    'Patna': {'latitude': 25.5941, 'longitude': 85.1376},
    'Pimpri-Chinchwad': {'latitude': 18.6278, 'longitude': 73.8008},
    'Prayagraj': {'latitude': 25.4358, 'longitude': 81.8463},
    'Pune': {'latitude': 18.5204, 'longitude': 73.8567},
    'Raipur': {'latitude': 21.2514, 'longitude': 81.6296},
    'Rajkot': {'latitude': 22.2959, 'longitude': 70.7984},
    'Rajahmundry': {'latitude': 17.0000, 'longitude': 81.8000},
    'Ranchi': {'latitude': 23.3441, 'longitude': 85.3096},
    'Rohtak': {'latitude': 28.8955, 'longitude': 76.6066},
    'Rourkela': {'latitude': 22.2608, 'longitude': 84.8522},
    'Saharanpur': {'latitude': 29.9649, 'longitude': 77.5468},
    'Salem': {'latitude': 11.6643, 'longitude': 78.1460},
    'Sangli-Miraj & Kupwad': {'latitude': 16.8667, 'longitude': 74.5667},
    'Shillong': {'latitude': 25.5788, 'longitude': 91.8933},
    'Shimla': {'latitude': 31.1048, 'longitude': 77.1734},
    'Siliguri': {'latitude': 26.7271, 'longitude': 88.3953},
    'Solapur': {'latitude': 17.6599, 'longitude': 75.9064},
    'Srinagar': {'latitude': 34.0836, 'longitude': 74.7973},
    'Surat': {'latitude': 21.1702, 'longitude': 72.8311},
    'Thane': {'latitude': 19.2183, 'longitude': 73.0741},
    'Thiruvananthapuram': {'latitude': 8.5241, 'longitude': 76.9361},
    'Thrissur': {'latitude': 10.5276, 'longitude': 76.2144},
    'Tiruchirappalli': {'latitude': 10.8150, 'longitude': 78.6970},
    'Tirunelveli': {'latitude': 8.7139, 'longitude': 77.7567},
    'Tiruppur': {'latitude': 11.1085, 'longitude': 77.3411},
    'Udaipur': {'latitude': 24.5854, 'longitude': 73.7125},
    'Ujjain': {'latitude': 23.1794, 'longitude': 75.7885},
    'Ulhasnagar': {'latitude': 19.2167, 'longitude': 73.1667},
    'Vadodara': {'latitude': 22.3072, 'longitude': 73.1812},
    'Varanasi': {'latitude': 25.3176, 'longitude': 82.9739},
    'Vasai-Virar': {'latitude': 19.4200, 'longitude': 72.8200},
    'Vijayawada': {'latitude': 16.5062, 'longitude': 80.6480},
    'Visakhapatnam': {'latitude': 17.6868, 'longitude': 83.2185},
    'Warangal': {'latitude': 17.9689, 'longitude': 79.5941},
    'Yamunanagar': {'latitude': 30.1381, 'longitude': 77.2677},
  };

  String? _purchaserItem = 'Select';
  final List<String> _purchaserdropdownItems = [
    'Select',
    'Purchaser(Non Trade)',
    'AUTHORISED DEALER',
  ];

  // Controllers for date text fields
  final TextEditingController _submissionDateController =
      TextEditingController(); // Renamed for clarity
  final TextEditingController _reportDateController = TextEditingController();

  // State variables to hold selected dates
  DateTime? _selectedSubmissionDate; // Renamed for clarity
  DateTime? _selectedReportDate;

  // Lists for image uploads
  final List<int> _uploadRows = [0]; // Tracks the number of image upload rows
  final ImagePicker _picker = ImagePicker(); // Initialize ImagePicker
  // List to hold selected image files for each row
  final List<File?> _selectedImages = [
    null,
  ]; // Initialize with null for the first row

  // Location controllers
  final TextEditingController _yourLatitudeController = TextEditingController();
  final TextEditingController _yourLongitudeController =
      TextEditingController();
  final TextEditingController _custLatitudeController = TextEditingController();
  final TextEditingController _custLongitudeController =
      TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose controllers when the widget is removed
    _submissionDateController.dispose();
    _reportDateController.dispose();
    _yourLatitudeController.dispose();
    _yourLongitudeController.dispose();
    _custLatitudeController.dispose();
    _custLongitudeController.dispose();
    super.dispose();
  }

  // Function to pick the submission date
  Future<void> _pickSubmissionDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedSubmissionDate ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          // Apply a custom theme for the date picker
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black87, // Body text color
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: AppTheme.primaryColor, // Dialog background
            ), // Dialog background
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedSubmissionDate = picked;
        _submissionDateController.text = DateFormat(
          'yyyy-MM-dd',
        ).format(picked);
      });
    }
  }

  // Function to pick the report date
  Future<void> _pickReportDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedReportDate ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          // Apply a custom theme for the date picker
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black87, // Body text color
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: AppTheme.primaryColor, // Dialog background
            ), // Dialog background
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedReportDate = picked;
        _reportDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  // Function to add a new image upload row
  void _addRow() {
    setState(() {
      _uploadRows.add(_uploadRows.length); // Add a new index
      _selectedImages.add(null); // Add null for the new row's image
    });
  }

  // Function to remove the last image upload row
  void _removeRow() {
    if (_uploadRows.length <= 1) return; // Prevent removing the last row
    setState(() {
      _uploadRows.removeLast(); // Remove the last index
      _selectedImages.removeLast(); // Remove the last image entry
    });
  }

  // Function to handle image picking for a specific row
  Future<void> _pickImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImages[index] = File(pickedFile.path);
      });
    } else {
      print('No image selected for row $index.'); // Important for debugging
    }
  }

  // Function to show the selected image in a dialog
  void _showImageDialog(File imageFile) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          // Use a Dialog widget for a modal popup
          child: Container(
            width:
                MediaQuery.of(context).size.width * 0.8, // 80% of screen width
            height:
                MediaQuery.of(context).size.height *
                0.6, // 60% of screen height
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain, // Fit the image within the container
                image: FileImage(imageFile), // Load image from file
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper for navigation (similar to other DSR screens)
  void _navigateTo(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.scaffoldBackgroundColor, // Modern light background
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              // Navigate back to the DsrEntry screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DsrEntry()),
              );
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 22,
            ),
          ),
          title: const Text(
            'Meetings With Contractor',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          backgroundColor: AppTheme.primaryColor, // Match dsr_entry color
          elevation: 0, // Flat design like dsr_entry
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          actions: [
            // Add actions/icons to the right side of AppBar
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                // Refresh functionality
                setState(() {
                  // Reset form or refresh data
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {
                // Show more options menu
                showMenu(
                  context: context,
                  position: const RelativeRect.fromLTRB(100, 80, 0, 0),
                  items: [
                    const PopupMenuItem(
                      value: 'clear',
                      child: Text('Clear Form'),
                    ),
                    const PopupMenuItem(value: 'help', child: Text('Help')),
                  ],
                  elevation: 8.0,
                ).then((value) {
                  if (value == 'clear') {
                    // Clear form logic
                    setState(() {
                      // Reset form fields
                    });
                  } else if (value == 'help') {
                    // Show help dialog
                  }
                });
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppTheme.scaffoldBackgroundColor, Colors.grey.shade100],
              stops: const [0.0, 1.0],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Enhanced Instructions Section
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade50, Colors.blue.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryColor.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.info_outline,
                                color: AppTheme.primaryColor,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Activity Information',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Please fill in the details of your meeting with the contractor.',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  // Process Type Dropdown
                  _buildLabel('Process type'),
                  const SizedBox(height: 8), // Reduced spacing below label
                  _buildDropdownField(
                    value: _processItem,
                    items: _processdropdownItems,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() => _processItem = newValue);
                      }
                    },
                  ),
                  const SizedBox(height: 24), // Increased spacing
                  // Activity Type Dropdown (for navigation)
                  _buildLabel('Activity Type'),
                  const SizedBox(height: 8), // Reduced spacing below label
                  _buildDropdownField(
                    value: _activityItem,
                    items: _activityDropDownItems,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() => _activityItem = newValue);

                        // Navigation logic based on selected activity
                        if (newValue == 'Personal Visit') {
                          _navigateTo(const DsrRetailerInOut());
                        } else if (newValue ==
                            'Phone Call with Builder/Stockist') {
                          _navigateTo(const PhoneCallWithBuilder());
                        } else if (newValue ==
                            'Meetings With Contractor / Stockist') {
                          // This is the current page, no navigation needed
                        } else if (newValue ==
                            'Visit to Get / Check Sampling at Site') {
                          _navigateTo(const CheckSamplingAtSite());
                        } else if (newValue ==
                            'Meeting with New Purchaser(Trade Purchaser)/Retailer') {
                          _navigateTo(const MeetingWithNewPurchaser());
                        } else if (newValue == 'BTL Activities') {
                          _navigateTo(const BtlActivites());
                        } else if (newValue ==
                            'Internal Team Meetings / Review Meetings') {
                          _navigateTo(const InternalTeamMeeting());
                        } else if (newValue == 'Office Work') {
                          _navigateTo(const OfficeWork());
                        } else if (newValue == 'On Leave / Holiday / Off Day') {
                          _navigateTo(const OnLeave());
                        } else if (newValue == 'Work From Home') {
                          _navigateTo(const WorkFromHome());
                        } else if (newValue == 'Any Other Activity') {
                          _navigateTo(const AnyOtherActivity());
                        } else if (newValue ==
                            'Phone call with Unregistered Purchasers') {
                          _navigateTo(
                            const PhoneCallWithUnregisterdPurchaser(),
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 24), // Increased spacing
                  // Submission Date Field
                  _buildLabel('Submission Date'),
                  const SizedBox(height: 8), // Reduced spacing below label
                  _buildDateField(
                    _submissionDateController,
                    _pickSubmissionDate,
                    'Select Date',
                  ),
                  const SizedBox(height: 24), // Increased spacing
                  // Report Date Field
                  _buildLabel('Report Date'),
                  const SizedBox(height: 8), // Reduced spacing below label
                  _buildDateField(
                    _reportDateController,
                    _pickReportDate,
                    'Select Date',
                  ),
                  const SizedBox(height: 24), // Increased spacing
                  // Area code Dropdown (Searchable)
                  _buildLabel('Area code *:'),
                  const SizedBox(height: 8),
                  _buildSearchableDropdownField(
                    // Using the styled searchable dropdown
                    selected:
                        _areaCode!, // Use non-nullable as it's initialized
                    items: _majorCitiesInIndia,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _areaCode = val;
                          // Set latitude and longitude based on the selected area code
                          if (_cityCoordinates.containsKey(val)) {
                            _custLatitudeController.text =
                                _cityCoordinates[val]!['latitude']!.toString();
                            _custLongitudeController.text =
                                _cityCoordinates[val]!['longitude']!.toString();
                          } else {
                            // Clear coordinates if city not found in map
                            _custLatitudeController.clear();
                            _custLongitudeController.clear();
                          }
                        });
                      }
                    },
                    validator: (value) {
                      // Add validator for the searchable dropdown
                      if (value == null || value == 'Select') {
                        return 'Please select an Area Code';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24), // Increased spacing
                  // Purchaser Dropdown
                  _buildLabel('Purchaser'),
                  const SizedBox(height: 8),
                  _buildDropdownField(
                    // Using the styled dropdown helper
                    value: _purchaserItem,
                    items: _purchaserdropdownItems,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() => _purchaserItem = newValue);
                      }
                    },
                  ),
                  const SizedBox(height: 24), // Increased spacing
                  // Code Field with search icon
                  _buildLabel('Code *:'),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align items at the top
                    children: [
                      Expanded(
                        child: _buildTextField(
                          // Using styled text field helper
                          'Purchaser code',
                          validator: (value) {
                            // Add validator for the code field
                            if (value == null || value.isEmpty) {
                              return 'Please enter purchaser code';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ), // Spacing between text field and button
                      _buildIconButton(
                        // Using styled icon button helper
                        Icons.search,
                        () {
                          // TODO: perform code search logic here
                          print('Search button pressed'); // Placeholder print
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24), // Increased spacing
                  // New Orders Received Field
                  _buildLabel('New Orders Received'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    'Enter New Orders Received',
                    maxLines: 3,
                  ), // Using the helper method, multi-line
                  const SizedBox(height: 24), // Increased spacing
                  // Ugai Recovery Plans Field
                  _buildLabel('Ugai Recovery Plans'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    'Enter Ugai Recovery Plans',
                    maxLines: 3,
                  ), // Using the helper method, multi-line
                  const SizedBox(height: 24), // Increased spacing
                  // Any Purchaser Grievances Field
                  _buildLabel('Any Purchaser Grievances'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    'Enter Any Purchaser Grievances',
                    maxLines: 3,
                  ), // Using the helper method, multi-line
                  const SizedBox(height: 24), // Increased spacing
                  // Any Other Points Field
                  _buildLabel('Any Other Points'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    'Enter Any Other Points',
                    maxLines: 3,
                  ), // Using the helper method, multi-line
                  const SizedBox(
                    height: 24,
                  ), // Increased spacing before image upload
                  // Image Upload Section
                  _buildLabel('Upload Supporting'),
                  const SizedBox(height: 8),

                  Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.photo_library_rounded,
                              color: AppTheme.primaryColor,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Supporting Documents',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Upload images related to your activity',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Image upload rows with enhanced UI
                        ...List.generate(_uploadRows.length, (index) {
                          final i = _uploadRows[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    _selectedImages[i] != null
                                        ? Colors.green.shade200
                                        : Colors.grey.shade200,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor.withOpacity(
                                          0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Document ${index + 1}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primaryColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    if (_selectedImages[i] != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade100,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                              size: 16,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              'Uploaded',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                // Preview of the image if selected
                                if (_selectedImages[i] != null)
                                  GestureDetector(
                                    onTap:
                                        () => _showImageDialog(
                                          _selectedImages[i]!,
                                        ),
                                    child: Container(
                                      height: 120,
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(bottom: 16),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: FileImage(_selectedImages[i]!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          margin: const EdgeInsets.all(8),
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                              0.6,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.zoom_in,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () => _pickImage(i),
                                        icon: Icon(
                                          _selectedImages[i] != null
                                              ? Icons.refresh
                                              : Icons.upload_file,
                                          size: 18,
                                        ),
                                        label: Text(
                                          _selectedImages[i] != null
                                              ? 'Replace'
                                              : 'Upload',
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor:
                                              _selectedImages[i] != null
                                                  ? Colors.amber.shade600
                                                  : AppTheme.primaryColor,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (_selectedImages[i] != null) ...[
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed:
                                              () => _showImageDialog(
                                                _selectedImages[i]!,
                                              ),
                                          icon: const Icon(
                                            Icons.visibility,
                                            size: 18,
                                          ),
                                          label: const Text('View'),
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.green,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                        // Add/Remove buttons in a row at the bottom
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _addRow,
                              icon: const Icon(
                                Icons.add_photo_alternate,
                                size: 20,
                              ),
                              label: const Text('Document'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blueAccent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            if (_uploadRows.length > 1)
                              ElevatedButton.icon(
                                onPressed: _removeRow,
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  size: 20,
                                ),
                                label: const Text('Remove'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.redAccent,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ), // Increased spacing before buttons
                  // Submit Buttons
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .stretch, // Stretch buttons to full width
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // TODO: implement submit and new logic
                          if (_formKey.currentState!.validate()) {
                            print('Form is valid. Submit and New.');
                            // Add your submission logic here
                            _showSuccessDialog(
                              "Data submitted successfully (Submit & New)!",
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              Colors.blueAccent, // Match theme color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ), // Increased vertical padding
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ), // Larger, bold text
                          elevation: 3.0, // Add slight elevation
                        ),
                        child: const Text('Submit & New'),
                      ),
                      const SizedBox(height: 16), // Spacing between buttons
                      ElevatedButton(
                        onPressed: () {
                          // TODO: implement submit and exit logic
                          if (_formKey.currentState!.validate()) {
                            print('Form is valid. Submit and Exit.');
                            // Add your submission logic here and then navigate back
                            _showSuccessDialog(
                              "Data submitted successfully (Submit & Exit)!",
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green, // Match theme color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          elevation: 3.0,
                        ),
                        child: const Text('Submit & Exit'),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: implement view submitted data logic
                          print('View Submitted Data button pressed');
                          // Add logic to view submitted data
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.blue, // Blue text
                          backgroundColor: Colors.white, // White background
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                              color: Colors.blueAccent,
                            ), // Blue border
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          elevation: 1.0, // Less elevation
                        ),
                        child: const Text('Click to see Submitted Data'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20), // Spacing at the bottom
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Methods for Building Widgets ---

  // Helper to build a standard text field
  Widget _buildTextField(
    String hintText, {
    TextEditingController? controller,
    TextInputType? keyboardType,
    int maxLines = 1, // Default to single line
    String? Function(String?)? validator,
    bool readOnly = false, // Added readOnly parameter
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      readOnly: readOnly, // Apply readOnly property
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[500], // Slightly darker grey hint text
          fontSize: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
          borderSide: BorderSide.none, // No visible border line
        ),
        filled: true, // Add a background fill
        fillColor: Colors.white, // White background for text fields
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ), // Adjusted padding
      ),
      validator: validator, // Assign the validator function
    );
  }

  // Helper to build a date input field
  Widget _buildDateField(
    TextEditingController controller,
    VoidCallback onTap,
    String hintText,
  ) {
    return TextFormField(
      controller: controller,
      readOnly: true, // Make the text field read-only
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
        suffixIcon: IconButton(
          icon: const Icon(
            Icons.calendar_today,
            color: Colors.blueAccent,
          ), // Blue calendar icon
          onPressed: onTap, // Call the provided onTap function
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none, // No visible border line
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
      onTap: onTap, // Allow tapping the field itself to open date picker
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a date';
        }
        return null;
      },
    );
  }

  // Helper to build a standard text label
  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 16, // Slightly smaller label font size
      fontWeight: FontWeight.w600, // Slightly bolder
      color: Colors.black87, // Darker text color
    ),
  );

  // Helper to build a standard dropdown field (not searchable)
  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 50, // Fixed height for consistency
      padding: const EdgeInsets.symmetric(horizontal: 12), // Adjusted padding
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Rounded corners
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ), // Lighter border
        color: Colors.white, // White background
      ),
      child: DropdownButton<String>(
        dropdownColor: Colors.white,
        isExpanded: true, // Expand to fill the container
        underline: Container(), // Remove the default underline
        value: value,
        onChanged: onChanged,
        items:
            items
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ), // Darker text color
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  // Helper to build a searchable dropdown field (using dropdown_search)
  Widget _buildSearchableDropdownField({
    required String selected,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator, // Added validator
  }) => DropdownSearch<String>(
    items: items,
    selectedItem: selected,
    onChanged: onChanged,
    validator: validator, // Assign the validator
    popupProps: PopupProps.menu(
      showSearchBox: true,
      searchFieldProps: const TextFieldProps(
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(color: Colors.black54), // Darker hint text
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ), // Rounded corners
            borderSide: BorderSide(color: Colors.blueAccent), // Blue border
          ),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
      itemBuilder:
          (context, item, isSelected) => Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              item,
              style: const TextStyle(color: Colors.black87),
            ), // Darker text color
          ),
    ),
    dropdownDecoratorProps: DropDownDecoratorProps(
      dropdownSearchDecoration: InputDecoration(
        hintText: 'Select',
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ), // Adjusted padding
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
          borderSide: BorderSide(color: Colors.grey.shade300), // Lighter border
        ),
      ),
    ),
  );

  // Helper to build an icon button (e.g., search icon)
  Widget _buildIconButton(IconData icon, VoidCallback onPressed) => Container(
    height: 50, // Match height of text fields/dropdowns
    width: 50, // Fixed width
    decoration: BoxDecoration(
      color: Colors.blueAccent, // Match theme color
      borderRadius: BorderRadius.circular(10),
    ), // Rounded corners
    child: IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: onPressed,
    ),
  );

  // Helper to build a standard elevated button
  Widget _buildButton(String label, VoidCallback onPressed) => ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.blueAccent, // Match theme color
      padding: const EdgeInsets.symmetric(vertical: 14), // Adjusted padding
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ), // Larger, bold text
      elevation: 3.0, // Add slight elevation
    ),
    child: Text(label),
  );

  // Helper method to show a success dialog
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Success'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}




