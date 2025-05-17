import 'package:finance/core/widget/k_padding.dart';
import 'package:finance/modules/common/data_entering/ui/item_card.dart';
import 'package:finance/modules/common/main_page/main_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final redHeight = screenHeight * 0.3;

    return Scaffold(
      backgroundColor: Colors.red, // Top 30% background
      body: Stack(
        children: [
          // White container with curved top corners
          Positioned(
            top: redHeight - 40,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: KPadding.defaultPagePadding,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Consumer<MainViewModel>(
                builder: (context, model, child) {
                  return ListView.builder(
                    itemCount: model.items.length,
                    itemBuilder: (context, index) {
                      final item = model.items[index];
                      return ItemCard(
                        item: item,
                        showEditIcon: false,
                        onEdit: () {},
                      );
                    },
                  );
                },
              ),
            ),
          ),

          // Optional: Add title or content in red section
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Summary',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
