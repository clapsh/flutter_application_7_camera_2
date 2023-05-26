import 'package:flutter/material.dart';
import 'package:flutter_application_7_camera_2/pages/camera.dart';
import 'package:flutter_application_7_camera_2/pages/sample_screen.dart';
void main() => runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/':(context) => Camera(),
    '/sample' :(context) => SampleScreen(),
  },
));
