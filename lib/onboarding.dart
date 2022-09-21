import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Greengrass Provisioning Wizard'),
          actions: [
            if (_currentPage == 0)
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings),
              ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.only(bottom: 80),
          child: PageView(
            controller: _controller,
            children: [
              buildPage(
                  urlImage: 'TestImg.png',
                  title: 'SECURE',
                  subtitle:
                      'Create the security stack. ESF bla bla bla EST bla bla bla Grengrass bla bla bla'),
              buildPage(
                  urlImage: 'TestImg.png',
                  title: 'ENROLL',
                  subtitle:
                      'Create the security stack. ESF bla bla bla EST bla bla bla Grengrass bla bla bla'),
              buildPage(
                  urlImage: 'TestImg.png',
                  title: 'CONNECT',
                  subtitle:
                      'Create the security stack. ESF bla bla bla EST bla bla bla Grengrass bla bla bla'),
            ],
          ),
        ),
        bottomSheet: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => setState(() {
                  _currentPage = 0;
                  _controller.jumpToPage(0);
                }),
                child: const Text('RESTART'),
              ),
              Center(
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                ),
              ),
              TextButton(
                onPressed: () => setState(() {
                  _currentPage += 1;
                  _controller.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                }),
                child: const Text('NEXT'),
              ),
            ],
          ),
        ),
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildPage({
    required String urlImage,
    required String title,
    required String subtitle,
  }) =>
      Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            urlImage,
            fit: BoxFit.fitHeight,
            width: 140,
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ),
        ]),
      );
}
