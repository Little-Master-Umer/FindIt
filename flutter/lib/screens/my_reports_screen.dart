import 'package:flutter/material.dart';
import '../models/item_report.dart';
import '../data/sample_reports.dart';

/// Screen 7: My Reports Screen with owner-only "Mark as Recovered" confirmation
class MyReportsScreen extends StatelessWidget {
  final StudentUser currentUser;
  final List<ItemReport> allReports;
  final Function(ItemReport report) onViewDetails;
  final Function(String reportId) onMarkRecovered;
  final VoidCallback onCreateReport;
  final VoidCallback onSwitchUser;

  const MyReportsScreen({
    Key? key,
    required this.currentUser,
    required this.allReports,
    required this.onViewDetails,
    required this.onMarkRecovered,
    required this.onCreateReport,
    required this.onSwitchUser,
  }) : super(key: key);

  void _showRecoverDialog(BuildContext context, ItemReport report) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Recovery'),
        content: Text(
          'Have you safely received your "${report.itemName}"? This will update the report status to Recovered and close the case.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onMarkRecovered(report.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Item marked as Recovered! 🎉'),
                  backgroundColor: Color(0xFF15803D),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF15803D),
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes, Mark Recovered'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryTeal = Color(0xFF0F766E);

    // Filter reports created by the simulated current user
    final myReports =
        allReports.where((r) => r.ownerId == currentUser.id).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF0FDFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0FDFA),
        elevation: 0,
        title: const Text(
          'My Reports',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF115E59),
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: onSwitchUser,
            icon: const Icon(Icons.swap_horiz, size: 16, color: primaryTeal),
            label: Text(
              currentUser.name.split(' ')[0],
              style: const TextStyle(
                color: primaryTeal,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Current User Profile Banner
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: primaryTeal,
                  child: Text(
                    currentUser.name.substring(0, 1),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentUser.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      Text(
                        'Student ID: ${currentUser.studentId} • ${myReports.length} reports',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // List of User Reports or Empty State
          Expanded(
            child: myReports.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFCCFBF1),
                            ),
                            child: const Icon(Icons.folder_open,
                                size: 40, color: primaryTeal),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No reports created yet',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'You have not submitted any lost or found items under ${currentUser.name}.',
                            style: const TextStyle(
                                fontSize: 13, color: Color(0xFF6B7280)),
                            textAlign: TextAlign.Center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: onCreateReport,
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Create a Report'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryTeal,
                              foregroundColor: Colors.white,
                              shape: RoundedCornerShape(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: myReports.length,
                    itemBuilder: (context, index) {
                      final item = myReports[index];
                      final isFinderFound = item.status == 'Finder Found';
                      final isRecovered = item.status == 'Recovered';

                      return Card(
                        shape: RoundedCornerShape(16),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Row: Item Name & Status
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.itemName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isRecovered
                                          ? const Color(0xFFDCFCE7)
                                          : isFinderFound
                                              ? const Color(0xFFDBEAFE)
                                              : const Color(0xFFFEF3C7),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      item.status,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: isRecovered
                                            ? const Color(0xFF166534)
                                            : isFinderFound
                                                ? const Color(0xFF1E40AF)
                                                : const Color(0xFF92400E),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 6),
                              Text(
                                '${item.type} on ${item.date} • ${item.location}',
                                style: const TextStyle(
                                    fontSize: 12, color: Color(0xFF6B7280)),
                              ),

                              // Highlight if Finder submitted details
                              if (isFinderFound) ...[
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDBEAFE),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(Icons.handshake,
                                              size: 16,
                                              color: Color(0xFF1E40AF)),
                                          SizedBox(width: 6),
                                          Text(
                                            'Someone found your item!',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1E40AF),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Finder: ${item.finderName ?? 'Student'} (${item.finderPhone ?? 'Contact hidden'})',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF1F2937)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              const SizedBox(height: 12),

                              // Actions
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => onViewDetails(item),
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedCornerShape(10),
                                      ),
                                      child: const Text('View Details',
                                          style: TextStyle(fontSize: 12)),
                                    ),
                                  ),
                                  // Owner can mark as recovered only when finder details exist and not already recovered
                                  if (isFinderFound && !isRecovered) ...[
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () => _showRecoverDialog(
                                            context, item),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF15803D),
                                          foregroundColor: Colors.white,
                                          shape: RoundedCornerShape(10),
                                        ),
                                        child: const Text(
                                          'Mark Recovered',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
