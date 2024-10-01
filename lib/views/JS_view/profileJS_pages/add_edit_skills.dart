import 'package:flutter/material.dart';

class AddSkillsPage extends StatefulWidget {
  final List<String>? selectedSkills;

  AddSkillsPage({this.selectedSkills = const []});

  @override
  _AddSkillsPageState createState() => _AddSkillsPageState();
}

class _AddSkillsPageState extends State<AddSkillsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> allSkills = [
    'Programming',
    'Project Management',
    'Data Analysis',
    'Communication',
    'Design',
    'Marketing',
    'Leadership',
    'Problem Solving',
    'Teamwork',
    'Time Management',
  ]; // Predefined list of skills
  List<String> filteredSkills = [];
  List<String> addedSkills = [];

  @override
  void initState() {
    super.initState();
    addedSkills = widget.selectedSkills ?? [];
    // Initially, no skills are visible until user starts typing
    filteredSkills = [];
  }

  void _filterSkills(String query) {
    setState(() {
      if (query.isNotEmpty) {
        // Filter skills based on input query
        filteredSkills = allSkills
            .where(
                (skill) => skill.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
      } else {
        // If search field is empty, clear the filtered list
        filteredSkills = [];
      }
    });
  }

  // Add selected skill to the list
  void _addSkill(String skill) {
    setState(() {
      if (!addedSkills.contains(skill)) {
        addedSkills.add(skill);
      }
    });
  }

  // Remove skill from the added list
  void _removeSkill(String skill) {
    setState(() {
      addedSkills.remove(skill);
    });
  }

  void _saveSkills() {
    Navigator.pop(
        context, addedSkills); // Return the selected skills to profile
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Skills'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveSkills, // Save selected skills
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Skills',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                _filterSkills(value); // Filter skills based on input
              },
            ),
            SizedBox(height: 16),

            // List of Filtered Skills with Add Button
            if (filteredSkills.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: filteredSkills.length,
                  itemBuilder: (context, index) {
                    final skill = filteredSkills[index];
                    return ListTile(
                      title: Text(skill),
                      trailing: ElevatedButton(
                        onPressed: () => _addSkill(skill),
                        child: Text('Add'),
                      ),
                    );
                  },
                ),
              ),

            // Display Added Skills
            if (addedSkills.isNotEmpty) ...[
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Selected Skills:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: addedSkills.map((skill) {
                  return Chip(
                    label: Text(skill),
                    backgroundColor: Colors.blue[100],
                    deleteIcon: Icon(Icons.cancel, color: Colors.red),
                    onDeleted: () => _removeSkill(skill),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
