import 'package:flutter/material.dart';
import 'package:only_job/services/retrieve_skills.dart';
import 'package:only_job/services/user_service.dart';
import 'package:only_job/services/auth.dart';
import 'package:only_job/views/constants/constants.dart';

class AddSkillsPage extends StatefulWidget {
  final List<String>? selectedSkills;
  AddSkillsPage({this.selectedSkills = const []});

  @override
  _AddSkillsPageState createState() => _AddSkillsPageState();
}

class _AddSkillsPageState extends State<AddSkillsPage> {
  late AuthService _auth;
  late UserService _userService;
  final TextEditingController _searchController = TextEditingController();
  late List<String> allSkills;
  List<String> filteredSkills = [];
  List<String> addedSkills = [];

  void _loadSkills() async {
    allSkills = await RetrieveSkills().retrieveSkillsFromFirestore();
  }

  @override
  void initState() {
    super.initState();
    _auth = AuthService();
    _userService = UserService(uid: _auth.getCurrentUserId()!);
    _loadSkills();
    addedSkills = widget.selectedSkills ?? [];
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
    _userService.removeSkill(skill); // Remove skill from profile
    setState(() {
      addedSkills.remove(skill);
    });
  }

  void _saveSkills() async {
    for (String skill in addedSkills) {
      await UserService(uid: _auth.getCurrentUserId()!)
          .addSkills(skill); // Add selected skills to profile
    }

    Navigator.pop(
        context, addedSkills); // Return the selected skills to profile
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundwhite,
      appBar: AppBar(
        title: Text('Add Skills'),
        backgroundColor: Colors.transparent,
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
                _filterSkills(value);
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
                    label: Text(
                      skill,
                      style: const TextStyle(
                        color: backgroundblack,
                      ),
                    ),
                    backgroundColor: backgroundwhite,
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
