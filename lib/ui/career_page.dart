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

  bool isSearching = false;
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E2F),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),

        title: isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Search videos...",
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              )
            : const Text(
                "Career",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

        actions: [
          isSearching
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                      searchQuery = "";
                      _searchController.clear();
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      isSearching = true;
                    });
                  },
                ),

          const SizedBox(width: 10),
        ],
      ),

      body: Column(
        children: [
          // Hide TabBar during search
          if (!isSearching)
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
              children: [
                TipsCareerTab(searchQuery: searchQuery),
                SkillsTab(searchQuery: searchQuery),
                SoftSkillsTab(searchQuery: searchQuery),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
