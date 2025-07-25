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
    try {
      await _hiveBox.clear();

      // حفظ البيانات مع استخدام الـ id كمفتاح
      final Map<String, RealEstate> data = {
        for (var estate in list)
          if (estate.id != null) estate.id!: estate
      };

      await _hiveBox.putAll(data);
      print('تم حفظ ${data.length} عنصر محلياً');
    } catch (e) {
      print('خطأ في حفظ البيانات محلياً: $e');
      CustomToast.showToast("❗ فشل في حفظ البيانات محلياً");
    }
  }

  Future<List<RealEstate>> loadFromLocal() async {
    try {
      final localData = _hiveBox.values.toList();
      localData.sort((a, b) =>
          (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));

      print('تم تحميل ${localData.length} عنصر من التخزين المحلي');
      return localData;
    } catch (e) {
      print('خطأ في تحميل البيانات المحلية: $e');
      return [];
    }
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);

    try {
      final localData = await loadFromLocal();
      if (localData.isNotEmpty) {
        setState(() => realEstates = localData);
        CustomToast.showToast("📦 عرض البيانات المحفوظة محلياً");
      }

      final isOnline = await hasInternet();
      if (isOnline) {
        await ref.read(coreProvider).featchData();
        final result = [...ref.read(coreProvider).realEstates];
        await saveToLocal(result);
        setState(() => realEstates = result);
        CustomToast.showToast("✅ تم تحديث البيانات من السيرفر");
      } else if (localData.isEmpty) {
        CustomToast.showToast("⚠️ لا يوجد اتصال، ولا توجد بيانات محلية");
      }
    } catch (e) {
      print('❌ خطأ في تحميل البيانات: $e');
      CustomToast.showToast("❗ حدث خطأ في تحميل البيانات");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => context.myPush(const AddPage()),
      ),
      drawer: const MyDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomSearchBar(
                resultBuilder: (p0, p1, p2) => RealestateCard(
                  realEstate: p2,
                ),
                hint: "ابحث عن عقار...",
                title: "عقاراتي",
                allEstates: realEstates,
              ),
            ),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
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
        itemBuilder: (context, index) => RealestateCard(
          realEstate: realEstates[index],
        ),
      ),
    );
  }
}
