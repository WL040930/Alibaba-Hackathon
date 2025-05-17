import 'package:finance/core/widget/k_padding.dart';
import 'package:finance/core/widget/k_page.dart';
import 'package:finance/modules/common/main_page/main_view_model.dart';
import 'package:finance/modules/common/data_entering/ui/item_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewModel>(
      builder: (context, model, child) {
        return Padding(
          padding: KPadding.defaultPagePadding,
          child: ListView.builder(
            itemCount: model.items.length,
            itemBuilder: (context, index) {
              final item = model.items[index];
              return ItemCard(
                item: item,
                showEditIcon: false,
                onEdit: () async {},
              );
            },
          ),
        );
      },
    );
  }
}
