// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_photo_idea_app/common/enums.dart';
import 'package:flutter_photo_idea_app/data/models/photo_model.dart';
import 'package:flutter_photo_idea_app/presentation/controllers/saved_controller.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../detail_photo_page.dart';

class SavedFragment extends StatefulWidget {
  const SavedFragment({super.key});

  @override
  State<SavedFragment> createState() => _SavedFragmentState();
}

class _SavedFragmentState extends State<SavedFragment> {
  final savedController = Get.put(SavedController());

  void gotoDetail(PhotoModel photo) {
    Navigator.pushNamed(
      context,
      DetailPhotoPage.routeName,
      arguments: photo.id,
    );
  }

  @override
  void initState() {
    savedController.fetchRequest();
    super.initState();
  }

  @override
  void dispose() {
    SavedController.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(MediaQuery.paddingOf(context).top + 10),
        buildTitle(),
        const Gap(12),
        Expanded(
          child: buildGridPhotos(),
        ),
      ],
    );
  }

  Widget buildTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saved',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Text(
            'Your selected photos',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 14,
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGridPhotos() {
    return Obx(() {
      final state = savedController.state;
      if (state.fetchStatus == FetchStatus.init) {
        return const SizedBox();
      }
      if (state.fetchStatus == FetchStatus.loading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state.fetchStatus == FetchStatus.failed) {
        return Center(child: Text(state.message));
      }
      List<PhotoModel> list = state.list ?? [];
      if (list.isEmpty) {
        return const Center(child: Text('No Saved Photo Yet'));
      }
      return GridView.builder(
        itemCount: list.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
          childAspectRatio: 1,
        ),
        padding: const EdgeInsets.all(0),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final item = list[index];
          return buildPhotoItem(item);
        },
      );
    });
  }

  Widget buildPhotoItem(PhotoModel photo) {
    return GestureDetector(
      onTap: () => gotoDetail(photo),
      child: ExtendedImage.network(
        photo.source?.medium ?? '',
        fit: BoxFit.cover,
      ),
    );
  }
}
