import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final/pages/profile_page.dart';
import 'package:flutter_final/utils.dart';
import 'package:image_picker/image_picker.dart';

class SlidingMenu extends StatefulWidget {
  const SlidingMenu({super.key});

  @override
  State<SlidingMenu> createState() => _SlidingMenuState();
}

class _SlidingMenuState extends State<SlidingMenu> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  String? imageUrl;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);

    imageUrl = await uploadImageToFirebaseStorage(img);

    if (imageUrl != null) {
      String userId = _firebaseAuth.currentUser?.uid ?? '';
      await _firebaseFirestore.collection("users").doc(userId).update({
        'profileImageUrl': imageUrl,
      });
    } else {
      print("Error");
    }
  }

  Future<String?> uploadImageToFirebaseStorage(Uint8List imageBytes) async {
    try {
      String userId = _firebaseAuth.currentUser?.uid ?? '';
      String fileName = 'profile_pictures/profile_picture_$userId.jpg';
      Reference storageReference = _firebaseStorage.ref().child(fileName);

      UploadTask uploadTask = storageReference.putData(imageBytes);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.green,
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50.0,
                      backgroundColor: const Color.fromRGBO(174, 248, 195, 1),
                      backgroundImage: NetworkImage(
                        imageUrl ??
                            'https://cdn.icon-icons.com/icons2/1812/PNG/512/4213460-account-avatar-head-person-profile-user_115386.png',
                      ),
                    ),
                    Positioned(
                      bottom: -10,
                      left: 70,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.photo_camera),
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  _firebaseAuth.currentUser!.displayName.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Profile Details'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileDetails()));
            },
          ),
          ListTile(
            title: const Text('Change Password'),
            onTap: () {
              // Handle item 2 tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title: const Text('Log out'),
            onTap: () {
              FirebaseAuth.instance.signOut(); // Close the drawer
            },
          ),
          // Add more list items as needed
        ],
      ),
    );
  }
}
