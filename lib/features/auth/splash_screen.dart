import 'package:flutter/material.dart';

import '../../core/storage/secure_storage_service.dart';

import '../../shared/shells/staff/staff_shell.dart';

import '../../shared/shells/teacher/teacher_shell.dart';

import '../../core/notifications/notification_service.dart';

import 'package:babischool_mobile/shared/shells/parent/parent_shell.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();

}

class _SplashScreenState
    extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late final AnimationController _controller;

  late final Animation<double> _scaleAnimation;

  String status =
      "Initialisation...";

  @override
  void initState() {

    super.initState();

    _controller = AnimationController(

      vsync: this,

      duration: const Duration(
        seconds: 2,
      ),

    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(

      begin: .95,

      end: 1.05,

    ).animate(

      CurvedAnimation(

        parent: _controller,

        curve: Curves.easeInOut,

      ),

    );

    initialize();

  }

  //--------------------------------------------------

  Future<void> initialize() async {

    await Future.delayed(

      const Duration(
        milliseconds: 700,
      ),

    );

    if (!mounted) return;

    setState(() {

      status =
          "Vérification de votre session...";

    });

    final hasSession =
        await SecureStorageService.hasSession();

    if (!hasSession) {

      navigate(

        const LoginScreen(),

      );

      return;

    }
    //--------------------------------------------------
    // ENREGISTREMENT DE L'APPAREIL
    //--------------------------------------------------

    
      if (!mounted) return;

      setState(() {
        status = "Activation des notifications...";
      });

      try {

        await NotificationService.instance.registerDevice();

      } catch (e) {

        debugPrint(
          "Notification registration error : $e",
        );

      }


    await Future.delayed(

      const Duration(
        milliseconds: 600,
      ),

    );

    final user =
        await SecureStorageService.getUser();

    final role =
        await SecureStorageService.getUserType();

    if (!mounted) return;

    final firstName =
        user?["first_name"] ?? "";

    setState(() {

      status =
          "Bienvenue $firstName 👋";

    });

    await Future.delayed(

      const Duration(
        milliseconds: 900,
      ),

    );

    switch (role) {

      case "teacher":

        setState(() {

          status =
              "Chargement de votre espace Enseignant...";

        });

        await Future.delayed(

          const Duration(
            milliseconds: 700,
          ),

        );

        navigate(

          const TeacherShell(),

        );

        break;

      case "admin":

      case "staff":

        setState(() {

          status =
              "Chargement de votre espace Administratif...";

        });

        await Future.delayed(

          const Duration(
            milliseconds: 700,
          ),

        );

        navigate(

          const StaffShell(),

        );

        break;

      default:

        setState(() {

          status =
              "Chargement de votre espace Parent...";

        });

        await Future.delayed(

          const Duration(
            milliseconds: 700,
          ),

        );

        navigate(

          ParentShell(
            key: parentShellKey,
          ),

        );

    }

  }

  //--------------------------------------------------

  void navigate(
    Widget page,
  ) {

    if (!mounted) return;

    Navigator.pushReplacement(

      context,

      MaterialPageRoute(

        builder: (_) => page,

      ),

    );

  }

  //--------------------------------------------------

  @override
  void dispose() {

    _controller.dispose();

    super.dispose();

  }

  //--------------------------------------------------

  @override
  Widget build(
    BuildContext context,
  ) {

    return Scaffold(

      body: Container(

        decoration: const BoxDecoration(

          gradient: LinearGradient(

            begin: Alignment.topCenter,

            end: Alignment.bottomCenter,

            colors: [

              Color(0xff6214BE),

              Color(0xff8B53F8),

              Color(0xffF7F8FC),

            ],

            stops: [

              0,

              .45,

              1,

            ],

          ),

        ),

        child: SafeArea(

          child: Center(

            child: Padding(

              padding:
                  const EdgeInsets.all(30),

              child: Column(

                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [

                  AnimatedBuilder(

                    animation:
                        _scaleAnimation,

                    builder: (

                      context,

                      child,

                    ) {

                      return Transform.scale(

                        scale:
                            _scaleAnimation.value,

                        child: child,

                      );

                    },

                    child: Container(
                        height: 140,
                        width: 140,
                        decoration: BoxDecoration(
                          color: Color(0xff6214BE),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 30,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          "assets/images/babischool_logo.png",
                          fit: BoxFit.cover,
                        ),
                      ),

                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  /*const Text(

                    "BABISCHOOL",

                    style: TextStyle(

                      color: Colors.white,

                      fontSize: 34,

                      fontWeight:
                          FontWeight.bold,

                      letterSpacing: 2,

                    ),

                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  const Text(

                    "La plateforme scolaire intelligente",

                    style: TextStyle(

                      color:
                          Colors.white70,

                      fontSize: 16,

                    ),

                    textAlign:
                        TextAlign.center,

                  ),*/

                  const SizedBox(
                    height: 60,
                  ),

                  AnimatedSwitcher(

                    duration:
                        const Duration(

                      milliseconds: 400,

                    ),

                    child: Text(

                      status,

                      key: ValueKey(

                        status,

                      ),

                      style:

                          const TextStyle(

                        fontSize: 18,

                        color:
                            Colors.white,

                        fontWeight:

                            FontWeight.w600,

                      ),

                      textAlign:
                          TextAlign.center,

                    ),

                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  ClipRRect(

                    borderRadius:

                        BorderRadius.circular(

                      20,

                    ),

                    child:

                        const SizedBox(

                      width: 220,

                      child:

                          LinearProgressIndicator(

                        minHeight: 7,

                        backgroundColor:

                            Colors.white24,

                        valueColor:

                            AlwaysStoppedAnimation(

                          Colors.white,

                        ),

                      ),

                    ),

                  ),

                  const SizedBox(
                    height: 80,
                  ),

                  const Text(

                    "Version 1.0.0",

                    style: TextStyle(

                      color:
                          Colors.white70,

                    ),

                  ),

                ],

              ),

            ),

          ),

        ),

      ),

    );

  }

}