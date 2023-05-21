import 'package:flutter/material.dart';

class drawer extends StatefulWidget {
  const drawer({super.key});

  @override
  State<drawer> createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('Yasser Eddouche'),
            accountEmail: Text('yassereddouche@gmail.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('images/User_default.png'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              setState(() {
                Navigator.of(context).pushNamed('Home');
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text('Personal information'),
            onTap: () {
              setState(() {
                Navigator.of(context).pushNamed('User_info');
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              setState(() {
                Navigator.of(context).pushNamed('About');
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              setState(() {
                Navigator.of(context).pushReplacementNamed('Login');
              });
            },
          ),
        ],
      ),
    );
  }
}
