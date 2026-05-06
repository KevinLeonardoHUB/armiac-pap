import 'package:flutter/material.dart';

import 'home/home_page.dart';


import 'settings/settings_page.dart';
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Armiac',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),

        useMaterial3: true,

      ),

      home: const MyHomePage(),

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [

    HomePage(),

    SettingsPage(),
  ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        backgroundColor: Colors.black,

        centerTitle: true,

        toolbarHeight: 120,

        title: SizedBox(

          height: 200,

          child: Image.asset(
            "assets/images/Armiac_LOGO.png",

            fit: BoxFit.contain,
          ),
        ),
      ),

      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: _selectedIndex,

        onTap: _onItemTapped,

        backgroundColor: Colors.black,

        selectedItemColor: Colors.white,

        unselectedItemColor: Colors.grey,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),

            label: "Home",
          ),


          BottomNavigationBarItem(
            icon: Icon(Icons.settings),

            label: "Config",
          ),
        ],
      ),
    );
  }
}
