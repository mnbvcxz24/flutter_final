import 'package:flutter/material.dart';
import 'package:flutter_final/pages/update_accountemail.dart';
import 'package:flutter_final/pages/update_accountname.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Details'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Column(
              children: [
                ListTile(
                  title: const Text('Account Name'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UpdateAccountName()));
                  },
                ),
                ListTile(
                  title: const Text('Account Email'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UpdateAccountEmail()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
