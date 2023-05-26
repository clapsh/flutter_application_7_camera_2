import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:photo_manager/photo_manager.dart';

class GridPhoto extends StatefulWidget {
   //이미지 보여줌 
  List<AssetEntity> images;

  GridPhoto({
    required this.images,
    super.key
    });

  @override
  State<GridPhoto> createState() => _GridPhotoState();
}

class _GridPhotoState extends State<GridPhoto> {
  @override
  Widget build(BuildContext context) {
    return GridView(
      physics: const BouncingScrollPhysics(),
      gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      children: 
        widget.images.map((AssetEntity e) {
          return AssetEntityImage(
            e,
            isOriginal: false,
            fit: BoxFit.cover,
          );
        }).toList(),
  
      );
  }
}