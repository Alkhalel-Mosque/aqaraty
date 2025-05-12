import 'package:aqaraty/components/drawer.dart';
import 'package:aqaraty/components/search_bar.dart';
import 'package:aqaraty/provider/notifiers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/realestate_card.dart';
import '../../pages/add_page.dart';
import '../../router/router.dart';
import 'package:flutter/material.dart';

// List<RealEstate> data = [realesatateSample];

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
    final coreProvRead = ref.read(coreProvider);
    final data = ref.watch(coreProvider).realEstates;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          context.myPush(AddPage());
        },
      ),
      drawer: MyDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomSearchBar(hint: "", title: "عقاراتي"),
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
