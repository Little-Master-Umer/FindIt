import 'package:flutter/material.dart';
import '../models/item_report.dart';
import '../data/sample_reports.dart';
import '../widgets/item_card.dart';
import '../widgets/category_tile.dart';

/// Screen 2: Home Screen with branding, quick actions, categories, and recent reports
class HomeScreen extends StatelessWidget {
  final StudentUser currentUser;
  final List<ItemReport> reports;
  final Function(String reportType) onReportTap;
  final Function(String category) onCategoryTap;
  final VoidCallback onSearchTap;
  final Function(ItemReport report) onItemTap;
  final VoidCallback onSwitchUserTap;
  final VoidCallback onSeeAllTap;

  const HomeScreen({
    super.key,
    required this.currentUser,
    required this.reports,
    required this.onReportTap,
    required this.onCategoryTap,
    required this.onSearchTap,
    required this.onItemTap,
    required this.onSwitchUserTap,
    required this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    const primaryTeal = Color(0xFF0F766E);
    final categories = ['Electronics', 'Cards', 'Accessories', 'Other'];

    return Scaffold(
      backgroundColor: const Color(0xFFF0FDFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0FDFA),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: primaryTeal,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.search, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FindIt',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF115E59),
                  ),
                ),
                Text(
                  'Campus Lost & Found',
                  style: TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Simulated student profile badge with quick switch dialog
          InkWell(
            onTap: onSwitchUserTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFCCFBF1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: primaryTeal,
                    child: Text(
                      currentUser.name.substring(0, 1),
                      style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    currentUser.name.split(' ')[0],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF115E59),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.swap_horiz, size: 14, color: primaryTeal),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, ${currentUser.name.split(' ')[0]} 👋',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Find what you lost or return what you found on campus.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                    ),
                    const SizedBox(height: 12),

                    // Quick Search Bar
                    GestureDetector(
                      onTap: onSearchTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.search,
                                size: 20, color: Color(0xFF9CA3AF)),
                            SizedBox(width: 10),
                            Text(
                              'Search item name (e.g. Wallet, ID card)...',
                              style: TextStyle(
                                  fontSize: 13, color: Color(0xFF9CA3AF)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Report Buttons (Lost vs Found)
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => onReportTap('Lost'),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.search,
                              size: 24, color: Color(0xFF991B1B)),
                          SizedBox(height: 8),
                          Text(
                            'Report Lost',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF991B1B),
                            ),
                          ),
                          Text(
                            'I lost an item',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFFB91C1C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () => onReportTap('Found'),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCCFBF1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.handshake, size: 24, color: primaryTeal),
                          SizedBox(height: 8),
                          Text(
                            'Report Found',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF115E59),
                            ),
                          ),
                          Text(
                            'I found an item',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF0F766E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Categories Section
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 10),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories
                    .map((cat) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: CategoryTile(
                            category: cat,
                            isSelected: false,
                            onTap: () => onCategoryTap(cat),
                          ),
                        ))
                    .toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Recent Reports Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Reports',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                TextButton(
                  onPressed: onSeeAllTap,
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      color: primaryTeal,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),

            // Render Recent 4 items
            ...reports.take(4).map(
                  (report) => ItemCard(
                    report: report,
                    onTap: () => onItemTap(report),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
