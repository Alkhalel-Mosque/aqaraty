import 'package:aqaraty/components/drawer.dart';
import 'package:aqaraty/components/search_bar.dart';
import 'package:aqaraty/provider/notifiers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/realestate_card.dart';
import '../../pages/add_page.dart';
import '../../router/router.dart';
import 'package:flutter/material.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        ref.read(coreProvider).featchData();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = [...ref.watch(coreProvider).realEstates]..sort((a, b) =>
        (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
    final dataForSearch = ref.watch(coreProvider).realEstates;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          context.myPush(const AddPage());
        },
      ),
      drawer: const MyDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomSearchBar(
                resultBuilder: (p0, p1, p2) {
                  return RealestateCard(realEstate: p2);
                },
                hint: "",
                title: "عقاراتي",
                allEstates: dataForSearch,
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await ref.read(coreProvider).featchData();
                },
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) =>
                      RealestateCard(realEstate: data[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
