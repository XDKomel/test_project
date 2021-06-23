import 'dart:io';

// import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:plane_chat/shared/constants.dart' as constants;

enum GalleryType { SINGLE_CHOICE, MULTIPLE_CHOICE }
enum CropType { SQUARE, CIRCLE }

Future showGalleryModal(BuildContext context,
        {required final GalleryType galleryType,
        required final String galleryTitle,
        required final CropType cropType}) =>
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) =>
            _GalleryWidget(galleryType, galleryTitle, cropType));

class _GalleryWidget extends StatefulWidget {
  final GalleryType galleryType;
  final String galleryTitle;
  final CropType cropType;

  _GalleryWidget(this.galleryType, this.galleryTitle, this.cropType);

  @override
  _GalleryWidgetState createState() => _GalleryWidgetState();
}

class ThumbnailItem {
  final File file;
  final double? aspectRatio;
  final File? compressedFile;
  ThumbnailItem({required this.file, this.aspectRatio, this.compressedFile});
}

class _GalleryWidgetState extends State<_GalleryWidget>
    with TickerProviderStateMixin {
  List<AssetEntity> assets = [];
  List<ThumbnailItem> _chosenFiles = [];
  List<ThumbnailItem> _cachedFiles = [];
  List<AssetPathEntity> albums = [];
  double position = 20;
  double borderRadius = 12;
  double padding = 0;
  double opacity = 1.0;
  static const _pageSize = 100;

  final PagingController<int, AssetEntity> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) async {
      if (pageKey == 0) {
        albums = await PhotoManager.getAssetPathList(onlyAll: true);
      }
      await _fetchAssets(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchAssets(int pageKey) async {
    print(pageKey);
    List<AssetEntity> recentAssets = [];
    if (albums.isNotEmpty) {
      final recentAlbum = albums.first;
      recentAssets =
          await recentAlbum.getAssetListPaged(pageKey ~/ _pageSize, _pageSize);
    }
    if (pageKey == 0) {
      assets = recentAssets;
      recentAssets = [AssetEntity(id: '', typeInt: 1, height: 1, width: 1), AssetEntity(height: 1, id: '', typeInt: 1, width: 1)] + recentAssets;
    } else {
      assets = assets + recentAssets;
    }
    final isLastPage = assets.length < _pageSize;
    List<ThumbnailItem> buffer = List.filled(assets.length, ThumbnailItem(file: File('')));
    for (int i = 0; i < _cachedFiles.length; i++) {
      buffer[i] = _cachedFiles[i];
    }
    _cachedFiles = buffer;
    if (isLastPage) {
      _pagingController.appendLastPage(recentAssets);
    } else {
      final nextPageKey = pageKey + recentAssets.length;
      _pagingController.appendPage(recentAssets, nextPageKey);
    }
  }

  // Future<ThumbnailItem> getThumbnailItem({@required final AssetEntity asset}) async{
  //   File file = await asset.file;
  //   File compressedFile = await FlutterNativeImage.compressImage(file.path,
  //       quality: 40, percentage: 20);
  //   ThumbnailItem thumbnailItem = ThumbnailItem(
  //     file: file,
  //     aspectRatio: asset.width/asset.height,
  //     compressedFile: compressedFile
  //   );
  //   return thumbnailItem;
  // }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        if (notification.extent > 0.9) {
          position = 20 - (notification.extent - 0.9) * 200;
          padding = (notification.extent - 0.9) * (48) * 10;
          opacity = 1.0 - (notification.extent - 0.9) * 10;
          borderRadius = 12 - (notification.extent - 0.9) * 200;
          setState(() {});
        } else if (notification.extent < 0.9 && position != 20) {
          position = 20;
          padding = 0;
          opacity = 1.0;
          borderRadius = 12;
          setState(() {});
        }
        return false;
      },
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 1,
        builder: (BuildContext context, scrollController) => AnimatedContainer(
          //margin: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(position),
                  topLeft: Radius.circular(position)),
              color: Colors.white),
          duration: Duration(milliseconds: 100),
          child: Column(
            children: [
              AnimatedSize(
                duration: Duration(milliseconds: 100),
                vsync: this,
                child: Container(
                    //height: padding + MediaQuery.of(context).viewPadding.top + 32,
                    constraints: BoxConstraints(
                        minWidth: double.infinity,
                        minHeight: padding +
                            MediaQuery.of(context).viewPadding.top +
                            32),
                    decoration: BoxDecoration(
                      color: padding > 48 * 0.99 ? Colors.white : null,
                    ),
                    child: padding > 48 * 0.99
                        ? Card(
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(top: 24.0),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      iconSize: 24,
                                      icon: Icon(
                                        Icons.arrow_back,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24.0),
                                      child: Text(widget.galleryTitle,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : widget.galleryType == GalleryType.SINGLE_CHOICE
                            ? _buildSingleChoiceHeader(context)
                            : _buildMultipleChoiceHeader(context)),
              ),
              Expanded(
                  child: Scaffold(
                floatingActionButton: _chosenFiles.length != 0
                    ? FloatingActionButton(
                        backgroundColor: Theme.of(context).accentColor,
                        child: Icon(Icons.check),
                        onPressed: () {
                          // CoreModule.globalKey.currentState
                          //     .pop(_chosenFiles.map((e) => e.file).toList());
                        },
                      )
                    : null,
                body: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child:
                        NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (overScroll) {
                        overScroll.disallowGlow();
                        return false;
                      },
                      child: PagedGridView<int, AssetEntity>(
                        scrollController: scrollController,
                        pagingController: _pagingController,
                        //physics: const AlwaysScrollableScrollPhysics (),
                        padding: const EdgeInsets.only(bottom: 8.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          crossAxisCount: 3,
                        ),
                        builderDelegate: PagedChildBuilderDelegate<AssetEntity>(
                            itemBuilder: (context, asset, index) {
                          return index == 0
                              ? GestureDetector(
                                  onTap: () => takePhoto(widget.galleryType),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: index == 0 || index == 2
                                          ? BorderRadius.only(
                                              topRight: index == 2
                                                  ? Radius.circular(
                                                      borderRadius)
                                                  : Radius.circular(0),
                                              topLeft: index == 0
                                                  ? Radius.circular(
                                                      borderRadius)
                                                  : Radius.circular(0))
                                          : BorderRadius.all(
                                              Radius.circular(0)),
                                      color: Color.fromRGBO(236, 236, 236, 1),
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Icon(
                                            Icons.add_a_photo_outlined,
                                            size: 36,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 72, left: 16, right: 16),
                                            child: Text("take_photo".tr()),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : index == 1
                                  ? GestureDetector(
                                      onTap: () =>
                                          chooseFromGallery(widget.galleryType),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: index == 0 || index == 2
                                              ? BorderRadius.only(
                                                  topRight: index == 2
                                                      ? Radius.circular(
                                                          borderRadius)
                                                      : Radius.circular(0),
                                                  topLeft: index == 0
                                                      ? Radius.circular(
                                                          borderRadius)
                                                      : Radius.circular(0))
                                              : BorderRadius.all(
                                                  Radius.circular(0)),
                                          color:
                                              Color.fromRGBO(236, 236, 236, 1),
                                        ),
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: Icon(
                                                Icons.image,
                                                size: 36,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: 72,
                                                    left: 16,
                                                    right: 16),
                                                child: Text(
                                                  "choose_from_gallery".tr(),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : _cachedFiles[index - 2] != null
                                      ? widget.galleryType ==
                                              GalleryType.SINGLE_CHOICE
                                          ? _buildSingleChoiceItem(context,
                                              _cachedFiles[index - 2], index)
                                          : _buildMultipleChoiceItem(
                                              context,
                                              thumbnailItem:
                                                  _cachedFiles[index - 2],
                                              index: index,
                                              isChosen: _chosenFiles.contains(
                                                  _cachedFiles[index - 2]),
                                            )
                                      : FutureBuilder<File?>(
                                          future: asset.file,
                                          builder: (_, snapshot) {
                                            final file = snapshot.data;
                                            print("loading index: " +
                                                index.toString());
                                            if (file == null)
                                              return ClipRRect(
                                                clipBehavior: Clip.hardEdge,
                                                  borderRadius: index == 0 ||
                                                          index == 2
                                                      ? BorderRadius.only(
                                                          topRight: index == 2
                                                              ? Radius.circular(
                                                                  borderRadius)
                                                              : Radius.circular(
                                                                  0),
                                                          topLeft: index == 0
                                                              ? Radius.circular(
                                                                  borderRadius)
                                                              : Radius.circular(
                                                                  0))
                                                      : BorderRadius.all(
                                                          Radius.circular(0)),
                                                  child: Image(
                                                      image: AssetImage(
                                                          "assets/images/person-icon-white.png",
                                                          package: "core")));
                                            int assetIndex =
                                                assets.indexOf(asset);
                                            print("asset index : $assetIndex");
                                            ThumbnailItem thumbnailItem =
                                                ThumbnailItem(
                                                    file: file,
                                                    aspectRatio: asset.width /
                                                        asset.height);
                                            _cachedFiles[assetIndex] =
                                                thumbnailItem;
                                            return widget.galleryType ==
                                                    GalleryType.SINGLE_CHOICE
                                                ? _buildSingleChoiceItem(
                                                    context,
                                                    thumbnailItem,
                                                    index)
                                                : _buildMultipleChoiceItem(
                                                    context,
                                                    thumbnailItem:
                                                        thumbnailItem,
                                                    index: index,
                                                    isChosen: _chosenFiles
                                                        .contains(file),
                                                  );
                                          });
                        }),
                      ),
                    )),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMultipleChoiceHeader(BuildContext context) => Center(
      child: _chosenFiles.isEmpty
          ? AnimatedContainer(
              duration: Duration(milliseconds: 100),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Colors.grey[300]!.withOpacity(opacity),
              ),
              alignment: Alignment.center,
              height: 6,
              width: 50,
            )
          : Container(
              alignment: Alignment.centerLeft,
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Text(
                _chosenFiles.length == 1
                    ? "${_chosenFiles.length} photo chosen"
                    : "${_chosenFiles.length} photos chosen",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(opacity)),
              ),
            ));

  Widget _buildSingleChoiceHeader(BuildContext context) => Center(
        child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            alignment: Alignment.centerLeft,
            child: Text(
              "Choose photo",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withOpacity(opacity)),
            )),
      );

  Widget _buildSingleChoiceItem(
          BuildContext context, final ThumbnailItem thumbnailItem, int index) =>
      GestureDetector(
        onTap: () =>
            openCropper(widget.galleryType, thumbnailItem, widget.cropType),
        child: ClipRRect(
          borderRadius: index == 0 || index == 2
              ? BorderRadius.only(
                  topRight: index == 2
                      ? Radius.circular(borderRadius)
                      : Radius.circular(0),
                  topLeft: index == 0
                      ? Radius.circular(borderRadius)
                      : Radius.circular(0))
              : BorderRadius.all(Radius.circular(0)),
          child: FadeInImage(
            fadeInDuration: Duration(milliseconds: 200),
            fadeOutDuration: Duration(milliseconds: 200),
            image: ResizeImage(FileImage(thumbnailItem.file),
                width: 120, height: (120 / thumbnailItem.aspectRatio!.toDouble()).round()),
            fit: BoxFit.cover,
            placeholder: AssetImage("assets/images/img_placeholder.jpg",
                package: "core"),
          ),
        ),
      );

  Widget _buildMultipleChoiceItem(
    BuildContext context, {
    final ThumbnailItem? thumbnailItem,
    final int? index,
    final bool? isChosen,
  }) {
    print("index: " + index.toString());
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(236, 236, 236, 1),
        borderRadius: index == 0 || index == 2
            ? BorderRadius.only(
                topRight: index == 2
                    ? Radius.circular(borderRadius)
                    : Radius.circular(0),
                topLeft: index == 0
                    ? Radius.circular(borderRadius)
                    : Radius.circular(0))
            : BorderRadius.all(Radius.circular(0)),
      ),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () =>
                openCropper(widget.galleryType, thumbnailItem!, widget.cropType),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 250),
              curve: Curves.easeOutQuad,
              padding: EdgeInsets.all(
                  isChosen! ? MediaQuery.of(context).size.width * 0.033 : 0.0),
              width: double.infinity,
              height: double.infinity,
              child: ClipRRect(
                borderRadius: index == 0 || index == 2
                    ? BorderRadius.only(
                        topRight: index == 2
                            ? Radius.circular(borderRadius)
                            : Radius.circular(0),
                        topLeft: index == 0
                            ? Radius.circular(borderRadius)
                            : Radius.circular(0))
                    : BorderRadius.all(Radius.circular(0)),
                child: FadeInImage(
                  fadeInDuration: Duration(milliseconds: 200),
                  fadeOutDuration: Duration(milliseconds: 200),
                  image: ResizeImage(FileImage(thumbnailItem!.file),
                      width: 120,
                      height: (120 / thumbnailItem.aspectRatio!.toDouble()).round()),
                  fit: BoxFit.cover,
                  placeholder: AssetImage("assets/images/img_placeholder.jpg",
                      package: "core"),
                ),
              ),
            ),
          ),
          Positioned(
            top: 8.0,
            right: 8.0,
            child: InkWell(
              onTap: () {
                if (isChosen) {
                  _chosenFiles.add(thumbnailItem);
                } else {
                  _chosenFiles.remove(thumbnailItem);
                }
                setState(() {});
              },
              child: AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  width: MediaQuery.of(context).size.width * 0.067,
                  height: MediaQuery.of(context).size.width * 0.067,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isChosen ? Theme.of(context).accentColor : null,
                      border: Border.all(width: 2, color: Colors.white)),
                  child: isChosen
                      ? Center(
                          child: Text(
                              (_chosenFiles.indexOf(thumbnailItem) + 1)
                                  .toString(),
                              style: TextStyle(color: Colors.white)))
                      : Container()),
            ),
          ),
        ],
      ),
    );
  }

  openCropper(final GalleryType galleryType, final ThumbnailItem thumbnailItem,
      final CropType cropType) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: thumbnailItem.file.path,
        cropStyle: cropType == CropType.CIRCLE
            ? CropStyle.circle
            : CropStyle.rectangle,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            cropFrameColor: galleryType == GalleryType.SINGLE_CHOICE
                ? Colors.transparent
                : Colors.white,
            showCropGrid: galleryType != GalleryType.SINGLE_CHOICE,
            activeControlsWidgetColor: constants.accentColor,
            toolbarTitle: 'Add photo',
            toolbarColor: Colors.white,
            toolbarWidgetColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Add photo',
        ));
    if (croppedFile != null) {
      ImageProperties properties =
          await FlutterNativeImage.getImageProperties(croppedFile.path);
      ThumbnailItem croppedThumbnailItem = ThumbnailItem(
          file: croppedFile, aspectRatio: properties.width! / properties.height!.toDouble());
      if (galleryType == GalleryType.MULTIPLE_CHOICE) {
        int listIndex = _cachedFiles.indexOf(thumbnailItem);
        int chosenIndex = _chosenFiles.indexOf(thumbnailItem);
        _cachedFiles[listIndex] = croppedThumbnailItem;
        if (chosenIndex != -1) {
          _chosenFiles.removeAt(chosenIndex);
          _chosenFiles.insert(chosenIndex, croppedThumbnailItem);
        } else {
          _chosenFiles.add(croppedThumbnailItem);
        }
        setState(() {});
      } else if (galleryType == GalleryType.SINGLE_CHOICE) {
        // CoreModule.globalKey.currentState.pop(croppedFile);
      }
    } else {
      if (galleryType == GalleryType.MULTIPLE_CHOICE) {
        int chosenIndex = _chosenFiles.indexOf(thumbnailItem);
        if (chosenIndex != -1) _chosenFiles.removeAt(chosenIndex);
      }
      setState(() {});
    }
  }

  takePhoto(final GalleryType galleryType) async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      ImageProperties properties =
          await FlutterNativeImage.getImageProperties(pickedFile.path);
      ThumbnailItem thumbnailItem = ThumbnailItem(
          file: File(pickedFile.path), aspectRatio: properties.width! / properties.height!.toDouble());
      _cachedFiles = [thumbnailItem] + _cachedFiles;
      openCropper(galleryType, thumbnailItem, widget.cropType);
    }
  }

  chooseFromGallery(final GalleryType galleryType) async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      ImageProperties properties =
          await FlutterNativeImage.getImageProperties(pickedFile.path);
      ThumbnailItem thumbnailItem = ThumbnailItem(
          file: File(pickedFile.path), aspectRatio: properties.width! / properties.height!.toDouble());
      _cachedFiles = [thumbnailItem] + _cachedFiles;
      openCropper(galleryType, thumbnailItem, widget.cropType);
    }
  }
}
