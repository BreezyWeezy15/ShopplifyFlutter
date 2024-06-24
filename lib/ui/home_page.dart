import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_flutter_app/auth_bloc/furniture_bloc.dart';
import 'package:furniture_flutter_app/auth_bloc/shop_bloc.dart';
import 'package:furniture_flutter_app/auth_bloc/shop_bloc_event.dart';
import 'package:furniture_flutter_app/auth_bloc/shop_bloc_state.dart';
import 'package:furniture_flutter_app/screens/fav_page.dart';
import 'package:furniture_flutter_app/screens/furniture_page.dart';
import 'package:furniture_flutter_app/screens/profile_page.dart';
import 'package:furniture_flutter_app/screens/search_page.dart';
import 'package:furniture_flutter_app/storage/storage_helper.dart';
import 'package:furniture_flutter_app/utils.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final List<Widget> _widgets = [
    const FurniturePage(),
    const SearchPage(),
    const FavPage(),
    const ProfilePage()
  ];
  final List<String> _tabs = [
    "assets/images/home.png",
    "assets/images/search.png",
    "assets/images/fav.png",
    "assets/images/profile.png"
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          items: List.generate(_tabs.length, (index){
            return BottomNavigationBarItem(icon: Image.asset(_tabs[index], width: 25,height: 25,),label: "");
          }).toList(),
          onTap: (index){
            setState(() {
              selectedIndex = index;
            });
          },
        ),
        body: _widgets[selectedIndex],
      ),
    );
  }
}
