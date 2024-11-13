// lib/main.dart
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _handleDeepLink();
  }

  void _handleDeepLink() async {
    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      _navigateFromLink(initialLink);
    }

    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _navigateFromLink(uri);
      }
    });
  }

  void _navigateFromLink(Uri uri) {
    if (uri.pathSegments.contains('course')) {
      final name = uri.queryParameters['name'] ?? 'Unknown';
      final description = uri.queryParameters['description'] ?? 'No description';
      final duration = uri.queryParameters['duration'] ?? '0';

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CourseScreen(
            course: Course(
              name: name,
              description: description,
              duration: duration,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deep Link Demo',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text('Welcome to the Home Screen! Navigate using deep links.'),
      ),
    );
  }
}

class CourseScreen extends StatelessWidget {
  final Course course;

  CourseScreen({required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description: ${course.description}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Duration: ${course.duration}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class Course {
  final String name;
  final String description;
  final String duration;

  Course({
    required this.name,
    required this.description,
    required this.duration,
  });
}
