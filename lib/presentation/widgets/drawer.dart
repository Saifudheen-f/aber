import 'package:espoir_marketing/core/const.dart';
import 'package:espoir_marketing/presentation/screens/login/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final currentUserEmail = auth.currentUser?.email ?? '';
    return Drawer(
      child: Column(
        children: [
          const DrawerHeaderWidget(),
          DrawerItem(
            icon: Icons.person,
            title: currentUserEmail,
            onTap: () {
              // Navigate to the Profile screen (if available)
            },
          ),
          DrawerItem(
            icon: Icons.exit_to_app,
            title: 'Log Out',
            onTap: () => _confirmLogout(context),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
 Future<void> _confirmLogout(BuildContext context) async {
    final bool logout = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log out',style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold,color: icontheme),),
          content: Text('Are you sure you want to log out?',style: TextStyle(color: const Color.fromARGB(255, 2, 61, 109),fontSize: 15),),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Log Out',style: TextStyle(color: const Color.fromARGB(255, 196, 6, 6)),),
            ),
          ],
        );
      },
    );

    if (logout == true) {
      await _logout(context);
    }
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (ctx) => const LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
        ),
      );
    }
  }
  // Future<void> _logout(BuildContext context) async {
  //   try {
  //     await FirebaseAuth.instance.signOut();
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (ctx) => const LoginPage()),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Logout failed: $e'),
  //       ),
  //     );
  //   }
  // }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: icontheme),
      title: Text(title,style: GoogleFonts.crimsonPro(fontSize: 18, color: Colors.black),),
      onTap: onTap,
    );
  }
}

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: const BoxDecoration(),
      child: Center(
        child: CircleAvatar(
          backgroundColor: const Color.fromARGB(255, 227, 227, 233),
          radius: 100,
          child: ClipOval(
            child: Image.asset(
            logoImage,
              fit: BoxFit.contain,
              height: 50,
            ),
          ),
        ),
      )
    );
  }
}
