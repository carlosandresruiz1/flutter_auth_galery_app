import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  final AuthService _auth = AuthService();

  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<XFile>? _imageFiles;

  void openCamera(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFiles = [pickedFile];
      });
      print('Image picked: ${pickedFile.path}');
    } else {
      print('No image selected.');
    }
  }

  void openGallery(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _imageFiles = pickedFiles;
      });
      print('Images picked: ${pickedFiles.map((file) => file.path).join(', ')}');
    } else {
      print('No images selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(

      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person),
            label: Text('Logout'),
            onPressed: () async {
              await widget._auth.signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
        
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            user != null ? Text('Hello, ${user.email}') : Text('No user logged in'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => openCamera(context),
                  child: Text('Open Camera'),
                ),
                ElevatedButton(
                  onPressed: () => openGallery(context),
                  child: Text('Open Gallery'),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (_imageFiles != null && _imageFiles!.isNotEmpty)
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                  ),
                  itemCount: _imageFiles!.length,
                  itemBuilder: (context, index) {
                    return Image.file(
                      File(_imageFiles![index].path),
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
