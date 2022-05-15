import 'package:flutter/material.dart';
import 'package:shoping_online/widgets/current_page.dart';
import 'package:shoping_online/widgets/out_boarding.dart';

class OutBoardingScreen extends StatefulWidget {
  const OutBoardingScreen({Key? key}) : super(key: key);

  @override
  _OutBoardingScreenState createState() => _OutBoardingScreenState();
}

class _OutBoardingScreenState extends State<OutBoardingScreen> with SingleTickerProviderStateMixin {
  int _currentPage = 0;
  bool selected = false;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              scrollDirection: Axis.horizontal,
              children: [
                OutBoarding(
                  image: 'images/page_view_1.png',
                  title: 'Online Shopping',
                  subTitle:
                      'Online shopping dolor amet consectetur\n adipiscing elit lectus blandit ut.',
                ),
                OutBoarding(
                  image: 'images/page_view_2.png',
                  title: 'Secure Payment',
                  subTitle:
                      'Online shopping dolor amet consectetur\n adipiscing elit lectus blandit ut.',
                ),
                OutBoarding(
                  image: 'images/page_view_3.png',
                  title: 'Quick Delivery',
                  subTitle:
                      'Online shopping dolor amet consectetur\n adipiscing elit lectus blandit ut.',
                ),
              ],
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.deepOrange,
            radius: 28,
            child: ElevatedButton(
              onPressed: () {
                if(_currentPage == 2){
                  Navigator.pushReplacementNamed(context, '/sign_in_screen');
                }else{
                  _pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.easeInOut);
                }
              },
              child: Center(child: Icon(Icons.arrow_forward, size: 25,)),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                primary: Colors.deepOrange,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CurrentPage(selected: _currentPage == 0),
              SizedBox(width: 10),
              CurrentPage(selected: _currentPage == 1),
              SizedBox(width: 10),
              CurrentPage(selected: _currentPage == 2),
            ],
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
