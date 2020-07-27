import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);
  final void Function(File pickedImage) imagePickFn;
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File pickedImageFile;
  void _pickImage() async {
    final pickedImage = await ImagePicker()
        .getImage(source: ImageSource.camera, maxWidth: 150, imageQuality: 60);
    setState(() {
      pickedImageFile = File(pickedImage.path);
    });
    widget.imagePickFn(pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          // backgroundColor: Colors.grey ,
          backgroundImage:
              pickedImageFile != null ? FileImage(pickedImageFile) : null,
        ),
        FlatButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text('Add image'),
          textColor: Colors.white,
        ),
      ],
    );
  }
}
