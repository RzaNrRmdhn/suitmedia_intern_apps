import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intern_apps/model/model_user.dart';
import 'package:intern_apps/service/api_service.dart';

class ThirdScreen extends StatefulWidget {
  final String name;
  const ThirdScreen({required this.name, Key? key}) : super(key: key);

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  final ApiService apiService = ApiService();
  late List<User> users = [];
  bool isLoading = false;
  bool isRefreshing = false;
  late String username;
  int currentPage = 1;
  late String name;

  @override
  void initState() {
    super.initState();
    users = [];
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    final List<User> newData = await apiService.getUsers(Page: currentPage);

    setState(() {
      users.addAll(newData);
      isLoading = false;
      currentPage++;
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      users = [];
      currentPage = 1;
    });
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.2),
                  Text(
                    'Third Screen',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                ],
              ),
              const Divider(
                color: Colors.grey,
              ),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.8,
                child: RefreshIndicator(
                  onRefresh: _refreshData,
                  child: ListView.builder(
                    itemCount: users.length + 1,
                    itemBuilder: (context, index) {
                      if (index < users.length) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                username =
                                    '${users[index].firstName} ${users[index].lastName}';
                                name = widget.name;
                                Navigator.pushNamed(context, '/SecondScreen',
                                    arguments: {
                                      'user': username,
                                      'name': name
                                    });
                              },
                              child: ListTile(
                                title: Text(
                                    '${users[index].firstName} ${users[index].lastName}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        fontSize: 18)),
                                subtitle: Text(users[index].email),
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(users[index].avatar),
                                ),
                              ),
                            ),
                            const Divider()
                          ],
                        );
                      } else if (isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (isRefreshing) {
                        return const SizedBox(); // Return an empty container during pull to refresh
                      } else {
                        return const Center(
                          child: Text('No more users'),
                        );
                      }
                    },
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: ScrollController()
                      ..addListener(_scrollListener),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _scrollListener() {
    if (isLoading || isRefreshing) return;

    final maxScroll = _getMaxScroll();
    final currentScroll = _getCurrentScroll();

    if (currentScroll >= maxScroll) {
      _loadData();
    }
  }

  double _getMaxScroll() {
    return (context.size?.height ?? 0) -
        500; // Adjust this value based on your UI
  }

  double _getCurrentScroll() {
    final position =
        (context.findRenderObject() as RenderBox).localToGlobal(Offset.zero);
    return position.dy;
  }
}
