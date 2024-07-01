import 'dart:async';

import 'package:flutter/material.dart';
import 'package:perfumes_app/core/constants/colors.dart';
import 'package:perfumes_app/core/state_management/user_session.dart';
import 'package:perfumes_app/view/screens/item_screen.dart';
import 'package:perfumes_app/view/screens/login_screen.dart';
import 'package:perfumes_app/view/screens/profile_screen.dart';
import 'package:perfumes_app/view/screens/purchase_screen.dart';
import 'package:perfumes_app/view/widgets/categories_images.dart';
import 'package:perfumes_app/view/widgets/category_widget.dart';
import 'package:perfumes_app/view_model/authentication.dart';
import 'package:perfumes_app/view_model/categories_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;

  final List<String> imageUrls = [
    'assets/images/ads1.png',
    'assets/images/ads2.png',
    'assets/images/ads3.png',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoPlay();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < imageUrls.length - 1) {
        setState(() {
          _currentPage++;
        });
      } else {
        setState(() {
          _currentPage = 0;
        });
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      height: isActive ? 10.0 : 8.0,
      width: isActive ? 10.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? const Color(0XCDa4455c) : Colors.grey,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
    );
  }

  void _logout() async {
    await AuthService.logout();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
    await UserSessionManager.clearUserSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(
            fontFamily: 'LibreRegular',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyPurchasedScreen(),
                ),
              );
            },
            icon: Icon(
              Icons.shopping_cart,
              color: log1,
            ),
          ),
        ],
        iconTheme: IconThemeData(
          color: log1,
        ),
      ),
      drawer: Drawer(
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
              onTap: _logout,
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
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Center(
                child: CircularProgressIndicator(
              color: log1,
            ));
          }

          if (viewModel.categories == null) {
            return const Center(
                child: Text(
              "No data available",
              style: TextStyle(
                fontFamily: 'LibreRegular',
              ),
            ));
          }

          return SingleChildScrollView(
              child: Column(
            children: [
              SizedBox(
                height: 200,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          imageUrls[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < imageUrls.length; i++)
                    if (i == _currentPage) ...[_buildIndicator(true)] else
                      _buildIndicator(false),
                ],
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                ),
                itemCount: viewModel.categories!.length,
                itemBuilder: (BuildContext context, int index) {
                  final category =
                      viewModel.categories!.values.elementAt(index);

                  return CategoryCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ItemsScreen(category: category),
                          ),
                        );
                      },
                      image: category.image,
                      name: category.name);
                },
              ),
            ],
          ));
        },
      ),
      floatingActionButton: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: FloatingActionButton(
          backgroundColor: log1,
          onPressed: () {
            context.read<CategoryProvider>().fetchCategories();
          },
          child: const Icon(
            Icons.refresh,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
