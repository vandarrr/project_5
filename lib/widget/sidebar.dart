import 'package:flutter/material.dart';
import '../ui/beranda.dart';
import '../ui/login.dart';
import '../ui/lamaran_page.dart'; // ✅ import LamaranPage

class Sidebar extends StatelessWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEEF2F3), // abu muda
              Color(0xFFD9E4F5), // biru lembut
              Color(0xFFB9C8E7), // ungu muda lembut
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF7C8CFB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Color(0xFF6C63FF)),
              ),
              accountName: Text(
                "Admin",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              accountEmail: Text(
                "admin@admin.com",
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),

            // Menu Items
            _buildMenuItem(
              context,
              icon: Icons.home,
              text: "Beranda",
              page: Beranda(),
            ),
            _buildMenuItem(context, icon: Icons.chat, text: "Chat"),

            // ✅ Klik "Lamaran" -> ke LamaranPage
            _buildMenuItem(
              context,
              icon: Icons.bookmark,
              text: "My Activity",
              page: LamaranPage(
                selectedTab: "applied",
              ), // otomatis ke tab Applied
            ),

            _buildMenuItem(
              context,
              icon: Icons.account_circle_outlined,
              text: "Profile",
            ),

            const Divider(thickness: 1, indent: 15, endIndent: 15),

            _buildMenuItem(
              context,
              icon: Icons.logout_rounded,
              text: "Keluar",
              textColor: Colors.red,
              iconColor: Colors.red,
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    Widget? page,
    Color? iconColor,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.grey.shade800),
      title: Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.black87,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap:
          onTap ??
          () {
            if (page != null) {
              Navigator.pop(context); // ✅ tutup drawer dulu
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => page),
              );
            }
          },
    );
  }
}
