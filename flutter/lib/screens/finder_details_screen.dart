import 'package:flutter/material.dart';
import '../models/item_report.dart';
import '../data/sample_reports.dart';

/// Screen 6: Finder Details Screen for submitting finder contact and recovery info
class FinderDetailsScreen extends StatefulWidget {
  final ItemReport report;
  final StudentUser currentUser;
  final Function(String reportId, String finderName, String finderPhone,
      String foundLocation, String message) onSubmitFinder;

  const FinderDetailsScreen({
    super.key,
    required this.report,
    required this.currentUser,
    required this.onSubmitFinder,
  });

  @override
  _FinderDetailsScreenState createState() => _FinderDetailsScreenState();
}

class _FinderDetailsScreenState extends State<FinderDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-populate with current student profile info (e.g. Ahmed)
    _nameController = TextEditingController(text: widget.currentUser.name);
    _phoneController = TextEditingController(text: widget.currentUser.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmitFinder(
        widget.report.id,
        _nameController.text.trim(),
        _phoneController.text.trim(),
        _locationController.text.trim(),
        _messageController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Finder details submitted! ${widget.report.ownerName} has been notified.'),
          backgroundColor: const Color(0xFF0F766E),
          behavior: SnackBarBehavior.floating,
        ),
      );

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
        title: const Text(
          'I Found This Item',
          style: TextStyle(
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
              // Summary card of the item found
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCCFBF1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.handshake,
                            color: primaryTeal, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Lost Item:',
                              style: TextStyle(
                                  fontSize: 11, color: Color(0xFF9CA3AF)),
                            ),
                            Text(
                              widget.report.itemName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            Text(
                              'Owner: ${widget.report.ownerName}',
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xFF6B7280)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info, size: 18, color: Color(0xFF1E40AF)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Submitting this form changes the status to "Finder Found". The owner will contact you and mark it as Recovered once received.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF1E40AF),
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Finder Name
              const Text(
                'Your Name *',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937)),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('e.g. Ahmed Raza'),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Phone Number
              const Text(
                'Phone Number *',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937)),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration('e.g. +92 321 7654321'),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter contact phone number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Where did you find / keep it
              const Text(
                'Where is the item currently? *',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937)),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _locationController,
                decoration: _inputDecoration(
                    'e.g. Handed to Library Reception, or With me in Block B'),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please specify where the item can be collected';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Optional Message
              const Text(
                'Message for the Owner (Optional)',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937)),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _messageController,
                maxLines: 3,
                decoration: _inputDecoration(
                    'e.g. You can pick it up with your student card.'),
              ),

              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.send),
                  label: const Text(
                    'Submit Finder Details',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryTeal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
