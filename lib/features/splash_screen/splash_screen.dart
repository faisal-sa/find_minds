import 'package:flutter_svg/svg.dart';
import 'package:graduation_project/core/exports/app_exports.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainAnimationController;
  late AnimationController _pulseController;

  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<Offset> _logoSlideAnimation;

  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;

  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _checkIfLaunchedBefore();
  }

  // ================================================================= //
  // ==================  check if launched before  =================== //
  // ================================================================= //
  //
  Future<void> _checkIfLaunchedBefore() async {
    final prefs = await SharedPreferences.getInstance();
    final launchedBefore = prefs.getBool('launchedBefore') ?? false;

    // delay 4 seconds after the animation
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    if (!launchedBefore) {
      await prefs.setBool('launchedBefore', true);

      // if first time, show the intro page
      if (!mounted) return;
      context.go('/intro');
    } else {
      // if not first time, show the login page
      if (!mounted) return;
      context.go('/login');
    }

    /* 
    NOTE:
    uncomments the code below for testing or edit the onbording feature ,
    it will reset the launchedBefore value to [false] ,
    mean show the intro page every time you restart the app ,
    dont forget to comment it again after testing ,
    you need to reset the app ``times to see the changes ,
    
    -trail one will get the value [true] .
    -trail two will move to the intro page .

    */

    //==========================================
    //
    await prefs.remove('launchedBefore');
    //print('launchedBefore: $launchedBefore');
    //
    //==========================================
  }

  // ================================================================= //
  // ==================  setup animations  =========================== //
  // ================================================================= //
  //
  void _setupAnimations() {
    // Main animation controller
    _mainAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Pulse controller
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // Logo animations
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainAnimationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainAnimationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
      ),
    );

    _logoSlideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _mainAnimationController,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    // Text animations
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainAnimationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    _textSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _mainAnimationController,
            curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    // Pulse animation
    _pulseAnimation = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // start animation
    _mainAnimationController.forward();
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // ================================================================= //
  // ==================  Splash Screen UI  =========================== //
  // ================================================================= //
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Spacer(),
          AnimatedBuilder(
            animation: Listenable.merge([
              _mainAnimationController,
              _pulseController,
            ]),
            builder: (context, child) {
              return SlideTransition(
                position: _logoSlideAnimation,
                child: FadeTransition(
                  opacity: _logoFadeAnimation,
                  child: Transform.scale(
                    scale: _logoScaleAnimation.value * _pulseAnimation.value,
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/logo.svg',
                        width: 280,
                        height: 70,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const Spacer(),
          AnimatedBuilder(
            animation: _mainAnimationController,
            builder: (context, child) {
              return SlideTransition(
                position: _textSlideAnimation,
                child: FadeTransition(
                  opacity: _textFadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 60),
                    child: Text(
                      'Start Your Journey With Us',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
