// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final/authenticator.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({Key? key}) : super(key: key);

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late TextEditingController _confirmDeleteController;

  @override
  void initState() {
    super.initState();
    _confirmDeleteController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Deletion')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _confirmDeleteController,
              decoration:
                  const InputDecoration(labelText: "Type 'DELETE' to confirm."),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                var currentContext = context;
                _deleteAccount(currentContext);
              },
              child: const Text('DELETE ACCOUNT'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    try {
      final String confirmationText = _confirmDeleteController.text.trim();
      if (confirmationText == 'DELETE') {
        // Get the current user
        final user = _firebaseAuth.currentUser;
        // Delete the user account
        await user?.delete();

        if (user != null) {
          final String userId = user.uid;
          // Delete user data from Firestore
          final CollectionReference usersCollection =
              FirebaseFirestore.instance.collection('users');
          final DocumentReference userDoc = usersCollection.doc(userId);

          await userDoc.delete();
        }

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deleted successfully')),
        );
        // Navigate to the authenticator screen and replace the current screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Authenticator()),
        );
      } else {
        // Show an error message if the confirmation text is incorrect
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incorrect confirmation text')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting account')),
      );
    }
  }
}
