import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar with white background
            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.black), // text color black
              decoration: InputDecoration(
                labelText: 'Enter User Name',
                labelStyle: const TextStyle(color: Colors.black), // label color
                filled: true,
                fillColor: Colors.white, // white background
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
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
              Container(
                color: Colors.white, // Set results background to white
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(' ${_userSnapshot!['name']}'),
                    Text('UID: ${_userSnapshot!.id}'),
                    // Add other fields here, such as the profile picture, etc.
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}



