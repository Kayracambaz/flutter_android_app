import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

bool isEditing = false;

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final dbRef = FirebaseDatabase.instance.ref().child('users');
  final storageRef = FirebaseStorage.instance.ref();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  String? photoUrl;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final snapshot = await dbRef.child(user.uid).get();

    if (snapshot.exists) {
      final data = snapshot.value as Map;
      nameController.text = data['name'] ?? '';
      bioController.text = data['bio'] ?? '';
      photoUrl = data['photoUrl'];
      setState(() {});
    }
  }

  Future<void> _saveProfile() async {
    await dbRef.child(user.uid).update({
      'name': nameController.text.trim(),
      'bio': bioController.text.trim(),
      'photoUrl': photoUrl ?? '',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile saved successfully!')),
    );
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final file = File(picked.path);
    final ref = storageRef.child('profile_pictures/${user.uid}.jpg');
    await ref.putFile(file);
    final url = await ref.getDownloadURL();

    setState(() {
      photoUrl = url;
    });

    await dbRef.child(user.uid).update({'photoUrl': url});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile"), actions: [
        IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              if (isEditing) {
                _saveProfile();
              }
              setState(() {
                isEditing = !isEditing;
              });
            })
      ]),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: isEditing ? _pickImage : null,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                      photoUrl != null ? NetworkImage(photoUrl!) : null,
                  child: photoUrl == null
                      ? Icon(Icons.camera_alt, size: 40, color: Colors.white)
                      : null,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Your Name"),
                enabled: isEditing,
              ),
              TextField(
                controller: bioController,
                decoration: InputDecoration(labelText: "About You"),
                enabled: isEditing,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
