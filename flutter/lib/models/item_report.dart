/// Data model representing a Lost or Found item report on campus.
class ItemReport {
  final String id;
  final String itemName;
  final String type; // 'Lost' or 'Found'
  final String category; // 'Electronics', 'Cards', 'Accessories', 'Other'
  final String location;
  final String date;
  final String description;
  final String ownerId;
  final String ownerName;

  // Status can be: 'Active', 'Finder Found', or 'Recovered'
  String status;

  // Nullable finder fields attached when someone reports finding the lost item
  String? finderName;
  String? finderPhone;
  String? foundLocation;
  String? finderMessage;

  ItemReport({
    required this.id,
    required this.itemName,
    required this.type,
    required this.category,
    required this.location,
    required this.date,
    required this.description,
    required this.ownerId,
    required this.ownerName,
    this.status = 'Active',
    this.finderName,
    this.finderPhone,
    this.foundLocation,
    this.finderMessage,
  });

  /// Check whether finder details are attached
  bool get hasFinderDetails =>
      finderName != null && finderName!.trim().isNotEmpty;
}
