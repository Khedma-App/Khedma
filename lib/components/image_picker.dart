import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:khedma/core/constants.dart';

class ImageInput extends StatefulWidget {
  final File? image;
  final Function(File) onImagePicked;

  const ImageInput({
    super.key,
    this.image,
    required this.onImagePicked,
  }); 
  
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.image;
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      setState(() {
        _selectedImage = imageFile;
      });
      widget.onImagePicked(imageFile);
    }
  }

  void _showPickDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "اختيار صورة الملف الشخصي",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            textAlign: TextAlign.center,
          ),
          content: const Text(
            "يرجى اختيار صورة من المعرض أو التقاط صورة جديدة بالكاميرا",
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 15),
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton.icon(
                    icon: const Icon(Icons.photo_library, color: Colors.blue),
                    label: const Text("اختيار من المعرض"),
                    onPressed: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ),
                SizedBox(height: kHeight(10)),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: kHeight(14)),
                  child: TextButton.icon(
                    icon: const Icon(Icons.camera_alt, color: Colors.green),
                    label: const Text("التقاط صورة"),
                    onPressed: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPickDialog(context),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
        height: kHeight(140),
        width: kWidth(140),
        clipBehavior: Clip.antiAlias,
        child: _selectedImage == null
            ? Center(
                child: Image.asset(
                  'assets/images/pick_image.png',
                  height: kHeight(60),
                  width: kWidth(60),
                  color: Colors.black54,
                ),
              )
            : Image.file(_selectedImage!, fit: BoxFit.cover),
      ),
    );
  }
}


// //////// for input image
  // ImageInput(
  //     image: image,
  //     onImagePicked: (file) => image = file,
  // ),