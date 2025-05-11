import 'package:aqaraty/provider/notifiers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/realestate_card.dart';
import '../../models/real_estate.dart';
import '../../pages/add_page.dart';
import '../../router/router.dart';
import 'package:flutter/material.dart';

List<RealEstate> data = [realesatateSample];

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final coreProvRead = ref.read(coreProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("عقاراتي"),
        actions: [
          IconButton(
            onPressed: () async {
              await coreProvRead.fullLogout();
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          context.myPush(AddPage());
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) =>
                  RealestateCard(realEstate: data[index]),
            ),
          ),
        ],
      ),
    );
  }
}
