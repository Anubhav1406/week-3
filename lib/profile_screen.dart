import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  String _name = '';
  String _bio = '';
  String _imageUrl = '';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? '';
      _bio = prefs.getString('bio') ?? '';
      _imageUrl = prefs.getString('imageUrl') ?? '';
      _nameController.text = _name;
      _bioController.text = _bio;
      _imageUrlController.text = _imageUrl;
    });
  }

  _saveProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', _nameController.text);
    prefs.setString('bio', _bioController.text);
    prefs.setString('imageUrl', _imageUrlController.text);
    setState(() {
      _name = _nameController.text;
      _bio = _bioController.text;
      _imageUrl = _imageUrlController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _imageUrl.isNotEmpty
                  ? NetworkImage(_imageUrl)
                  : AssetImage('assets/placeholder.png') as ImageProvider,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(labelText: 'Bio'),
            ),
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(labelText: 'Profile Picture URL'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveProfileData,
              child: Text('Save'),
            ),
            SizedBox(height: 16),
            Text(
              'Welcome to your profile!',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}