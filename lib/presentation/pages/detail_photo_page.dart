// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_photo_idea_app/common/enums.dart';
import 'package:flutter_photo_idea_app/presentation/controllers/detail_photo.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class DetailPhotoPage extends StatefulWidget {
  final int id;

  const DetailPhotoPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  static const routeName = '/photo/detail';

  @override
  State<DetailPhotoPage> createState() => _DetailPhotoPageState();
}

class _DetailPhotoPageState extends State<DetailPhotoPage> {
  final detailPhotoController = Get.put(DetailPhotoController());

  void openURL(String url) {
    print('clicked');
  }

  void fetchDetail() {
    detailPhotoController.fetchRequest(widget.id);
  }

  @override
  void initState() {
    fetchDetail();
    super.initState();
  }

  @override
  void dispose() {
    DetailPhotoController.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          final state = detailPhotoController.state;
          if (state.fetchStatus == FetchStatus.init) {
            return SizedBox();
          }
          if (state.fetchStatus == FetchStatus.loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.fetchStatus == FetchStatus.failed) {
            return Center(
              child: Text(state.message),
            );
          }

          final photo = state.data!;
          return ListView(
            padding: const EdgeInsets.all(0),
            children: [
              AspectRatio(
                aspectRatio: 0.8,
                child: Stack(
                  // mengikuti ukuran aspect ratio 0.8
                  fit: StackFit.expand,
                  children: [
                    buildImage(photo.source?.large2X ?? ''),
                    Positioned(
                      top: 60,
                      left: 16,
                      right: 16,
                      child: Row(
                        children: [
                          buildBackButton(),
                          Spacer(),
                          buildPreviewButton(photo.source?.original ?? ''),
                          buildSavaButton(),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 16,
                      child: buildOpenOnPexels(photo.url ?? ''),
                    ),
                  ],
                ),
              ),
              Gap(20),
              buildDescription(photo.alt ?? ''),
              buildPhotographer(
                photo.photographer ?? '',
                photo.photographerUrl ?? '',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildImage(String imageURL) {
    return ExtendedImage.network(
      imageURL,
      fit: BoxFit.cover,
    );
  }

  Widget buildBackButton() {
    // widget bawaan isinya navigator pop context
    return BackButton(
      color: Colors.white,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.black38),
      ),
    );
  }

  Widget buildPreviewButton(String imageURL) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => Stack(
            children: [
              Positioned.fill(
                // positioned.fill mengikuti stack, interactive viewer widget bawaan flutter agar gambar bisa di zoom
                child: InteractiveViewer(
                  child: ExtendedImage.network(imageURL),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: CloseButton(
                  color: Colors.white,
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.black38),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      style: ButtonStyle(
        iconColor: WidgetStatePropertyAll(Colors.white),
        backgroundColor: WidgetStatePropertyAll(Colors.black38),
      ),
      icon: Icon(Icons.visibility),
    );
  }

  Widget buildSavaButton() {
    return IconButton(
      style: ButtonStyle(
        iconColor: WidgetStatePropertyAll(Colors.white),
        backgroundColor: WidgetStatePropertyAll(Colors.black38),
      ),
      onPressed: () {},
      icon: Icon(Icons.bookmark),
    );
  }

  Widget buildOpenOnPexels(String url) {
    return GestureDetector(
      onTap: () => openURL(url),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(4.0),
          ),
          color: Colors.black38,
        ),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Text(
          "Oepn on Pexels",
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildDescription(String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        description == '' ? 'No description' : description,
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          color: Colors.black45,
        ),
      ),
    );
  }

  Widget buildPhotographer(String name, String url) {
    return ListTile(
      leading: Icon(
        Icons.account_circle,
        size: 48,
        color: Colors.grey,
      ),
      horizontalTitleGap: 10,
      title: Text(
        name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: GestureDetector(
        onTap: () => openURL(url),
        child: Text(
          'See Profile on Pexels',
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black38,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
