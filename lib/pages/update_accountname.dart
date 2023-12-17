import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateAccountName extends StatefulWidget {
  const UpdateAccountName({Key? key}) : super(key: key);

  @override
  State<UpdateAccountName> createState() => _UpdateAccountNameState();
}

class _UpdateAccountNameState extends State<UpdateAccountName> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  late TextEditingController _accountNameController;

  @override
  void initState() {
    super.initState();
    _accountNameController = TextEditingController();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Name')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _accountNameController,
              decoration: const InputDecoration(labelText: 'Account Name'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
              onPressed: _updateDisplayName,
              child: const Text('Update Account Name'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _accountNameController.dispose();
    super.dispose();
  }

  Future _loadUserData() async {
    try {
      String userId = _firebaseAuth.currentUser?.uid ?? '';
      DocumentSnapshot userSnapshot =
          await _firebaseFirestore.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        _accountNameController.text = userData['displayname'] ?? '';
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future _updateDisplayName() async {
    try {
      String userId = _firebaseAuth.currentUser?.uid ?? '';
      await _firebaseFirestore.collection('users').doc(userId).update({
        'displayname': _accountNameController.text,
      });

      await _firebaseAuth.currentUser?.updateDisplayName(
        _accountNameController.text,
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Display name updated successfully')),
      );
    } catch (e) {
      print('Error updating display name: $e');
    }
  }
}
