import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_7_camera_2/pages/sample_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  XFile? mPhoto; // dart:io import // late 키워드 : This means that you promise that the variables will be initialized before anything attempts to use them. -> null 에러 X
  
  
  void onPhoto(ImageSource source) async{
    //await 키워드 때문에 setState 안에서 호출할 수 없음
    XFile? imageFile = await ImagePicker().pickImage(source: source);
    setState(() => mPhoto = imageFile);
    print('dn');
  }

  @override
  Widget build(BuildContext context) {
    Widget photo =  mPhoto == null
    ?Text('Empty')
    : Image.file(File(mPhoto!.path));
    return Scaffold(
      appBar: AppBar(title: Text('gallery + camera')),
      body: SafeArea(child: Column(
        children: [
          Expanded(child: Center(child: photo)),// 가운데에 출력
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed:()=> onPhoto(ImageSource.gallery), 
                child: Text('Gallery'),
              ),
              ElevatedButton(
                onPressed:()=> onPhoto(ImageSource.camera), 
                child: Text('Camera')
              ),
              ElevatedButton(
                onPressed:() {
                  Navigator./*push(
                    context, 
                    new MaterialPageRoute(
                      builder: (context) => new SampleScreen(),
                      )
                    );*/
                    pushNamed(context, '/sample');
                }, 
                child: Text('sampleScreen')
                ),
            ],
          )
        ],
      )),
    );
  }

  
}