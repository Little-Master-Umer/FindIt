import 'package:flutter/material.dart';
import '../models/item_report.dart';
import '../data/sample_reports.dart';

/// Screen 4: Create Report (Reusable form with Form validation)
class ReportScreen extends StatefulWidget {
  final String initialType; // 'Lost' or 'Found'
  final StudentUser currentUser;
  final Function(ItemReport newReport) onReportCreated;

  const ReportScreen({
    super.key,
    this.initialType = 'Lost',
    required this.currentUser,
    required this.onReportCreated,
  });

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _reportType;
  late String _selectedCategory;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> _categories = [
    'Electronics',
    'Cards',
    'Accessories',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _reportType = widget.initialType;
    _selectedCategory = 'Electronics';
    _dateController.text = 'Oct 28, 2026';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // Demonstrate Form validation in Flutter
    if (_formKey.currentState!.validate()) {
      // Generate simple unique ID
      final uniqueId = 'REP-${DateTime.now().millisecondsSinceEpoch % 10000}';

      final newReport = ItemReport(
        id: uniqueId,
        itemName: _nameController.text.trim(),
        type: _reportType,
        category: _selectedCategory,
        location: _locationController.text.trim(),
        date: _dateController.text.trim(),
        description: _descriptionController.text.trim(),
        ownerId: widget.currentUser.id,
        ownerName: widget.currentUser.name,
        status: 'Active',
      );

      // Add to shared in-memory list
      widget.onReportCreated(newReport);

      // Show confirmation SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${_reportType == 'Lost' ? 'Lost' : 'Found'} report created successfully!'),
          backgroundColor: const Color(0xFF0F766E),
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Return to previous screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryTeal = Color(0xFF0F766E);

    return Scaffold(
      backgroundColor: const Color(0xFFF0FDFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0FDFA),
        elevation: 0,
        title: Text(
          _reportType == 'Lost' ? 'Report Lost Item' : 'Report Found Item',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF115E59),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Submitting Banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFCCFBF1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person, size: 18, color: primaryTeal),
                    const SizedBox(width: 8),
                    Text(
                      'Reporting as: ${widget.currentUser.name} (${widget.currentUser.studentId})',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF115E59),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Report Type Selector
              const Text(
                'Report Type',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('Lost Item')),
                      selected: _reportType == 'Lost',
                      selectedColor: const Color(0xFFFEE2E2),
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: _reportType == 'Lost'
                            ? const Color(0xFF991B1B)
                            : const Color(0xFF4B5563),
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _reportType = 'Lost');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('Found Item')),
                      selected: _reportType == 'Found',
                      selectedColor: const Color(0xFFCCFBF1),
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: _reportType == 'Found'
                            ? const Color(0xFF115E59)
                            : const Color(0xFF4B5563),
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _reportType = 'Found');
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Item Name
              const Text(
                'Item Name *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('e.g. Leather Wallet, Student ID'),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter the item name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Category Dropdown
              const Text(
                'Category *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: _inputDecoration('Select category'),
                items: _categories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedCategory = val);
                  }
                },
              ),

              const SizedBox(height: 16),

              // Campus Location
              const Text(
                'Campus Location *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _locationController,
                decoration:
                    _inputDecoration('e.g. Central Library 2nd Floor, Desk 14'),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter where the item was lost or found';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Date
              const Text(
                'Date *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _dateController,
                decoration: _inputDecoration('e.g. Oct 28, 2026'),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter date';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Description
              const Text(
                'Description *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: _inputDecoration(
                    'Color, distinct markings, brand, contents...'),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  if (val.trim().length < 8) {
                    return 'Description must be at least 8 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryTeal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _reportType == 'Lost'
                        ? 'Publish Lost Report'
                        : 'Publish Found Report',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF0F766E), width: 1.5),
      ),
    );
  }
}
