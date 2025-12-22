import 'package:flutter/material.dart';
import '../register/register_page.dart';
// ================== COLORS ==================
const Color chocolate = Color(0xFFC98434);
const Color lightGrey = Color(0xFFF2F2F2);

// ================== INTRO PAGE ==================
class IntroFlowPage extends StatefulWidget {
  const IntroFlowPage({super.key});

  @override
  State<IntroFlowPage> createState() => _IntroFlowPageState();
}

class _IntroFlowPageState extends State<IntroFlowPage> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<_IntroData> pages = [
    _IntroData(
      images: [
        "assets/images/intro3.png",
        "assets/images/intro5.png",
        "assets/images/intro4.png",
      ],
      titles: [
        "Produits de qualité",
        "Etre fier(e) de sa peau",
        "Rayonner de milles feux",
      ],
      subtitles: [
        "Des soins conçus avec des ingrédients sûrs pour une peau saine.",
        "Valoriser et se sentir bien dans sa peau",
        "Briller",
      ],
    ),
    _IntroData(
      images: ["assets/images/gemini1.png"],
      titles: ["Achat Facile"],
      subtitles: ["Faites vos commandes facilement"],
    ),
    _IntroData(
      images: ["assets/images/gemini2.png"],
      titles: ["Livraison rapide"],
      subtitles: ["Recevez vos produits en toute sécurité et à temps."],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // LOGO
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Image.asset(
                "assets/images/logo_orina.png",
                height: 70,
              ),
            ),

            const SizedBox(height: 16),

            // PAGEVIEW
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() => currentPage = index);
                },
                itemBuilder: (context, index) {
                  return _AnimatedIntroPage(data: pages[index]);
                },
              ),
            ),

            // INDICATORS
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (index) => _indicatorDot(index == currentPage),
                ),
              ),
            ),

            // BUTTON
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              color: lightGrey,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: chocolate,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (currentPage < pages.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                    );
                  } else {
                    //  PAGE INSCRIPTION
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RegisterPage(),
                      ),
                    );
                  }
                },
                child: Text(
                  currentPage == pages.length - 1
                      ? "Commencer"
                      : "Suivant",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _indicatorDot(bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: active ? 18 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? chocolate : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

// ================== ANIMATED PAGE ==================
class _AnimatedIntroPage extends StatefulWidget {
  final _IntroData data;
  const _AnimatedIntroPage({required this.data});

  @override
  State<_AnimatedIntroPage> createState() => _AnimatedIntroPageState();
}

class _AnimatedIntroPageState extends State<_AnimatedIntroPage>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      widget.data.images.length,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      ),
    );

    _animations = _controllers
        .map(
          (c) => CurvedAnimation(
            parent: c,
            curve: Curves.easeOutCubic,
          ),
        )
        .toList();

    _playSequential();
  }

  Future<void> _playSequential() async {
    for (var controller in _controllers) {
      await controller.forward();
      await Future.delayed(const Duration(milliseconds: 250));
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isFirstPage = widget.data.images.length > 1;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: List.generate(widget.data.images.length, (index) {
            final double ladderOffset =
                isFirstPage ? index * 24.0 : 0;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: AnimatedBuilder(
                animation: _animations[index],
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(ladderOffset, 0),
                    child: ScaleTransition(
                      scale: _animations[index],
                      child: FadeTransition(
                        opacity: _animations[index],
                        child: child,
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Image.asset(
                      widget.data.images[index],
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.data.titles[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.data.subtitles[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ================== DATA MODEL ==================
class _IntroData {
  final List<String> images;
  final List<String> titles;
  final List<String> subtitles;

  _IntroData({
    required this.images,
    required this.titles,
    required this.subtitles,
  });
}


