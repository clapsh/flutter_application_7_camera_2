import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:developer';
import 'album.dart';
import 'grid_photo.dart';
class SampleScreen extends StatefulWidget {
  const SampleScreen({super.key});

  @override
  State<SampleScreen> createState() => _SampleScreenState();
}

class _SampleScreenState extends State<SampleScreen> {
  List<AssetPathEntity>? _paths; // 모든 파일 경로 photh manager가 지원 -> 전체 앨범 목록을 반환 
  List<Album> _albums = []; // 드롭다운 앨범 목록 (앨범 분류에 따라)
  late List<AssetEntity> _images; // 앨범의 이미지 목록
  int _currentPage = 0; //현재 페이지
  late Album _currentAlbum; // 드롭다운에서 선택된 앨범 

  Future<void> checkPermission() async { //접근 권한 확인 
    final PermissionState ps = await PhotoManager.requestPermissionExtend(); //권한 확인 
    if(ps.isAuth){ // 수락이 된 경우 
      print('permitted');
      await getAlbum();
    }else{
      await PhotoManager.openSetting(); //권한 설정 페이지 이동 
    }
  }

  Future<void> getAlbum() async{
    _paths = await PhotoManager.getAssetPathList( // 모든 파일의 정보를 불러옴 -> 드롭다운에 사용될 앨범의 목록을 만들어줌 
      type: RequestType.image,
    );

    _albums = _paths!.map((e) {
        return Album(
          id: e.id, 
          name: e.isAll? '모든 사진' : e.name
        );
    }).toList();

    await getPhotos(_albums[0], albumChange: true);
  }

  /**
   * 앨범 이미지 목록을 불러오는 함수 
   * -> 사용 : 
   * 이 페이지에 처음 진입한 경우, 
   * 드롭다운으로 다른 앨범을 선택한 경우
   * 스크롤이 끝난 경우
   */
  ///
  
  Future<void> getPhotos(Album album, {bool albumChange = false}) async{
      _currentAlbum = album;
      albumChange? _currentPage = 0 : _currentPage++;

      // assetPathEntity의 id 값을 통해 이미지 목록을 불러옴 
      final loadImages = await _paths! 
        .singleWhere((e) => e.id == album.id)
        .getAssetListPaged(page: _currentPage, size: 10);

      setState(() {
        if (albumChange){ // 드롭다운 앨범 변경 
          _images = loadImages;
        }else {
          _images.addAll(loadImages); 
        }
      });
  }
  @override
  void initSate(){
    super.initState();
    log('init');
    checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: _albums.isNotEmpty// album이 비어있지 않으면 드롭다운 버튼 생성 
            ?DropdownButton(
              value: _currentAlbum,
              items: _albums.map((e)=>DropdownMenuItem(
                value:e,
                child: Text(e.name))).toList(), 
                onChanged: (value)=> getPhotos(value!, albumChange: true),
            ) 
            : const SizedBox() // 메뉴를 변경할때마다 onchange 호출, getPHotos호출
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scroll){ 
          // 스크롤의 현재위치                               // 스크롤 끝 위치
          final scrollPixels = scroll.metrics.pixels / scroll.metrics.maxScrollExtent;
          if (scrollPixels > 0.7){
            getPhotos(_currentAlbum);
          }
          return false;
        },
        child: SafeArea(
          child: _paths == null
            ? const Center(child: CircularProgressIndicator())
            : GridPhoto(images: _images)))
    );
  }
}