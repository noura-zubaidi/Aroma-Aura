import 'package:flutter/material.dart';
import 'package:perfumes_app/core/constants/colors.dart';
import 'package:perfumes_app/view/screens/profile_screen.dart';

class AppDrawer extends StatelessWidget {
  final VoidCallback onLogout;

  const AppDrawer({
    Key? key,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: log1,
            ),
            child: const Text(
              'Aroma Aura',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'LibreRegular',
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
            leading: Icon(
              Icons.account_circle,
              color: log1,
            ),
            title: const Text(
              'Profile',
              style: TextStyle(
                fontFamily: 'LibreRegular',
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.add_outlined,
              color: log1,
            ),
            title: const Text(
              'Add Perfume',
              style: TextStyle(
                fontFamily: 'LibreRegular',
              ),
            ),
          ),
          ListTile(
            onTap: onLogout,
            leading: Icon(
              Icons.logout_rounded,
              color: log1,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(
                fontFamily: 'LibreRegular',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
