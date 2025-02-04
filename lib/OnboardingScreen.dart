import 'package:cyber_security_app/screens/login_or_signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// OnboardingPage widget'ınızın tanımı burada olmalı veya ayrı bir dosyada tanımlanmalıdır.

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    // Animasyon kontrolcüsü
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Sayfa oluşturma
  List<Widget> _buildPages() {
    return [
      // Onboarding sayfaları
      OnboardingPage(
        image: 'images/resim1.png',
        title: AppLocalizations.of(context)!.learnAnytimeTitle,
        description: AppLocalizations.of(context)!.learnAnytimeDescription,
      ),
      OnboardingPage(
        image: 'images/resim2.png',
        title: AppLocalizations.of(context)!.trackProgressTitle,
        description: AppLocalizations.of(context)!.trackProgressDescription,
      ),
      OnboardingPage(
        image: 'images/resim3.png',
        title: AppLocalizations.of(context)!.joinCommunityTitle,
        description: AppLocalizations.of(context)!.joinCommunityDescription,
      ),
    ];
  }

  // Onboarding işlemleri
  void _onNextPressed() async {
    // Butona basıldığında animasyon başlatılır
    await _animationController.forward();
    await _animationController.reverse();

    if (_currentIndex == _buildPages().length - 1) {
      print(AppLocalizations.of(context));
      // Son sayfadaysa Login veya Signup ekranına geçiş yap
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginSignupScreen()),
      );
    } else {
      _controller.nextPage(
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sayfa sayısını kontrol etmek için sayfa listesi
    final pages = _buildPages();
    double progress = (_currentIndex + 1) / pages.length;

    return WillPopScope(
      onWillPop: () async => false, // Cihazın geri butonunu devre dışı bırak
      child: Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: pages,
            ),
            // Onboarding sayfaları için buton ve ilerleme göstergesi

            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Dairesel ilerleme göstergesi
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 6,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                        backgroundColor: Colors.grey[300],
                      ),
                    ),
                    // İleri ok butonu
                    GestureDetector(
                      onTap: _onNextPressed,
                      onTapDown: (_) {
                        _animationController.forward();
                      },
                      onTapUp: (_) {
                        _animationController.reverse();
                      },
                      onTapCancel: () {
                        _animationController.reverse();
                      },
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 1.0, end: 0.9)
                            .animate(_animationController),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            _currentIndex == pages.length - 1
                                ? Icons.check
                                : Icons.arrow_forward,
                            color: Colors.blue,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// OnboardingPage widget'ı
class OnboardingPage extends StatefulWidget {
  final String image;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animasyon kontrolcüsü
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    // Kayma animasyonu
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Opaklık animasyonu
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    // Animasyonu başlat
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant OnboardingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Her sayfa güncellendiğinde animasyonu yeniden başlat
    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Image.asset(widget.image, height: 250),
            ),
          ),
          SizedBox(height: 30),
          SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                widget.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 20),
          SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                widget.description,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
