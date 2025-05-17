import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:finance/core/widget/item_card_skeleton.dart';
import 'package:finance/core/widget/k_bottom_button.dart';
import 'package:finance/core/widget/k_app_bar.dart';
import 'package:finance/core/widget/k_padding.dart';
import 'package:finance/core/widget/k_page.dart';

import 'package:finance/modules/common/data_entering/model/camera_data_view_model.dart';
import 'package:finance/modules/common/data_entering/ui/edit_item.dart';
import 'package:finance/modules/common/data_entering/ui/item_card.dart';
import 'package:finance/modules/common/main_page/main_view_model.dart';

class CameraDataCheckingPage extends StatefulWidget {
  final File? file;
  const CameraDataCheckingPage({this.file, super.key});

  @override
  State<CameraDataCheckingPage> createState() => _CameraDataCheckingPageState();
}

class _CameraDataCheckingPageState extends State<CameraDataCheckingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildSpinningCircularImage({required Widget image}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        RotationTransition(
          turns: _controller,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                colors: const [
                  Colors.red,
                  Colors.orange,
                  Colors.yellow,
                  Colors.green,
                  Colors.blue,
                  Colors.indigo,
                  Colors.purple,
                  Colors.red,
                ],
                startAngle: 0.0,
                endAngle: 2 * pi,
              ),
            ),
          ),
        ),
        Container(
          width: 200,
          height: 200,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ClipOval(child: image),
        ),
      ],
    );
  }

  void _showFullImage() {
    if (widget.file == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => FullImagePage(file: widget.file!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CameraDataViewModel>(
      create: (_) {
        final model = CameraDataViewModel();
        model.init(widget.file!);
        return model;
      },
      child: KPage(
        child: Scaffold(
          appBar: KAppBar(title: const Text("Camera Data Checking")),
          body: Padding(
            padding: KPadding.defaultPagePadding,
            child: Consumer<CameraDataViewModel>(
              builder: (context, cameraModel, _) {
                return Column(
                  children: [
                    // Image + activity
                    Center(
                      child: Column(
                        children: [
                          if (widget.file != null)
                            _buildSpinningCircularImage(
                              image: Image.file(
                                widget.file!,
                                fit: BoxFit.cover,
                              ),
                            )
                          else
                            const Text('No image selected.'),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _showFullImage,
                            icon: const Icon(Icons.fullscreen),
                            label: const Text("View Full Image"),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Results or skeleton
                    if (cameraModel.isBusy)
                      const ItemCardSkeleton()
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: cameraModel.newItems.length,
                          itemBuilder: (context, index) {
                            final item = cameraModel.newItems[index];
                            return ItemCard(
                              item: item,
                              showEditIcon: false,
                              onEdit: () async {
                                // final edited = await Navigator.push<Item>(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (_) => EditItem(item: item),
                                //   ),
                                // );
                                // if (edited != null) {
                                //   cameraModel.updateItem(edited);
                                // }
                              },
                            );
                          },
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          // Save button: needs both cameraModel and mainModel
          bottomNavigationBar: Consumer2<CameraDataViewModel, MainViewModel>(
            builder: (context, cameraModel, mainModel, _) {
              return KBottomButton(
                text: "Save",
                onTap: () {
                  // merge cameraModel.newItems into mainModel
                  mainModel.addItem(cameraModel.newItems);
                  Navigator.of(context).pop(); // or show a snackbar
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class FullImagePage extends StatelessWidget {
  final File file;
  const FullImagePage({required this.file, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KAppBar(title: const Text("Full Image")),
      body: Center(child: Image.file(file)),
    );
  }
}
