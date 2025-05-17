import 'package:finance/core/widget/item_card_skeleton.dart';
import 'package:finance/core/widget/k_app_bar.dart';
import 'package:finance/core/widget/k_bottom_button.dart';
import 'package:finance/core/widget/k_padding.dart';
import 'package:finance/core/widget/k_skeleton_list.dart';
import 'package:finance/modules/common/main_page/main_view_model.dart';
import 'package:finance/modules/common/data_entering/model/data_adding_view_model.dart';
import 'package:finance/modules/common/data_entering/ui/edit_item.dart';
import 'package:finance/modules/common/data_entering/ui/item_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DataCheckingPage extends StatefulWidget {
  final String? headerName;

  const DataCheckingPage({super.key, required this.headerName});

  @override
  State<DataCheckingPage> createState() => _DataCheckingPageState();
}

class _DataCheckingPageState extends State<DataCheckingPage> {
  late DataAddingViewModel _dataAddingViewModel;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _dataAddingViewModel = DataAddingViewModel();
    _initialize();
  }

  Future<void> _initialize() async {
    await _dataAddingViewModel.init();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _dataAddingViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DataAddingViewModel>.value(
          value: _dataAddingViewModel,
        ),
        ChangeNotifierProvider.value(
          value: Provider.of<MainViewModel>(context),
        ),
      ],
      child: Scaffold(
        appBar: KAppBar(title: Text(widget.headerName ?? "Data Checking")),
        body:
            _isLoading
                ? const Center(child: ItemCardSkeleton())
                : Padding(
                  padding: KPadding.defaultPagePadding,
                  child: Consumer<DataAddingViewModel>(
                    builder: (context, model, _) {
                      if (model.isBusy) return const ItemCardSkeleton();
                      return Scaffold(
                        body: ListView.builder(
                          itemCount: model.newItems.length,
                          itemBuilder: (context, index) {
                            final item = model.newItems[index];
                            return ItemCard(
                              item: item,
                              onEdit: () async {
                                final edited = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditItem(item: item),
                                  ),
                                );
                                if (edited != null) {
                                  // Optionally handle update
                                }
                              },
                            );
                          },
                        ),
                        bottomNavigationBar: KBottomButton(
                          onTap: () {
                            Provider.of<MainViewModel>(
                              context,
                              listen: false,
                            ).addItem(model.newItems);
                          },
                          text: "Save",
                        ),
                      );
                    },
                  ),
                ),
      ),
    );
  }
}
