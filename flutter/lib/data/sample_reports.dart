import '../models/item_report.dart';

/// Simulated campus student profiles for local testing
class StudentUser {
  final String id;
  final String name;
  final String studentId;
  final String phone;

  const StudentUser({
    required this.id,
    required this.name,
    required this.studentId,
    required this.phone,
  });
}

final List<StudentUser> sampleUsers = [
  const StudentUser(
    id: 'user_ali',
    name: 'Ali Khan',
    studentId: 'FA21-BCS-042',
    phone: '+92 300 1234567',
  ),
  const StudentUser(
    id: 'user_ahmed',
    name: 'Ahmed Raza',
    studentId: 'SP22-BSE-110',
    phone: '+92 321 7654321',
  ),
  const StudentUser(
    id: 'user_fatima',
    name: 'Fatima Noor',
    studentId: 'FA23-BEE-019',
    phone: '+92 333 9988776',
  ),
];

/// Initial sample data demonstrating the required university workflow
List<ItemReport> getInitialReports() {
  return [
    ItemReport(
      id: 'REP-1001',
      itemName: 'Brown Leather Wallet',
      type: 'Lost',
      category: 'Cards',
      location: 'Central Library, 2nd Floor Study Desk 14',
      date: 'Oct 27, 2026',
      description:
          'Dark brown leather bifold wallet with student ID, campus ATM card, and cafeteria pass. Lost during study session.',
      ownerId: 'user_ali',
      ownerName: 'Ali Khan',
      status: 'Active',
    ),
    ItemReport(
      id: 'REP-1002',
      itemName: 'University Student ID Card',
      type: 'Found',
      category: 'Cards',
      location: 'Student Center Cafeteria Counter',
      date: 'Oct 26, 2026',
      description:
          'Found near dining table 6 by the water dispenser. Cardholder name says Bilal Tariq (EE Department).',
      ownerId: 'user_ahmed',
      ownerName: 'Ahmed Raza',
      status: 'Active',
    ),
    ItemReport(
      id: 'REP-1003',
      itemName: 'AirPods Pro in Navy Case',
      type: 'Lost',
      category: 'Electronics',
      location: 'Engineering Block A, Room 104',
      date: 'Oct 25, 2026',
      description:
          'Apple AirPods Pro with dark blue silicon protective sleeve and small astronaut keychain ring. Left on desk row 3.',
      ownerId: 'user_fatima',
      ownerName: 'Fatima Noor',
      status: 'Finder Found',
      finderName: 'Ahmed Raza',
      finderPhone: '+92 321 7654321',
      foundLocation: 'Engineering Department Helpdesk',
      finderMessage:
          'Handed over to Mr. Usama at the front desk for safe keeping. You can collect it with your student ID.',
    ),
    ItemReport(
      id: 'REP-1004',
      itemName: 'Casio FX-991EX Calculator',
      type: 'Lost',
      category: 'Electronics',
      location: 'Math Building Exam Hall B',
      date: 'Oct 24, 2026',
      description:
          'Scientific calculator with silver faceplate and black slip case. Left after calculus midterm test.',
      ownerId: 'user_ali',
      ownerName: 'Ali Khan',
      status: 'Recovered',
      finderName: 'Zain Malik',
      finderPhone: '+92 345 1122334',
      foundLocation: 'Exam Control Room Desk',
      finderMessage: 'Submitted to exam staff right after test concluded.',
    ),
    ItemReport(
      id: 'REP-1005',
      itemName: 'Dorm Keys on Red Lanyard',
      type: 'Found',
      category: 'Other',
      location: 'Campus Shuttle Stop 2',
      date: 'Oct 26, 2026',
      description:
          'Set of three silver keys with a red nylon university lanyard and gym membership barcode fob.',
      ownerId: 'user_ahmed',
      ownerName: 'Ahmed Raza',
      status: 'Active',
    ),
    ItemReport(
      id: 'REP-1006',
      itemName: 'Silver Watch with Mesh Strap',
      type: 'Lost',
      category: 'Accessories',
      location: 'Sports Complex Gymnasium Lockers',
      date: 'Oct 23, 2026',
      description:
          'Minimalist analog watch with silver magnetic mesh strap. Left on the locker room bench before basketball practice.',
      ownerId: 'user_ali',
      ownerName: 'Ali Khan',
      status: 'Active',
    ),
  ];
}
