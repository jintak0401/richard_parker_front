import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:richard_parker/constants/screen_size.dart';
import 'package:richard_parker/screens/board_screen.dart';
import 'package:richard_parker/screens/profile_screen.dart';
import 'package:richard_parker/screens/tmp_screen.dart';

// 로그아웃 버튼만 있는 임시 홈 화면
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  static const List<BottomNavigationBarItem> btmNavItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
    BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: '위키'),
    BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: '지도'),
    BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: '계정'),
  ];

  static final List<Widget> _screens = <Widget>[
    BoardScreen(),
    TmpScreen(),
    Container(
      color: Colors.amberAccent,
    ),
    ProfileScreen(),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (size == null) size = MediaQuery.of(context).size;

    return Scaffold(
      key: _key,
      // appBar: CupertinoNavigationBar(
      //   middle: Text('홈 화면'),
      //   trailing: IconButton(
      //       icon: Icon(Icons.menu),
      //       onPressed: () {
      //         _key.currentState.openEndDrawer();
      //       }),
      // ),
      // endDrawer: Container(
      //   width: 200,
      //   child: Drawer(
      //     child: ListView(
      //       children: <Widget>[
      //         DrawerHeader(
      //           child: Text(
      //             'Drawer Header',
      //             textAlign: TextAlign.center,
      //           ),
      //           decoration: BoxDecoration(
      //             color: Colors.blueAccent,
      //           ),
      //         ),
      //         TextButton(onPressed: () {}, child: Text('진탁')),
      //       ],
      //     ),
      //   ),
      // ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: btmNavItems,
        iconSize: 30,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black87,
        unselectedItemColor: Colors.grey,
        onTap: onTapBtmNavItems,
        type: BottomNavigationBarType.shifting,
      ),
    );
  }

  void onTapBtmNavItems(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
