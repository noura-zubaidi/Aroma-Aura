import 'package:flutter/material.dart';
import 'package:perfumes_app/core/constants/ads_images.dart';
import 'package:perfumes_app/core/constants/colors.dart';
import 'package:perfumes_app/data/auth_helpers.dart';
import 'package:perfumes_app/view/screens/item_screen.dart';
import 'package:perfumes_app/view/screens/purchase_screen.dart';
import 'package:perfumes_app/view/widgets/category_widget.dart';
import 'package:perfumes_app/view/widgets/custom_drawer.dart';
import 'package:perfumes_app/view/widgets/indicator_widget.dart';
import 'package:perfumes_app/view_model/authentication.dart';
import 'package:perfumes_app/view_model/categories_provider.dart';
import 'package:perfumes_app/view_model/indicator_logic.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    startAutoPlay(_pageController, _currentPage, (int page) {
      setState(() {
        _currentPage = page;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
      drawer: AppDrawer(
        onLogout: () => logout(context),
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
                    Indicator(isActive: i == _currentPage),
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
