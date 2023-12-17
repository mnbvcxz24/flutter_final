import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdateAccountEmail extends StatefulWidget {
  const UpdateAccountEmail({super.key});

  @override
  State<UpdateAccountEmail> createState() => _UpdateAccountEmailState();
}

class _UpdateAccountEmailState extends State<UpdateAccountEmail> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  late TextEditingController _accountEmailController;

  @override
  void initState() {
    super.initState();
    _accountEmailController = TextEditingController();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Email')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _accountEmailController,
              decoration: const InputDecoration(labelText: 'Account Email'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
              onPressed: _updateEmail,
              child: const Text('Update Account Email'),
            ),
          ],
        ),
      ),
    );
  }

  Future _loadUserData() async {
    try {
      String userId = _firebaseAuth.currentUser?.uid ?? '';
      DocumentSnapshot userSnapshot =
          await _firebaseFirestore.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        _accountEmailController.text = userData['email'] ?? '';
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future _updateEmail() async {
    try {
      String userId = _firebaseAuth.currentUser?.uid ?? '';
      await _firebaseFirestore.collection('users').doc(userId).update({
        'email': _accountEmailController.text,
      });

      await _firebaseAuth.currentUser?.updateEmail(
        _accountEmailController.text,
      );

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email updated successfully')),
      );
    } catch (e) {
      print('Error updating emai: $e');
    }
  }
}
