import 'package:aqaraty/components/realestate_card.dart';
import 'package:aqaraty/models/real_estate.dart';
import 'package:aqaraty/pages/add_page.dart';
import 'package:aqaraty/router/router.dart';
import 'package:flutter/material.dart';

List<RealEstate> data = [realesatateSample];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("عقاراتي")),
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
