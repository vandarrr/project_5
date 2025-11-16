import 'package:flutter/material.dart';
import 'skills_tab.dart';
import 'tips_career_tab.dart';
import 'soft_skills_tab.dart';

class CareerPage extends StatefulWidget {
  const CareerPage({Key? key}) : super(key: key);

  @override
  _CareerPageState createState() => _CareerPageState();
}

class _CareerPageState extends State<CareerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E2F),
        elevation: 0,
        title: const Text(
          "Career",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: const [
          Icon(Icons.search, color: Colors.white),
          SizedBox(width: 15),
          Icon(Icons.notifications_none, color: Colors.white),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF0A0E2F),
              labelColor: const Color(0xFF0A0E2F),
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: "Tips Career"),
                Tab(text: "Skills"),
                Tab(text: "Soft Skills"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [TipsCareerTab(), SkillsTab(), SoftSkillsTab()],
            ),
          ),
        ],
      ),
    );
  }
}
