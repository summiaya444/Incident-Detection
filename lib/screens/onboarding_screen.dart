import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:incident_reporting_app/screens/auth/login_screen.dart';
import 'package:incident_reporting_app/screens/role_selection_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:incident_reporting_app/constants/route_names.dart';
import 'package:incident_reporting_app/services/navigation_service.dart';

class OnboardingScreen extends StatefulWidget {
  final Function(bool) toggleTheme;
  const OnboardingScreen({super.key, required this.toggleTheme});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> onboardingData = [
    {
      'title': 'Report Emergencies',
      'description':
          'Quickly report any emergency situation with photos and location data',
      'image': 'assets/images/onboard_1.png',
      'color': Colors.blue,
    },
    {
      'title': 'Real-time Tracking',
      'description':
          'Track emergency response teams in real-time as they come to assist',
      'image': 'assets/images/onboard_2.png',
      'color': Colors.green,
    },
    {
      'title': 'Multiple Departments',
      'description':
          'Connect with police, fire, medical, and other emergency services',
      'image': 'assets/images/onboard_3.png',
      'color': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingData.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingPage(
                title: onboardingData[index]['title']!,
                description: onboardingData[index]['description']!,
                image: onboardingData[index]['image']!,
                color: onboardingData[index]['color']!,
              );
            },
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: onboardingData.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: Theme.of(context).colorScheme.primary,
                    dotColor: Colors.grey.shade400,
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 8,
                  ),
                ),
                const SizedBox(height: 30),
                if (_currentPage == onboardingData.length - 1)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      NavigationService.navigateWithReplacement(
                          RouteNames.login);
                    },
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ).animate().fadeIn(duration: 500.ms).scale(),
                if (_currentPage != onboardingData.length - 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoleSelectionScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: 500.ms,
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: Icon(
                Theme.of(context).brightness == Brightness.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
                color: Colors.white,
              ),
              onPressed: () {
                widget.toggleTheme(
                  Theme.of(context).brightness == Brightness.light,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final Color color;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: 300,
            )
                .animate()
                .fadeIn(duration: 500.ms)
                .scale()
                .then(delay: 200.ms)
                .shake(),
            const SizedBox(height: 40),
            Text(
              title,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.5, end: 0),
            const SizedBox(height: 16),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.5, end: 0),
          ],
        ),
      ),
    );
  }
}
