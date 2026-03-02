import 'package:flutter/material.dart';

import 'Home.dart';
import 'PremiumPage.dart';
import 'ProfilePage.dart';
import '../Models/Server.dart';
import 'ServerSelectionPage.dart';
import 'Speed.dart';



class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; 
   ServerModel _selectedServer = ServerModel(
      country: 'United States',
      flagEmoji: '🇺🇸',
      locationCount: 18,
      basePing: 543,
    );
  late final List<Widget> _screens;
  final List<ServerModel> _servers = [
    ServerModel(country: 'Germany', flagEmoji: '🇩🇪', locationCount: 44, basePing: 543),
    ServerModel(country: 'United Kingdom', flagEmoji: '🇬🇧', locationCount: 18, basePing: 543),
    ServerModel(country: 'Australia', flagEmoji: '🇦🇺', locationCount: 46, basePing: 543),
    ServerModel(country: 'Singapore', flagEmoji: '🇸🇬', locationCount: 22, basePing: 420),
  ];


  @override
  void initState() {
    super.initState();
   
    _screens = [
      Home(selectedServer: _selectedServer,  onTapLocation: () => setState(() => _selectedIndex = 1),),
      ServerSelectionScreen(
         servers: _servers,
        selectedServer: _selectedServer,
        onSelect: (server) {
          setState(() {
            _selectedServer = server;
            _selectedIndex = 0; 
          });
        },
      ),
      const SpeedTestScreen(),
      const PremiumScreen(),
      const ProfileScreen(),
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      
      floatingActionButton: Container(
        height: 65,
        width: 65,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)], 
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3B82F6).withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => setState(() => _selectedIndex = 2),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.speed, color: Colors.white, size: 30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF0F172A), 
        shape: const CircularNotchedRectangle(),
        notchMargin: 12,
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             
              _buildNavItem(0, Icons.home_outlined, 'Home'),
             
              _buildNavItem(1, Icons.language_outlined, 'Server'),
              
              const SizedBox(width: 45), 
              
             
              _buildNavItem(3, Icons.workspace_premium_outlined, 'Premium'),
             
              _buildNavItem(4, Icons.account_circle_outlined, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;
    Color activeColor = (index == 3) ? const Color(0xFFFFD700) : const Color.fromARGB(255, 82, 140, 234);
    
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected ? activeColor : Colors.grey.shade600,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? activeColor : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}