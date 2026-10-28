import 'package:flutter/material.dart';
import '../models/item_report.dart';
import '../data/sample_reports.dart';

/// Screen 5: Item Details Screen displaying complete item record and "I Found This" action
class ItemDetailsScreen extends StatelessWidget {
  final ItemReport report;
  final StudentUser currentUser;
  final Function(String reportId) onFoundThisTap;
  final Function(String reportId)? onMarkRecoveredTap;

  const ItemDetailsScreen({
    Key? key,
    required this.report,
    required this.currentUser,
    required this.onFoundThisTap,
    this.onMarkRecoveredTap,
  }) : super(key: key);

  Color _getStatusBg(String status) {
    switch (status) {
      case 'Active':
        return const Color(0xFFFEF3C7);
      case 'Finder Found':
        return const Color(0xFFDBEAFE);
      case 'Recovered':
        return const Color(0xFFDCFCE7);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  Color _getStatusText(String status) {
    switch (status) {
      case 'Active':
        return const Color(0xFF92400E);
      case 'Finder Found':
        return const Color(0xFF1E40AF);
      case 'Recovered':
        return const Color(0xFF166534);
      default:
        return const Color(0xFF374151);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryTeal = Color(0xFF0F766E);
    final isLost = report.type == 'Lost';
    final isActive = report.status == 'Active';
    final isFinderFound = report.status == 'Finder Found';
    final isRecovered = report.status == 'Recovered';
    final isOwner = report.ownerId == currentUser.id;

    return Scaffold(
      backgroundColor: const Color(0xFFF0FDFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0FDFA),
        elevation: 0,
        title: const Text(
          'Report Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF115E59),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Details Card
            Card(
              shape: RoundedCornerShape(16),
              elevation = 1,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status and Type tags
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isLost
                                    ? const Color(0xFFFEE2E2)
                                    : const Color(0xFFE0E7FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                report.type.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isLost
                                      ? const Color(0xFF991B1B)
                                      : const Color(0xFF3730A3),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                report.category,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF4B5563),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusBg(report.status),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            report.status,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _getStatusText(report.status),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Item Name
                    Text(
                      report.itemName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Report ID: ${report.id}',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF9CA3AF)),
                    ),

                    const SizedBox(height: 16),

                    // Location & Date Info Box
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 18, color: primaryTeal),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  report.location,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 16, color: primaryTeal),
                              const SizedBox(width: 8),
                              Text(
                                report.date,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF4B5563),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Description
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      report.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4B5563),
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Owner Info
                    Row(
                      children: [
                        const Icon(Icons.person,
                            size: 16, color: Color(0xFF9CA3AF)),
                        const SizedBox(width: 6),
                        Text(
                          'Reported by: ${report.ownerName} ${isOwner ? "(You)" : ""}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Finder Information Card (if available)
            if (isFinderFound || (isRecovered && report.finderName != null)) ...[
              Card(
                shape: RoundedCornerShape(16),
                color: const Color(0xFFDBEAFE),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.handshake,
                              color: Color(0xFF1E40AF), size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Finder Contact Details',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E40AF),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Found by: ${report.finderName}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      if (report.finderPhone != null)
                        Text(
                          'Contact Phone: ${report.finderPhone}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      if (report.foundLocation != null)
                        Text(
                          'Item Location: ${report.foundLocation}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      if (report.finderMessage != null &&
                          report.finderMessage!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          'Note: "${report.finderMessage}"',
                          style: const TextStyle(
                              fontSize: 12, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Recovered Banner
            if (isRecovered) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF86EFAC)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle,
                        color: Color(0xFF166534), size: 22),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'This item has been successfully recovered by its owner.',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF166534),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // "I Found This" Button: Visible ONLY for Active Lost reports!
            if (isLost && isActive) ...[
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => onFoundThisTap(report.id),
                  icon: const Icon(Icons.handshake),
                  label: const Text(
                    'I Found This!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryTeal,
                    foregroundColor: Colors.white,
                    shape: RoundedCornerShape(12),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (isOwner)
                const Text(
                  '💡 You are the owner of this report. Switch to Ahmed in the top profile bar to test submitting finder details as another student.',
                  style: TextStyle(fontSize: 11, color: Color(0xFF0F766E)),
                ),
            ],

            // "Mark as Recovered" Button (for owner when finder details submitted)
            if (isOwner && isFinderFound && !isRecovered && onMarkRecoveredTap != null) ...[
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => onMarkRecoveredTap!(report.id),
                  icon: const Icon(Icons.check_circle),
                  label: const Text(
                    'Mark as Recovered',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF15803D),
                    foregroundColor: Colors.white,
                    shape: RoundedCornerShape(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
