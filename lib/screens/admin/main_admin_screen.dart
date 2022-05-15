import 'package:flutter/material.dart';
import 'package:shoping_online/screens/admin/orders_tab/order_tab.dart';
import 'package:shoping_online/screens/admin/orders_tab/product_tab.dart';
import 'orders_tab/category_tab.dart';

class MainAdminScreen extends StatefulWidget {
  const MainAdminScreen({Key? key}) : super(key: key);

  @override
  _MainAdminScreenState createState() => _MainAdminScreenState();
}

class _MainAdminScreenState extends State<MainAdminScreen>
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Admin'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        actions: [
          IconButton(onPressed: (){Navigator.pushNamed(context, "/profile_screen");}, icon: const Icon(Icons.person))
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(
              text: 'Category',
            ),
            Tab(
              text: 'Product',
            ),
            Tab(
              text: 'Order',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          CategoryTab(),
          ProductsScreen(),
          CompletedOrdersScreen(),
        ],
      ),
    );
  }
}
