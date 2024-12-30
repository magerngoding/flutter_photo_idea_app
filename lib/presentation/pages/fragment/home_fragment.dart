// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:extended_image/extended_image.dart';
import 'package:fd_log/fd_log.dart';
import 'package:flutter_photo_idea_app/common/enums.dart';
import 'package:flutter_photo_idea_app/core/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_photo_idea_app/common/app_constant.dart';
import 'package:flutter_photo_idea_app/data/models/photo_model.dart';
import 'package:flutter_photo_idea_app/presentation/controllers/curated_photos_controller.dart';
import 'package:gap/gap.dart';
import 'package:d_input/d_input.dart';
import 'package:get/get.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  final curatedPhotosController = Get.put(CurratedPhotosController());
  final queryController = TextEditingController();
  final scrollController = ScrollController();

  final categories = [
    'happy',
    'people',
    'trip',
    'sea',
    'friends',
    'sky',
    'business',
    'nature',
  ];

  // Method - pakai void karena tidak ada callback
  void gotoSearch() {}

  // Triggerd
  @override
  void initState() {
    curatedPhotosController.fetchRequest();

    scrollController.addListener(() {
      //  sl<FDLog>().basic(scrollController.offset.toString());

      // Ngecek scroll udah maksimum
      bool reachMax =
          scrollController.offset == scrollController.position.maxScrollExtent;
      if (reachMax) {
        curatedPhotosController.fetchRequest();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    CurratedPhotosController.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // RefreshIndicator agar tarik refresh dengan cara tarik layar ke bawah
    return RefreshIndicator.adaptive(
      onRefresh: () async {},
      child: ListView(
        controller: scrollController,
        children: [
          buildHeader(),
          buildCategories(),
          buildCuratedPhotos(),
          buildLoadingOrFailed(),
          Gap(50),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Stack(
      children: [
        Image.asset(
          AppConstant.homeHeaderImage,
          width: double.infinity,
          height: MediaQuery.sizeOf(context).height * 0.5,
          fit: BoxFit.cover,
        ),
        Positioned.fill(
          // .fill untuk mengisi warna di bagian stack only
          child: ColoredBox(
            color: Colors.black38,
          ),
        ),
        Positioned(
          left: 30,
          right: 30,
          top: 0, // tarik ke atas biar di tengah
          bottom: 0, // tarik ke bawah biar di tengah
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Find Something Cool",
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Gap(13),
              Text(
                "Explore your great idea\nMore and more",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              Gap(20),
              buildSeach(),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSeach() {
    return DInputMix(
      controller: queryController,
      hint: 'Search photo year',
      // ketika di klik enter atau icon search
      inputOnFieldSubmitted: (value) => gotoSearch(),
      hintStyle: TextStyle(
        fontWeight: FontWeight.normal,
        color: Colors.white60,
      ),
      inputStyle: TextStyle(
        fontWeight: FontWeight.normal,
        color: Colors.white,
      ),
      boxBorder: Border.all(
        color: Colors.white70,
      ),
      boxColor: Colors.transparent,
      suffixIcon: IconSpec(
        icon: Icons.search,
        color: Colors.white70,
        onTap: gotoSearch,
      ),
    );
  }

  Widget buildCategories() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(right: 8),
        itemBuilder: (context, index) {
          final item = categories[index];

          return Padding(
            padding: EdgeInsets.only(left: 8),
            child: ActionChip(
              onPressed: () {
                sl<FDLog>().title('Icon', 'Diklik');
              },
              label: Text(item),
              labelStyle: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(6.0),
                ),
                side: BorderSide(
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildCuratedPhotos() {
    return Obx(() {
      final state = curatedPhotosController.state;
      if (state.fetchStatus == FetchStatus.init) {
        return SizedBox();
      }

      final list = state.list ?? [];
      return GridView.builder(
        itemCount: list.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // jumlah data ke samping
          mainAxisSpacing: 1, // jarak vertikal
          crossAxisSpacing: 1, // jarak horizontal
          childAspectRatio: 1,
        ),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final item = list[index];
          return buildPhotoItem(item);
        },
      );
    });
  }

  Widget buildPhotoItem(PhotoModel photo) {
    // Extended image agar menstabilkan jaringan untuk photo lebih bagus daripada image.network
    return ExtendedImage.network(
      photo.source?.portrait ?? '',
      fit: BoxFit.cover,
    );
  }

  Widget buildLoadingOrFailed() {
    return Obx(() {
      final state = curatedPhotosController.state;
      if (state.fetchStatus == FetchStatus.loading) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      if (state.fetchStatus == FetchStatus.failed) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Text(
              state.message,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
      if (state.fetchStatus == FetchStatus.success && !state.hasMore) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Text('No More Photo!'),
          ),
        );
      }
      return SizedBox();
    });
  }
}
