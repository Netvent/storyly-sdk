import 'package:flutter/material.dart';
import 'placement_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Map<String, String>> _tabs = [
    {
      'label': 'Story Bar',
      'token':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjIzODAsImFwcF9pZCI6MTcxODUsImluc19pZCI6MTkxMDB9.AmtkzTlj_g3RQwwHZTz6rsozH8VFqAogeSwgBdXLMDU',
    },
    {
      'label': 'Video Feed',
      'token':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6MjQwNDIsInQiOjF9.Uj9rEBowMUOP4zqueJQ8stXJXHdFOKoac8sKUEM8K5M',
    },
    {
      'label': 'Banner',
      'token':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjE0ODY3LCJhcHBfaWQiOjIyNDgyLCJwbGNtbnRfaWQiOjI1NDcwLCJzZGtfcGwiOiJpb3MifQ.jAIGPCEy1GES5WQMzjqlWKj_LuPLkkLAtsTdWmwF0MM',
    },
    {
      'label': 'Swipe Card',
      'token':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjE0ODY3LCJhcHBfaWQiOjIyNDgyLCJwbGNtbnRfaWQiOjI1NDcxLCJzZGtfcGwiOiJpb3MifQ.MeIfgCW71K0LweUH2_b16ODoPFp0MX5dQUer08SrI5k',
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_tabs[_selectedIndex]['label']!)),
      body: PlacementScreen(
        // Key is important to force rebuild when tab changes
        key: ValueKey(_tabs[_selectedIndex]['label']),
        name: _tabs[_selectedIndex]['label']!,
        token: _tabs[_selectedIndex]['token']!,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _tabs.map((tab) {
          return BottomNavigationBarItem(
            icon: const Icon(Icons.ad_units), // Placeholder icon
            label: tab['label'],
          );
        }).toList(),
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}
