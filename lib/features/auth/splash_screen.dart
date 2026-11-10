import 'dart:async';
import 'package:flutter/material.dart';

import '../../core/storage/secure_storage_service.dart';

import '../../shared/shells/staff/staff_shell.dart';

import '../../shared/shells/teacher/teacher_shell.dart';

import '../../core/notifications/notification_service.dart';

import 'package:babischool_mobile/shared/shells/parent/parent_shell.dart';

import 'login_screen.dart';

import 'package:flutter/foundation.dart';
import 'package:in_app_update/in_app_update.dart';

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

  StreamSubscription<InstallStatus>? _updateSubscription;
  bool _updateFlowStarted = false;

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

  
Future<void> checkForAppUpdate() async {
  if (defaultTargetPlatform != TargetPlatform.android) {
    return;
  }

  try {
    final updateInfo = await InAppUpdate.checkForUpdate();

    if (!mounted) return;

    debugPrint('========== APP UPDATE ==========');
    debugPrint('Availability: ${updateInfo.updateAvailability}');
    debugPrint('Immediate allowed: ${updateInfo.immediateUpdateAllowed}');
    debugPrint('Flexible allowed: ${updateInfo.flexibleUpdateAllowed}');
    debugPrint('Available version: ${updateInfo.availableVersionCode}');
    debugPrint('================================');

    if (updateInfo.updateAvailability ==
        UpdateAvailability.developerTriggeredUpdateInProgress) {
      await InAppUpdate.performImmediateUpdate();
      return;
    }

    if (updateInfo.updateAvailability !=
        UpdateAvailability.updateAvailable) {
      return;
    }

    if (_updateFlowStarted) return;
    _updateFlowStarted = true;

    // PRIORITÉ : MISE À JOUR IMMÉDIATE
    if (updateInfo.immediateUpdateAllowed) {
      final result = await InAppUpdate.performImmediateUpdate();

      if (result != AppUpdateResult.success) {
        debugPrint('Mise à jour immédiate non terminée : $result');
      }

      return;
    }

    // ALTERNATIVE : MISE À JOUR FLEXIBLE
    if (updateInfo.flexibleUpdateAllowed) {
      _updateSubscription ??=
          InAppUpdate.installUpdateListener.listen((installStatus) async {
        debugPrint('Update status: $installStatus');

        if (installStatus == InstallStatus.downloaded && mounted) {
          try {
            debugPrint('Téléchargement terminé. Installation...');

            await InAppUpdate.completeFlexibleUpdate();

          } catch (e) {
            debugPrint('Erreur installation flexible : $e');
          }
        }

        if (installStatus == InstallStatus.failed ||
            installStatus == InstallStatus.canceled) {
          debugPrint('Téléchargement de la mise à jour interrompu.');
        }
      });

      // Le téléchargement se poursuit en arrière-plan.
      unawaited(
        InAppUpdate.startFlexibleUpdate().then((result) {
          debugPrint('Résultat téléchargement : $result');
        }).catchError((e) {
          debugPrint('Erreur téléchargement : $e');
        }),
      );
    }

  } catch (e, stackTrace) {
    debugPrint('Erreur vérification mise à jour : $e');
    debugPrintStack(stackTrace: stackTrace);
  }
}

  
    //--------------------------------------------------

  Future<void> initialize() async {



    await Future.delayed(

      const Duration(
        milliseconds: 700,
      ),

    );

    if (!mounted) return;

    await checkForAppUpdate();

    if (!mounted) return;
  //--------------------------------------------------
    setState(() {

      status =
          "Vérification de votre session...";

    });

    final hasSession =
        await SecureStorageService.hasSession();

    
    debugPrint("========== SESSION DEBUG ==========");
    debugPrint("HAS SESSION : $hasSession");

    final user = await SecureStorageService.getUser();
    final role = await SecureStorageService.getUserType();

    debugPrint("USER--- : ${user?["user_type"]}");
    debugPrint("USER TYPE : $role");
    
    debugPrint("SPLASH ROLE : ${await SecureStorageService.getUserType()}");
    debugPrint("==================================");

    if (!hasSession) {
      debugPrint("REDIRECTION : SESSION ABSENTE");

      navigate(const LoginScreen());
      return;
    }

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

    /*
    final user =
        await SecureStorageService.getUser();

    final role =
        await SecureStorageService.getUserType();*/
   

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
    switch (role?.trim().toLowerCase()) {

  case "teacher":
  case "enseignant":
    setState(() {
      status = "Chargement de votre espace Enseignant...";
    });

    await Future.delayed(const Duration(milliseconds: 700));

    navigate(const TeacherShell());
    break;

  case "admin":
  case "staff":
  case "director":
  case "educateur":
  case "censeur":
  case "econome":
    setState(() {
      status = "Chargement de votre espace Administratif...";
    });

    await Future.delayed(const Duration(milliseconds: 700));

    navigate(const StaffShell());
    break;

  case "prt":
  case "parent":
    setState(() {
      status = "Chargement de votre espace Parent...";
    });

    await Future.delayed(const Duration(milliseconds: 700));

    navigate(
      ParentShell(key: parentShellKey),
    );
    break;

  default:
    debugPrint("Rôle non reconnu : $role");

    await SecureStorageService.clear();

    navigate(const LoginScreen());
    break;
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
    
     _updateSubscription?.cancel();
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