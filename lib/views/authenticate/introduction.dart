import 'package:flutter/material.dart';
import 'package:only_job/views/constants/constants.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
        actions: [
          TextButton(
            onPressed: () {
              _pageController.jumpToPage(2);
            },
            child: Text(
              'Skip',
              style: TextStyle(color: accent1, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    SwipePage(
                      'System Introduction',
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                    ),
                    SwipePage(
                      'System Features',
                      'Pellentesque ac bibendum velit, eu interdum enim.',
                    ),
                    SwipePage(
                      'Get Started',
                      'Quisque consequat ipsum at dui convallis, id dapibus est fermentum.',
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: dotIndicator(),
          ),
          if (_currentPage == 2)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => NextScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                  foregroundColor: Colors.white,
                  backgroundColor: accent1,
                ),
                child: Text('Get Started'),
              ),
            ),
        ],
      ),
    );
  }

  Widget SwipePage(String title, String description) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            description,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget dotIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 12 : 8,
          height: _currentPage == index ? 12 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? accent1 : Colors.grey,
          ),
        );
      }),
    );
  }
}

class NextScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next Screen'),
      ),
      body: Center(
        child: Text('Welcome to the next screen!'),
      ),
    );
  }
}
