import 'package:flutter/material.dart';
import 'package:learning2/screens/Home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => NotificationProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SPARSH Notifications',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const NotificationScreen(),
    );
  }
}

class NotificationProvider extends ChangeNotifier {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      icon: Icons.check,
      message: 'Your order #12345 has been confirmed and is being processed.',
      status: 'Completed',
      statusColor: Colors.green,
      iconColor: Colors.green[800]!,
      iconBgColor: Colors.green[100]!,
      date: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    NotificationItem(
      icon: Icons.currency_rupee,
      message: 'Payment of ₹1,500 has been processed successfully.',
      status: 'Completed',
      statusColor: Colors.green,
      iconColor: Colors.green[800]!,
      iconBgColor: Colors.green[100]!,
      date: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationItem(
      icon: Icons.discount,
      message: 'Special 20% discount on all electronics. Limited time offer!',
      status: 'Cancelled',
      statusColor: Colors.red,
      iconColor: Colors.red[800]!,
      iconBgColor: Colors.red[100]!,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    NotificationItem(
      icon: Icons.local_shipping,
      message: 'Your package is out for delivery.',
      status: 'In Progress',
      statusColor: Colors.blue,
      iconColor: Colors.blue[800]!,
      iconBgColor: Colors.blue[100]!,
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
    NotificationItem(
      icon: Icons.person,
      message: 'Your profile has been successfully updated.',
      status: 'In Progress',
      statusColor: Colors.blue,
      iconColor: Colors.blue[800]!,
      iconBgColor: Colors.blue[100]!,
      date: DateTime.now().subtract(const Duration(days: 7)),
    ),
  ];

  List<NotificationItem> get notifications => _notifications;

  void addNotification(NotificationItem notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  void addFirebaseNotification(String? title, String? body) {
    if (title != null && body != null) {
      final notification = NotificationItem(
        icon: Icons.notifications,
        message: '$title: $body',
        status: 'New',
        statusColor: Colors.blue,
        iconColor: Colors.blue[800]!,
        iconBgColor: Colors.blue[100]!,
        date: DateTime.now(),
      );
      addNotification(notification);
    }
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final notifications = notificationProvider.notifications;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          'SPARSH',
          style: TextStyle(
            color: Colors.white,
            fontSize: (MediaQuery.of(context).size.width * 0.045).clamp(
              16.0,
              20.0,
            ),
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body:
          notifications.isEmpty
              ? Center(
                child: Text(
                  'No notifications yet',
                  style: TextStyle(
                    fontSize: (MediaQuery.of(context).size.width * 0.04).clamp(
                      14.0,
                      18.0,
                    ),
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              )
              : ListView.builder(
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.width * 0.04,
                ),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return NotificationCard(item: notifications[index]);
                },
              ),
    );
  }
}

class NotificationItem {
  final IconData icon;
  final String message;
  final String status;
  final Color statusColor;
  final Color iconColor;
  final Color iconBgColor;
  final DateTime date;

  NotificationItem({
    required this.icon,
    required this.message,
    required this.status,
    required this.statusColor,
    required this.iconColor,
    required this.iconBgColor,
    required this.date,
  });
}

class NotificationCard extends StatelessWidget {
  final NotificationItem item;

  const NotificationCard({super.key, required this.item});

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      margin: EdgeInsets.only(bottom: screenWidth * 0.04),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: (screenWidth * 0.1).clamp(32.0, 48.0),
              height: (screenWidth * 0.1).clamp(32.0, 48.0),
              decoration: BoxDecoration(
                color: item.iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                color: item.iconColor,
                size: (screenWidth * 0.06).clamp(20.0, 28.0),
              ),
            ),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.message,
                    style: TextStyle(
                      fontSize: (screenWidth * 0.04).clamp(14.0, 18.0),
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                  SizedBox(height: screenWidth * 0.02),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03,
                          vertical: screenWidth * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: item.statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item.status,
                          style: TextStyle(
                            color: item.statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: (screenWidth * 0.03).clamp(10.0, 14.0),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Flexible(
                        child: Text(
                          _formatDate(item.date),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: (screenWidth * 0.03).clamp(10.0, 14.0),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
