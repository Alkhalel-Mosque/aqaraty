import 'package:aqaraty/components/back_ground_effict.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:aqaraty/models/real_estate.dart';
import 'package:aqaraty/components/realestate_card.dart';

class PendingEstatesPage extends StatefulWidget {
  const PendingEstatesPage({super.key});

  @override
  State<PendingEstatesPage> createState() => _PendingEstatesPageState();
}

class _PendingEstatesPageState extends State<PendingEstatesPage> {
  List<RealEstate> pendingEstates = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPending();
  }

  Future<void> loadPending() async {
    setState(() => isLoading = true);

    final pendingBox = Hive.box<RealEstate>('pending_real_estates');
    final data = pendingBox.values.toList();

    setState(() {
      pendingEstates = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          foregroundColor: theme.canvasColor,
          title: Text(
            "عقارات قيد الرفع",
            style: TextStyle(color: theme.canvasColor),
          ),
          backgroundColor: theme.colorScheme.surface,
        ),
        body: Stack(
          children: [
            background(context),
            circl1(context),
            circl2(context),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : pendingEstates.isEmpty
                    ? const Center(child: Text("لا توجد عقارات قيد الرفع"))
                    : RefreshIndicator(
                        onRefresh: loadPending,
                        child: ListView.builder(
                          itemCount: pendingEstates.length,
                          itemBuilder: (context, index) =>
                              RealEstateCard(realEstate: pendingEstates[index]),
                        ),
                      ),
          ],
        ));
  }
}
