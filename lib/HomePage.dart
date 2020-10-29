import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _image;
  final picker = ImagePicker();
  String url;
  var isUploaded = true;

  //Pick image
  Future getImage() async {
    isUploaded = false;
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        uploadFileFromDio(_image);
      } else {
        print('No image selected.');
      }
    });
  }

  uploadFileFromDio(File photoFile) async {
    var dio = new Dio();
    dio.options.connectTimeout = 50000;
    dio.options.receiveTimeout = 50000;
    String fileName = photoFile.path.split("/").last;

    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(photoFile.path, filename: fileName)
    });
    var response = await dio.post(
        "http://arnabbhadra29.pythonanywhere.com/demoImageUpload",
        data: formData,
        options: Options(method: 'POST', responseType: ResponseType.json));
    String data = response.data["image"];

    setState(() {
      url = data;
      isUploaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(bottom: 16.0),
                child: url == null
                    ? Text('No image selected.')
                    : Image.network(url)),
            Container(
              child:
                  !isUploaded ? CircularProgressIndicator() : Icon(Icons.done),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
