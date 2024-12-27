// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fd_log/fd_log.dart';
import 'package:flutter_photo_idea_app/core/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_photo_idea_app/common/app_constant.dart';
import 'package:flutter_photo_idea_app/data/datasource/remote_photo_datasource.dart';
import 'package:gap/gap.dart';
import 'package:d_input/d_input.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  final queryController = TextEditingController();
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

  @override
  void initState() {
    RemotePhotoDatasource.fetchCurated(1, 10);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        buildHeader(),
        buildCategories(),
      ],
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
}
