import 'package:flutter/material.dart';
import 'models/item_report.dart';
import 'data/sample_reports.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/report_screen.dart';
import 'screens/item_details_screen.dart';
import 'screens/finder_details_screen.dart';
import 'screens/my_reports_screen.dart';

void main() {
  runApp(const FindItApp());
}

/// Root Application Widget with Material 3 Teal Theme
class FindItApp extends StatelessWidget {
  const FindItApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryTeal = Color(0xFF0F766E);

    return MaterialApp(
      title: 'FindIt',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: primaryTeal,
        scaffoldBackgroundColor: const Color(0xFFF0FDFA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryTeal,
          primary: primaryTeal,
          background: const Color(0xFFF0FDFA),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF0FDFA),
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFF115E59),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const MainNavigationHolder(),
    );
  }
}

/// Main StatefulWidget managing in-memory report state and BottomNavigationBar
class MainNavigationHolder extends StatefulWidget {
  const MainNavigationHolder({Key? key}) : super(key: key);

  @override
  _MainNavigationHolderState createState() => _MainNavigationHolderState();
}

class _MainNavigationHolderState extends State<MainNavigationHolder> {
  bool _showSplash = true;
  int _currentIndex = 0; // 0: Home, 1: Search, 2: My Reports

  // Current simulated student user (Ali Khan by default)
  StudentUser _currentUser = sampleUsers[0];

  // In-memory reports dataset initialized from sample reports
  late List<ItemReport> _reports;

  @override
  void initState() {
    super.initState();
    _reports = getInitialReports();
  }

  // Add new report to the beginning of the list
  void _addReport(ItemReport report) {
    setState(() {
      _reports.insert(0, report);
    });
  }

  // Attach finder details to an active lost report
  void _attachFinderDetails(
    String reportId,
    String finderName,
    String finderPhone,
    String foundLocation,
    String message,
  ) {
    setState(() {
      final index = _reports.indexWhere((r) => r.id == reportId);
      if (index != -1) {
        final existing = _reports[index];
        // Enforce business logic rules: only active Lost reports can take finder details
        if (existing.type == 'Lost' && existing.status == 'Active') {
          existing.status = 'Finder Found';
          existing.finderName = finderName;
          existing.finderPhone = finderPhone;
          existing.foundLocation = foundLocation;
          existing.finderMessage = message;
        }
      }
    });
  }

  // Owner marks the report as recovered
  void _markAsRecovered(String reportId) {
    setState(() {
      final index = _reports.indexWhere((r) => r.id == reportId);
      if (index != -1) {
        // Enforce business logic rule: only report owner can mark recovered
        if (_reports[index].ownerId == _currentUser.id) {
          _reports[index].status = 'Recovered';
        }
      }
    });
  }

  // Show profile switcher modal for testing Ali vs Ahmed workflow
  void _showUserSwitcher() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.person, color: Color(0xFF0F766E)),
            SizedBox(width: 8),
            Text('Switch Student Profile', style: TextStyle(fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFCCFBF1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Switch between Ali (Lost Wallet Owner) and Ahmed (Helpful Finder) to test the end-to-end flow.',
                style: TextStyle(fontSize: 12, color: Color(0xFF115E59)),
              ),
            ),
            const SizedBox(height: 12),
            ...sampleUsers.map((user) {
              final isSelected = user.id == _currentUser.id;
              final role = user.id == 'user_ali'
                  ? 'Lost Wallet Owner'
                  : (user.id == 'user_ahmed' ? 'Finder' : 'Student');

              return ListTile(
                shape: RoundedCornerShape(10),
                selected: isSelected,
                selectedTileColor: const Color(0xFFE0F2FE),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF0F766E),
                  child: Text(user.name.substring(0, 1),
                      style: const TextStyle(color: Colors.white)),
                ),
                title: Text('${user.name} ($role)',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Roll: ${user.studentId} • ${user.phone}',
                    style: const TextStyle(fontSize: 11)),
                onTap: () {
                  setState(() {
                    _currentUser = user;
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Switched profile to ${user.name}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // Screen Routing helpers using Navigator.push
  void _navigateToCreateReport([String type = 'Lost']) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportScreen(
          initialType: type,
          currentUser: _currentUser,
          onReportCreated: _addReport,
        ),
      ),
    );
  }

  void _navigateToItemDetails(ItemReport report) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailsScreen(
          report: report,
          currentUser: _currentUser,
          onFoundThisTap: (reportId) => _navigateToFinderDetails(report),
          onMarkRecoveredTap: (reportId) {
            _markAsRecovered(reportId);
            Navigator.pop(context); // pop back to list
          },
        ),
      ),
    );
  }

  void _navigateToFinderDetails(ItemReport report) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FinderDetailsScreen(
          report: report,
          currentUser: _currentUser,
          onSubmitFinder: (reportId, name, phone, loc, msg) {
            _attachFinderDetails(reportId, name, phone, loc, msg);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show splash screen until user taps Get Started
    if (_showSplash) {
      return SplashScreen(
        onGetStarted: () {
          setState(() {
            _showSplash = false;
          });
        },
      );
    }

    const primaryTeal = Color(0xFF0F766E);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Tab 0: Home Screen
          HomeScreen(
            currentUser: _currentUser,
            reports: _reports,
            onReportTap: (type) => _navigateToCreateReport(type),
            onCategoryTap: (category) {
              setState(() {
                _currentIndex = 1; // switch to search
              });
            },
            onSearchTap: () {
              setState(() {
                _currentIndex = 1;
              });
            },
            onItemTap: _navigateToItemDetails,
            onSwitchUserTap: _showUserSwitcher,
            onSeeAllTap: () {
              setState(() {
                _currentIndex = 1;
              });
            },
          ),

          // Tab 1: Search Screen
          SearchScreen(
            reports: _reports,
            onItemTap: _navigateToItemDetails,
          ),

          // Tab 2: My Reports Screen
          MyReportsScreen(
            currentUser: _currentUser,
            allReports: _reports,
            onViewDetails: _navigateToItemDetails,
            onMarkRecovered: _markAsRecovered,
            onCreateReport: () => _navigateToCreateReport('Lost'),
            onSwitchUser: _showUserSwitcher,
          ),
        ],
      ),

      // BottomNavigationBar demonstration
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: primaryTeal,
        unselectedItemColor: const Color(0xFF9CA3AF),
        backgroundColor: Colors.white,
        elevation: 8,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            activeIcon: Icon(Icons.search, size: 28),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'My Reports',
          ),
        ],
      ),
    );
  }
}
