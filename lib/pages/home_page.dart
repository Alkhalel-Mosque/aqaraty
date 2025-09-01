import 'package:aqaraty/components/back_ground_effict.dart';
import 'package:aqaraty/components/my_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:aqaraty/models/real_estate.dart';
import 'package:aqaraty/provider/notifiers.dart';
import 'package:aqaraty/utils/toast.dart';
import 'package:aqaraty/components/drawer.dart';
import 'package:aqaraty/components/search_bar.dart';
import 'package:aqaraty/components/realestate_card.dart';
import 'package:aqaraty/pages/add_page.dart';
import 'package:aqaraty/router/router.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  List<RealEstate> realEstates = [];
  bool isLoading = true;
  late final Box<RealEstate> _hiveBox;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  Future<void> _initialize() async {
    await _initHive();
    await loadData();
  }

  Future<void> _initHive() async {
    _hiveBox = Hive.box<RealEstate>('real_estates');
  }

  Future<bool> hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<void> saveToLocal(List<RealEstate> list) async {
    if (list.isEmpty) {
      return;
    }
    await _hiveBox.clear();
    for (var estate in list) {
      if (estate.id != null) {
        await _hiveBox.put(estate.id, estate);
      } else {
        await _hiveBox.add(estate);
      }
    }
  }

  Future<List<RealEstate>> loadFromLocal() async {
    try {
      final localData = _hiveBox.values.toList();
      localData.sort((a, b) =>
          (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));

      return localData;
    } catch (e) {
      CustomToast.showToast('خطأ في تحميل البيانات المحلية: $e');
      return [];
    }
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);

    try {
      final localData = await loadFromLocal();

      if (localData.isNotEmpty) {
        setState(() => realEstates = localData);
      }

      final isOnline = await hasInternet();
      if (isOnline) {
        await ref.read(coreProvider).featchData();
        final result = [...ref.read(coreProvider).realEstates];
        result.sort((a, b) =>
            (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));

        await saveToLocal(result);

        setState(() => realEstates = result);
      } else if (localData.isEmpty) {
        CustomToast.showToast("⚠️ لا يوجد اتصال، ولا توجد بيانات محلية");
      }
    } catch (e) {
      CustomToast.showToast('خطأ في تحميل البيانات المحلية: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: theme.focusColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () async {
            final result = await context.myPush(const AddPage());

            if (result != null && result is RealEstate) {
              setState(() {
                realEstates = realEstates
                    .map((item) => item.id == result.id ? result : item)
                    .toList();
              });
            }
            await loadData();
          }),
      drawer: const MyDrawer(),
      body: Stack(
        children: [
          background(context),
          circl1(context),
          circl2(context),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomSearchBar(
                    resultBuilder: (p0, p1, p2) => RealEstateCard(
                      realEstate: p2,
                    ),
                    hint: "ابحث عن عقار...",
                    title: "عقاراتي",
                    allEstates: realEstates,
                  ),
                ),
                Expanded(
                  child: _buildContent(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext ctx) {
    if (isLoading) {
      return Center(
          child: CircularProgressIndicator(
        color: Theme.of(context).cardColor,
      ));
    }

    if (realEstates.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("لا توجد عقارات متاحة"),
            TextButton(
              onPressed: loadData,
              child: const Text("حاول مرة أخرى"),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: loadData,
      child: ListView.builder(
        itemCount: realEstates.length,
        itemBuilder: (context, index) => RealEstateCard(
          realEstate: realEstates[index],
        ),
      ),
    );
  }
}
