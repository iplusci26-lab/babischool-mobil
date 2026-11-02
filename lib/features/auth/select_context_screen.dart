
import 'package:flutter/material.dart';

import '../../core/storage/secure_storage_service.dart';
import '../../core/notifications/notification_service.dart';
import 'models/school_access_model.dart';
import 'services/auth_service.dart';
import 'splash_screen.dart';

class SelectContextScreen extends StatefulWidget {
  final List<SchoolAccessModel> accesses;

  // Utilisés uniquement lors de la connexion initiale.
  final String phone;
  final String password;

  // true = changement de contexte pendant une session active.
  final bool isSwitching;

  const SelectContextScreen({
    super.key,
    required this.accesses,
    this.phone = '',
    this.password = '',
    this.isSwitching = false,
  });

  @override
  State<SelectContextScreen> createState() =>
      _SelectContextScreenState();
}

class _SelectContextScreenState
    extends State<SelectContextScreen> {
  bool loading = false;
  String? selectedAccessId;

  Future<void> selectAccess(SchoolAccessModel access) async {
    if (loading) return;

    setState(() {
      loading = true;
      selectedAccessId = '${access.schoolId}_${access.roleId ?? "parent"}';
    });

    try {
      final authService = AuthService();

      // =========================================
      // 1. APPEL API
      // =========================================

      final response = widget.isSwitching
          ? await authService.switchContext(access: access)
          : await authService.selectContext(
              phone: widget.phone,
              password: widget.password,
              access: access,
            );

      if (response.access == null ||
          response.refresh == null ||
          response.user == null) {
        throw Exception('Réponse serveur incomplète.');
      }

      // =========================================
      // 2. ENREGISTREMENT DU NOUVEAU CONTEXTE
      // =========================================
    await SecureStorageService.saveAvailableAccesses(
        widget.accesses.map((access) => access.toJson()).toList(),
    );
      await SecureStorageService.saveSession(
        accessToken: response.access!,
        refreshToken: response.refresh!,
        user: response.user!.toJson(),
        schoolId: access.schoolId ?? '',
        schoolName: access.schoolName,
        roleId: access.roleId ?? '',
        roleName: access.roleName,
        roleCode: access.roleCode,
      );

      // =========================================
      // 3. ENREGISTREMENT DU DEVICE TOKEN
      // =========================================

      await NotificationService.instance.registerDevice();

      if (!mounted) return;

      // =========================================
      // 4. OUVERTURE DU BON ESPACE
      // =========================================

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        ),
        (_) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Impossible de ${widget.isSwitching ? "changer de profil" : "sélectionner cet accès"} : $e',
          ),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
          selectedAccessId = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xff6214BE),
        foregroundColor: Colors.white,
        title: Text(
          widget.isSwitching
              ? 'Changer d’espace'
              : 'Choisir votre espace',
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 20),

            const Icon(
              Icons.school_outlined,
              size: 55,
              color: Color(0xff6214BE),
            ),

            const SizedBox(height: 16),

            Text(
              widget.isSwitching
                  ? 'Changer d’établissement ou de rôle'
                  : 'Plusieurs accès disponibles',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              widget.isSwitching
                  ? 'Sélectionnez le profil auquel vous souhaitez accéder.'
                  : 'Sélectionnez l’école et l’espace auxquels vous souhaitez accéder.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 30),

            if (widget.accesses.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Aucun accès disponible.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

            ...widget.accesses.map((access) {
              final id = '${access.schoolId}_${access.roleId ?? "parent"}';
              final isSelected = selectedAccessId == id;

              return Card(
                margin: const EdgeInsets.only(bottom: 14),
                elevation: 1,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),

                  leading: const CircleAvatar(
                    backgroundColor: Color(0xffF0E5FF),
                    child: Icon(
                      Icons.school,
                      color: Color(0xff6214BE),
                    ),
                  ),

                  title: Text(
                    access.schoolName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      'Espace ${access.roleName}',
                    ),
                  ),

                  trailing: loading && isSelected
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          Icons.arrow_forward_ios,
                          size: 17,
                          color: Color(0xff6214BE),
                        ),

                  onTap: loading
                      ? null
                      : () => selectAccess(access),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
