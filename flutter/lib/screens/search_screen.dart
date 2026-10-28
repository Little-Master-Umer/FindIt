import 'package:flutter/material.dart';
import '../models/item_report.dart';
import '../widgets/item_card.dart';

/// Screen 3: Search Screen with case-insensitive search and type/category filters
class SearchScreen extends StatefulWidget {
  final List<ItemReport> reports;
  final String? initialCategory;
  final Function(ItemReport) onItemTap;

  const SearchScreen({
    Key? key,
    required this.reports,
    this.initialCategory,
    required this.onItemTap,
  }) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Demonstration of TextEditingController
  late final TextEditingController _searchController;
  String _searchQuery = '';
  String _selectedType = 'All'; // 'All', 'Lost', 'Found'
  late String _selectedCategory; // 'All', 'Electronics', 'Cards', etc.

  final List<String> _categories = [
    'All',
    'Electronics',
    'Cards',
    'Accessories',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _selectedCategory = widget.initialCategory ?? 'All';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filtered reports list using Dart where() and case-insensitive contains()
  List<ItemReport> get _filteredReports {
    return widget.reports.where((report) {
      // Type filter
      final matchesType =
          _selectedType == 'All' || report.type == _selectedType;

      // Category filter
      final matchesCategory =
          _selectedCategory == 'All' || report.category == _selectedCategory;

      // Case-insensitive text search
      final query = _searchQuery.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          report.itemName.toLowerCase().contains(query) ||
          report.location.toLowerCase().contains(query) ||
          report.description.toLowerCase().contains(query);

      return matchesType && matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    const primaryTeal = Color(0xFF0F766E);
    final results = _filteredReports;

    return Scaffold(
      backgroundColor: const Color(0xFFF0FDFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0FDFA),
        elevation: 0,
        title: const Text(
          'Search & Filter',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF115E59),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Input Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                // Demonstrate setState() for instant UI refresh
                setState(() {
                  _searchQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by item name or location...',
                hintStyle:
                    const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: primaryTeal),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon:
                            const Icon(Icons.clear, color: Color(0xFF9CA3AF)),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
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
                  borderSide: const BorderSide(color: primaryTeal, width: 1.5),
                ),
              ),
            ),
          ),

          // Type Filters Row: All, Lost, Found
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: ['All', 'Lost', 'Found'].map((type) {
                final isSelected = _selectedType == type;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(type == 'All' ? 'All Types' : '$type Items'),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedType = type;
                        });
                      }
                    },
                    selectedColor: primaryTeal,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.white : const Color(0xFF4B5563),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Category Filters Horizontal Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(cat == 'All' ? 'All Categories' : cat),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                    selectedColor: const Color(0xFF115E59),
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : const Color(0xFF4B5563),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Results summary counter
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            child: Row(
              children: [
                Text(
                  'Found ${results.length} matching report${results.length == 1 ? '' : 's'}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),

          // Results List or Empty State
          Expanded(
            child: results.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFCCFBF1),
                          ),
                          child: const Icon(Icons.search_off,
                              size: 40, color: primaryTeal),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No items found',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Try different search terms or clear your filters.',
                          style:
                              TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final item = results[index];
                      return ItemCard(
                        report: item,
                        onTap: () => widget.onItemTap(item),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
