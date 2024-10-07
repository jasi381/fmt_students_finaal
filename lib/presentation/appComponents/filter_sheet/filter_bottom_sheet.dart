import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final Map<String, bool> _expandedSections = {
    'Categories': false,
    'Price': false,
    'Level': false,
  };

  final Map<String, bool> _expandedCategories = {
    'Development': false,
    'Web Development': false,
    'Data Science': false,
  };

  String _selectedCategory = '';
  String _selectedSubCategory = '';
  String _selectedPrice = 'All Price';
  String _selectedLevel = 'All';

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        _buildHeader(),
        _buildExpandableSection(
          'Categories',
          _buildCategorySection(),
        ),
        _buildExpandableSection(
          'Price',
          _buildPriceSection(),
        ),
        _buildExpandableSection(
          'Level',
          _buildLevelSection(),
        ),
        _buildActions(),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric( horizontal: 16),
          child: Text(
            'Filters',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 10,),
        Container(width: double.infinity,height: .6,color: Colors.black26,),

      ],
    );
  }

  Widget _buildExpandableSection(String sectionTitle, Widget child) {
    bool isExpanded = _expandedSections[sectionTitle] ?? false;
    return ExpansionTile(
      title: Text(
        sectionTitle,
        style:  GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      trailing: Icon(
        isExpanded ? Icons.expand_less : Icons.expand_more,
        color: Colors.grey,
      ),
      onExpansionChanged: (bool expanding) {
        setState(() {
          _expandedSections[sectionTitle] = expanding;
        });
      },
      children: [child],
    );
  }

  Widget _buildCategorySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExpandableCategory(
            'Development',
            ['All Development', 'Web Development', 'Data Science'],
          ),
          _buildExpandableCategory(
            'Web Development',
            ['Frontend', 'Backend', 'Fullstack'],
          ),
          _buildExpandableCategory(
            'Data Science',
            ['Machine Learning', 'Data Analysis', 'Deep Learning'],
          ),
        ],
      ),
    );
  }
  Widget _buildExpandableCategory(String category, List<String> subCategories) {
    bool isExpanded = _expandedCategories[category] ?? false;
    return ExpansionTile(

      title: Text(category, style: GoogleFonts.roboto(fontSize: 18)),
      trailing: Icon(
        isExpanded ? Icons.expand_less : Icons.expand_more,
        color: Colors.grey,
      ),
      onExpansionChanged: (bool expanding) {
        setState(() {
          _expandedCategories[category] = expanding;
        });
      },
      children: subCategories
          .map((subCategory) => GestureDetector(
        onTap: () {
          setState(() {
            _selectedSubCategory = subCategory; // Corrected here
            _selectedCategory = category;
          });
        },
        child: ListTile(
          title: Text(subCategory, style: GoogleFonts.roboto()),
          leading: Radio<String>(
            value: subCategory,
            groupValue: _selectedSubCategory,
            onChanged: (String? value) {
              setState(() {
                _selectedSubCategory = value!;
                _selectedCategory = category;
              });
            },
          ),
        ),
      ))
          .toList(),
    );
  }



  Widget _buildPriceSection() {
    return _buildSection(
      options: ['All Price', 'Free', 'Paid'],
      selectedOption: _selectedPrice,
      onSelect: (value) {
        setState(() {
          _selectedPrice = value;
        });
      },
    );
  }

  Widget _buildLevelSection() {
    return _buildSection(
      options: ['All', 'Beginner', 'Intermediate', 'Advanced'],
      selectedOption: _selectedLevel,
      onSelect: (value) {
        setState(() {
          _selectedLevel = value;
        });
      },
    );
  }

  Widget _buildSection({required List<String> options, required String selectedOption, required ValueChanged<String> onSelect}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: options.map((option) => _buildOption(option, selectedOption, onSelect)).toList(),
      ),
    );
  }

  Widget _buildOption(String title, String selectedOption, ValueChanged<String> onSelect) {
    bool isSelected = selectedOption == title;
    return InkWell(
      onTap: () => onSelect(title),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 18)),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? Colors.green : Colors.grey, width: 2),
              ),
              child: isSelected
                  ? Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                ),
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: TextButton(
              onPressed: () {
                setState(() {
                  _selectedCategory = '';
                  _selectedSubCategory = '';
                  _selectedPrice = 'All Price';
                  _selectedLevel = 'All';
                  _expandedSections.updateAll((key, value) => false);
                  _expandedCategories.updateAll((key, value) => false);
                });
              },
              child: const Text(
                'Clear all',
                style: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Apply',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




