import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchForUser extends StatefulWidget {
  const SearchForUser({Key? key}) : super(key: key);

  @override
  _SearchForUserState createState() => _SearchForUserState();
}

class _SearchForUserState extends State<SearchForUser> {
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  DocumentSnapshot? _userSnapshot;
  String? _errorMessage;

  // Function to search the user by name
  Future<void> _searchUser() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String searchName = _searchController.text.trim();

    if (searchName.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Please enter a name to search.';
      });
      return;
    }

    try {
      // Query Firestore to get the user data
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('name', isEqualTo: searchName)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // If a user is found, show their data
        setState(() {
          _isLoading = false;
          _userSnapshot = snapshot.docs.first;
          _errorMessage = null;
        });
      } else {
        // If no user is found
        setState(() {
          _isLoading = false;
          _errorMessage = 'No user found with that name.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search User'),
        backgroundColor: Colors.black, // Optional, you can change app bar color here
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar with white background and black text
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Enter User Name',
                filled: true, // Ensure background is filled
                fillColor: Colors.white, // Set the background to white
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.black), // Label color
              ),
              style: TextStyle(color: Colors.black), // Text color inside the search bar
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _searchUser,
              child: const Text('Search'),
            ),
            const SizedBox(height: 20),
            // Loading indicator
            if (_isLoading) const CircularProgressIndicator(),
            // Error or success message
            if (_errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            // Display user info if found
            if (_userSnapshot != null) ...[
              const SizedBox(height: 20),
              Text(
                'User Info:',
              ),
              const SizedBox(height: 10),
              Text(
                'Name: ${_userSnapshot!['name']}',
                style: TextStyle(color: Colors.white), // Change result text to white
              ),
              Text(
                'UID: ${_userSnapshot!.id}',
                style: TextStyle(color: Colors.white), // Change result text to white
              ),
              // Add other fields here, such as the profile picture, etc.
            ],
          ],
        ),
      ),
      backgroundColor: Colors.black, // Set the background color of the entire screen
    );
  }
}

