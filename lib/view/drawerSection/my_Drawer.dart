import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:news_app/view/drawerSection/my%20drawer_tile.dart';
import 'package:news_app/view/searchScreen/search_screen.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // app logo
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Icon(
              Icons.newspaper,
              size: 80,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),

          //home list tile
          MyDrawerTile(
            text: "H O M E",
            icon: Icons.home,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          MyDrawerTile(
            text: "S E A R C H",
            icon: Icons.search,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsSearchScreen(),
                ),
              );
            },
          ),

          const Spacer(),
          //logo out
          MyDrawerTile(
            text: "L O G O U T",
            icon: Icons.logout,
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('Logged out successfully!'),
                ),
              );
            },
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}
