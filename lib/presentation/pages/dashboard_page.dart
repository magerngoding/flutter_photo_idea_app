// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last
import 'package:flutter/material.dart';
import 'package:flutter_photo_idea_app/data/datasource/remote_photo_datasource.dart';
import 'package:flutter_photo_idea_app/presentation/pages/fragment/home_fragment.dart';
import 'package:flutter_photo_idea_app/presentation/pages/fragment/saved_fragment.dart';
import 'package:get/get.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final indexFragment = RxInt(0); // GetX

  final menuBottmNav = [
    Icons.home,
    Icons.bookmark,
  ];

  @override
  void initState() {
    RemotePhotoDatasource.fetchCurated(
      1,
      10,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return IndexedStack(
          index: indexFragment.value,
          children: [
            HomeFragment(),
            SavedFragment(),
          ],
        );
      }),
      bottomNavigationBar: buildBottomNav(),
      extendBody: true, // agar wilayah body tidak terututp / queque
      resizeToAvoidBottomInset: false, //
    );
  }

  Widget buildBottomNav() {
    final primaryColor = Theme.of(context).primaryColor;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(
                20.0,
              ),
            ),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 3),
                color: Colors.black26,
                blurRadius: 6,
              ),
            ],
          ),
          // pake obx biar bisa gerak2 atau dinamis
          child: Obx(() {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(menuBottmNav.length, (index) {
                final isActive = indexFragment == index;

                return RawMaterialButton(
                  onPressed: () {
                    // Merubah index pada saat di klik
                    indexFragment.value = index;
                  },
                  child: Icon(
                    menuBottmNav[index],
                    color:
                        isActive ? Colors.white : primaryColor.withOpacity(0.5),
                  ),
                  // Mengatur ukuran icon
                  constraints: BoxConstraints.tightFor(
                    height: 54,
                    width: 54,
                  ),
                  fillColor: isActive ? primaryColor : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20 - 4),
                    ),
                  ),
                  // dibuat agak naik ketika di select
                  elevation: isActive ? 8 : 0,
                );
              }),
            );
          }),
        ),
      ),
    );
  }
}
