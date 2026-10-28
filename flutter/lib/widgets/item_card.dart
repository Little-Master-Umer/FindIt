import 'package:flutter/material.dart';
import '../models/item_report.dart';

/// Reusable StatelessWidget displaying an ItemReport card
class ItemCard extends StatelessWidget {
  final ItemReport report;
  final VoidCallback onTap;

  const ItemCard({
    super.key,
    required this.report,
    required this.onTap,
  });

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
    final isLost = report.type == 'Lost';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Type & Status tags
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
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
                            horizontal: 8, vertical: 4),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusBg(report.status),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getStatusText(report.status).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      report.status,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _getStatusText(report.status),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Title
              Text(
                report.itemName,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Description
              Text(
                report.description,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF4B5563),
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),

              // Metadata: Location and Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 14, color: Color(0xFF0F766E)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            report.location,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 12, color: Color(0xFF9CA3AF)),
                      const SizedBox(width: 4),
                      Text(
                        report.date,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Finder notification banner if finder found
              if (report.status == 'Finder Found' && report.finderName != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBEAFE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.handshake,
                          size: 14, color: Color(0xFF1E40AF)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Found by ${report.finderName} — tap for details',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E40AF),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
