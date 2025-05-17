import 'package:finance/core/widget/k_app_bar.dart';
import 'package:finance/core/widget/k_bottom_button.dart';
import 'package:finance/core/widget/k_page.dart';
import 'package:finance/modules/common/main_page/main_view_model.dart';
import 'package:finance/modules/common/data_entering/model/category_enum.dart';
import 'package:finance/modules/common/data_entering/model/item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditItem extends StatefulWidget {
  final Item item;
  const EditItem({super.key, required this.item});

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late TextEditingController _dateController;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.item.transactionName ?? '',
    );
    _amountController = TextEditingController(
      text: widget.item.amount?.toStringAsFixed(2),
    );
    _dateController = TextEditingController(text: widget.item.date ?? '');
    _selectedCategory = widget.item.category;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    DateTime initialDate =
        DateTime.tryParse(widget.item.date ?? '') ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void _saveItem() {
    final editedItem = Item(
      transactionName: _nameController.text,
      amount: double.tryParse(_amountController.text),
      category: _selectedCategory,
      date: _dateController.text,
    );

    // For now: just pop with result
    Navigator.of(context).pop(editedItem);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Provider.of<MainViewModel>(context),
      child: Consumer<MainViewModel>(
        builder: (context, value, child) {
          return KPage(
            child: Scaffold(
              appBar: KAppBar(title: const Text("Edit Item")),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Transaction Name
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: "Transaction Name",
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Amount
                    TextField(
                      controller: _amountController,
                      decoration: const InputDecoration(labelText: "Amount"),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Category Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(labelText: "Category"),
                      items:
                          CategoryEnum.values
                              .map(
                                (cat) => DropdownMenuItem<String>(
                                  value: cat.name,
                                  child: Text(cat.name),
                                ),
                              )
                              .toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedCategory = val;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Date Picker
                    TextField(
                      controller: _dateController,
                      readOnly: true,
                      onTap: _pickDate,
                      decoration: const InputDecoration(
                        labelText: "Date",
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: KBottomButton(
                onTap: () {
                  value.editItem(widget.item);
                  Navigator.pop(context);
                },
                text: "Save",
              ),
            ),
          );
        },
      ),
    );
  }
}
