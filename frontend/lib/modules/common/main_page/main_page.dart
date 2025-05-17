import 'package:finance/modules/common/data_entering/ui/camera_page.dart';
import 'package:finance/modules/common/main_page/summary_page.dart';
import 'package:finance/modules/common/settings.dart/settings.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late PageController _pageController;
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    const CameraPage(),
    const SummaryPage(),
    const Settings(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index + 1; // Shift index to account for camera
    });
    _pageController.animateToPage(
      _selectedIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _pages,
      ),
      // Show BottomNavigationBar only if NOT on CameraPage (index 0)
      bottomNavigationBar:
          _selectedIndex == 0
              ? null
              : BottomNavigationBar(
                currentIndex: (_selectedIndex - 1).clamp(0, 1),
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index + 1; // offset for camera page
                    _pageController.animateToPage(
                      _selectedIndex,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  });
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.summarize),
                    label: 'Summary',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'Settings',
                  ),
                ],
              ),
    );
  }
}
