import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/login_screen.dart';

class WorkerAppDrawer extends StatefulWidget {
  const WorkerAppDrawer({super.key});

  @override
  State<WorkerAppDrawer> createState() => _WorkerAppDrawerState();
}

class _WorkerAppDrawerState extends State<WorkerAppDrawer> {
  // Selected category
  String _selectedCategory = 'Accounts';

  // List of categories
  final List<String> _categories = [
    'Accounts',
    'HR&Admin',
    'General',
    'Personnel',
    'Employee',
  ];

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAdminLoggedIn', false);
    await prefs.setBool('isLoggedIn', false);

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Drawer header with Birla White
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blueAccent, // A slightly more vibrant blue
                gradient: LinearGradient(
                  // Add a subtle gradient
                  colors: [Colors.blueAccent, Colors.lightBlueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  // Add a shadow for depth
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Error handling for image loading is good
                  SizedBox(
                    width: (MediaQuery.of(context).size.width * 0.8).clamp(
                      200.0,
                      400.0,
                    ),
                    child: Image.asset(
                      'assets/logo.png', // Ensure this asset exists in pubspec.yaml
                      height: (MediaQuery.of(context).size.width * 0.24).clamp(
                        80.0,
                        120.0,
                      ),
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        print('Error loading drawer header image: $error');
                        return Icon(
                          Icons.business,
                          size: (MediaQuery.of(context).size.width * 0.15)
                              .clamp(50.0, 70.0),
                          color: Colors.white,
                        ); // Placeholder icon
                      },
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.03,
                  ), // Increased spacing
                  Text(
                    'Birla White',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: (MediaQuery.of(context).size.width * 0.045)
                          .clamp(16.0, 20.0), // Slightly larger font size
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2, // Added letter spacing
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Categories list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;

                  return Container(
                    color: isSelected ? Colors.lightBlue : Colors.white,
                    child: ListTile(
                      title: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: (MediaQuery.of(context).size.width * 0.04)
                              .clamp(14.0, 18.0),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            // Logout option
            Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: (MediaQuery.of(context).size.width * 0.04).clamp(
                    14.0,
                    18.0,
                  ),
                ),
                overflow: TextOverflow.ellipsis,
              ),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }
}
