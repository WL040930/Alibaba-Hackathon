import 'package:finance/core/widget/k_app_bar.dart';
import 'package:finance/core/widget/k_page.dart';
import 'package:flutter/material.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return KPage(
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Colors.red),              
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.circular(50)
            ),
            child: Text("data"),
          )
        ],
      ),
    );
  }
}
