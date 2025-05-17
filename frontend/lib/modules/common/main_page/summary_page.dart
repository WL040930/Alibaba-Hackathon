import 'package:finance/core/widget/k_padding.dart';
import 'package:finance/modules/common/data_entering/ui/item_card.dart';
import 'package:finance/modules/common/main_page/main_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  String _selectedRange = '1w';
  int _touchedIndex = -1;

  final Map<String, Duration?> _ranges = {
    '1d': Duration(days: 1),
    '1w': Duration(days: 7),
    '1m': Duration(days: 30),
    '1y': Duration(days: 365),
    'All': null,
  };

  final List<Color> _sliceColors = [
    Colors.orangeAccent,
    Colors.yellowAccent,
    Colors.greenAccent,
    Colors.blueAccent,
    Colors.indigoAccent,
    Colors.purpleAccent,
    Colors.tealAccent,
    Colors.lime,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Consumer<MainViewModel>(
          builder: (context, model, child) {
            final now = DateTime.now();

            final filtered =
                model.items.where((item) {
                  final cutoff =
                      _ranges[_selectedRange] != null
                          ? now.subtract(_ranges[_selectedRange]!)
                          : null;
                  final itemDate =
                      DateTime.tryParse(item.date ?? '') ??
                      DateTime.fromMillisecondsSinceEpoch(0);
                  return cutoff == null || itemDate.isAfter(cutoff);
                }).toList();

            final categoryTotals = <String, double>{};
            for (var item in filtered) {
              final category = item.category ?? 'Unknown';
              final amount = double.tryParse(item.amount.toString()) ?? 0.0;
              categoryTotals[category] =
                  (categoryTotals[category] ?? 0) + amount;
            }

            final legendEntries = categoryTotals.entries.toList();
            final totalAmount = categoryTotals.values.fold(
              0.0,
              (a, b) => a + b,
            );

            return CustomScrollView(
              slivers: [
                // Red Graph Header Section
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 16,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SafeArea(
                          child: Text(
                            'Summary',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Duration Selector
                        Wrap(
                          spacing: 8,
                          children:
                              _ranges.keys.map((range) {
                                return ChoiceChip(
                                  label: Text(range.toUpperCase()),
                                  selected: _selectedRange == range,
                                  onSelected: (_) {
                                    setState(() {
                                      _selectedRange = range;
                                    });
                                  },
                                  selectedColor: Colors.white,
                                  backgroundColor: Colors.red.shade300,
                                  labelStyle: TextStyle(
                                    color:
                                        _selectedRange == range
                                            ? Colors.red
                                            : Colors.white,
                                  ),
                                );
                              }).toList(),
                        ),
                        const SizedBox(height: 16),

                        // Chart or No Data
                        if (categoryTotals.isEmpty)
                          const Text(
                            "No data for this range.",
                            style: TextStyle(color: Colors.white),
                          )
                        else
                          Column(
                            children: [
                              SizedBox(
                                height: 200,
                                child: PieChart(
                                  PieChartData(
                                    sectionsSpace: 2,
                                    centerSpaceRadius: 40,
                                    pieTouchData: PieTouchData(
                                      touchCallback: (event, response) {
                                        setState(() {
                                          if (!event
                                                  .isInterestedForInteractions ||
                                              response == null ||
                                              response.touchedSection == null) {
                                            _touchedIndex = -1;
                                          } else {
                                            _touchedIndex =
                                                response
                                                    .touchedSection!
                                                    .touchedSectionIndex;
                                          }
                                        });
                                      },
                                    ),
                                    sections: List.generate(
                                      categoryTotals.length,
                                      (i) {
                                        final entry = legendEntries[i];
                                        final percentage = (entry.value /
                                                totalAmount *
                                                100)
                                            .toStringAsFixed(1);
                                        final isSelected = i == _touchedIndex;
                                        return PieChartSectionData(
                                          color:
                                              _sliceColors[i %
                                                  _sliceColors.length],
                                          value: entry.value,
                                          title:
                                              isSelected ? "$percentage%" : '',
                                          radius: isSelected ? 70 : 60,
                                          titleStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 16,
                                children: List.generate(legendEntries.length, (
                                  i,
                                ) {
                                  final entry = legendEntries[i];
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color:
                                              _sliceColors[i %
                                                  _sliceColors.length],
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        entry.key,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),

                // White Item List Section
                SliverToBoxAdapter(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    padding: KPadding.defaultPagePadding.copyWith(top: 0),
                    child:
                        filtered.isEmpty
                            ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: Center(child: Text("No items found.")),
                            )
                            : ListView.builder(
                              itemCount: filtered.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final item = filtered[index];
                                return ItemCard(
                                  item: item,
                                  showEditIcon: false,
                                  onEdit: () {},
                                );
                              },
                            ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
