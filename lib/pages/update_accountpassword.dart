import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdateAccountPassword extends StatefulWidget {
  const UpdateAccountPassword({super.key});

  @override
  State<UpdateAccountPassword> createState() => _UpdateAccountPasswordState();
}

class _UpdateAccountPasswordState extends State<UpdateAccountPassword> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late TextEditingController _accountPassController;
  late TextEditingController _accountConfirmPassController;

  @override
  void initState() {
    super.initState();
    _accountPassController = TextEditingController();
    _accountConfirmPassController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              obscureText: true,
              controller: _accountPassController,
              decoration: const InputDecoration(labelText: 'New Password'),
            ),
            TextField(
              obscureText: true,
              controller: _accountConfirmPassController,
              decoration: const InputDecoration(labelText: 'Comfirm Password'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
              onPressed: _updatePassword,
              child: const Text('Update Account Password'),
            ),
          ],
        ),
      ),
    );
  }

  Future _updatePassword() async {
    if (_accountPassController.text != _accountConfirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Password did not match')),
      );
      return;
    }

    try {
      String? newPassword = _accountConfirmPassController.text;

      if (newPassword.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a new password')),
        );
        return;
      }

      await _firebaseAuth.currentUser?.updatePassword(newPassword);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error changing password')),
      );
    }
  }
}
