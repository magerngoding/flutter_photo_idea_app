// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors
import 'package:d_input/d_input.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_photo_idea_app/presentation/controllers/search_photo_controller.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../common/enums.dart';
import '../../data/models/photo_model.dart';
import 'detail_photo_page.dart';

class SearchPhotosPage extends StatefulWidget {
  const SearchPhotosPage({
    Key? key,
    required this.query,
  }) : super(key: key);

  final String query;
  static const routeName = '/photo/search';

  @override
  State<SearchPhotosPage> createState() => _SearchPhotosPageState();
}

class _SearchPhotosPageState extends State<SearchPhotosPage> {
  final queryController = TextEditingController();
  final searchPhotosController = Get.put(SearchPhotosController());
  final scrollController = ScrollController();
  final showUpButton = RxBool(false);

  void startSearch() {
    final query = queryController.text;
    if (query == '') return;
    searchPhotosController.research(query);
  }

  void gotoUpPage() {
    scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  void gotoDetail(PhotoModel photo) {
    Navigator.pushNamed(
      context,
      DetailPhotoPage.routeName,
      arguments: photo.id,
    );
  }

  @override
  void initState() {
    final widgetQuery = widget.query;
    if (widgetQuery != '') {
      queryController.text = widgetQuery;
      startSearch();
    }
    scrollController.addListener(() {
      // Ngecek scroll udah maksimum
      bool reachMax =
          scrollController.offset == scrollController.position.maxScrollExtent;
      if (reachMax) {
        final query = queryController.text;
        if (query == '') return;
        searchPhotosController.fetchRequest(query);
      }

      bool passMaxHeight =
          scrollController.offset > MediaQuery.sizeOf(context).height;
      // jika sudah diklik maka akan menghilang
      showUpButton.value = passMaxHeight;
    });
    super.initState();
  }

  @override
  void dispose() {
    SearchPhotosController.delete();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        title: buildSearch(),
      ),
      body: ListView(
        controller: scrollController,
        children: [
          buildSearchPhotos(),
          buildLoadingOrFailed(),
          Gap(50),
        ],
      ),
      floatingActionButton: buildUpwardButton(),
    );
  }

  Widget buildSearch() {
    return DInputMix(
      controller: queryController,
      hint: 'Search photos...',
      boxColor: Colors.white,
      inputPadding: EdgeInsets.all(4),
      prefixIcon: IconSpec(
        icon: Icons.arrow_back_ios_outlined,
        onTap: () => Navigator.pop(context),
        boxSize: Size(40, 40),
      ),
      suffixIcon: IconSpec(
        icon: Icons.search,
        // kalau void tidak bosa menggunakan ()
        onTap: startSearch,
        boxSize: Size(40, 40),
      ),
    );
  }

  Widget buildSearchPhotos() {
    return Obx(() {
      final state = searchPhotosController.state;
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
        itemBuilder: (context, index) {
          final item = list[index];
          return buildPhotoItem(item);
        },
      );
    });
  }

  Widget buildPhotoItem(PhotoModel photo) {
    // Extended image agar menstabilkan jaringan untuk photo lebih bagus daripada image.network
    return GestureDetector(
      onTap: () => gotoDetail(photo),
      child: ExtendedImage.network(
        photo.source?.portrait ?? '',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildLoadingOrFailed() {
    return Obx(() {
      final state = searchPhotosController.state;
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

  Widget buildUpwardButton() {
    return Obx(() {
      if (showUpButton.value) {
        return FloatingActionButton.small(
          heroTag: 'icon_small_upward',
          onPressed: gotoUpPage,
          child: const Icon(
            Icons.arrow_upward,
          ),
        );
      }
      return SizedBox();
    });
  }
}
