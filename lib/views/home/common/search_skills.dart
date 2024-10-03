import 'package:flutter/material.dart';
import 'dart:developer';

class SearchSkills extends SearchDelegate<String>{
  SearchSkills({required this.skills, required this.addSkills});
  List<String> skills;
  Function addSkills;
  
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }
  
  @override
  Widget buildResults(BuildContext context) {
    final results = skills.where((skill) => skill.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]),
          onTap: () {
            close(context, results[index]);
          },
        );
      },
    );
  }
  
  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = skills.where((skill) => skill.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            query = suggestions[index];
            showResults(context);
            addSkills(query);
            close(context, query);
          },
        );
      },
    );
  }
}
