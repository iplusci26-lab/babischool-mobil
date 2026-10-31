import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/profile_model.dart';
import '../services/profile_service.dart';
import 'edit_profile_screen.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_tile.dart';
import 'change_password_screen.dart';
import '../../auth/services/auth_service.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../core/theme/app_colors.dart';
import 'help_support_screen.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../auth/models/school_access_model.dart';
import '../../auth/select_context_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {
    final ProfileService service =
        ProfileService();
    
    final ImagePicker picker =
      ImagePicker();

    ProfileModel? profile;

    bool loading = true;
    List<SchoolAccessModel> availableAccesses = [];

    String? activeSchoolName;
    String? activeRoleName;

  @override
  void initState() {
    super.initState();

    loadProfile();
    loadAvailableAccesses();
  }

  Future<void> loadAvailableAccesses() async {
    final storedAccesses =
        await SecureStorageService.getAvailableAccesses();

    final schoolName =
        await SecureStorageService.getActiveSchoolName();

    final roleName =
        await SecureStorageService.getActiveRoleName();

    if (!mounted) return;

    setState(() {
      availableAccesses = storedAccesses
          .map((item) => SchoolAccessModel.fromJson(item))
          .toList();

      activeSchoolName = schoolName;
      activeRoleName = roleName;
    });
  }

  void openContextSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SelectContextScreen(
          accesses: availableAccesses,
          isSwitching: true,
        ),
      ),
    );
  }

  Future<void> loadProfile() async {
    try {
      final data =
          await service.getProfile();

      setState(() {
        profile = data;
      });
      
    } catch (_) {
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> pickAvatar()
    async {

      final XFile? image =
          await picker.pickImage(
        source:
            ImageSource.gallery,
      );

      if (image == null) {
        return;
      }

      await service.uploadAvatar(
        File(image.path),
      );

      await loadProfile();
    }

  @override
  Widget build(
    BuildContext context,
  ) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

   return Scaffold(
  backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              const AppHeader(
                title: "Mon profil",
                subtitle: "Gérez votre compte et vos préférences",
              ),

              const SizedBox(height: 28),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [

                    /// HEADER
                    ProfileHeader(
                      profile: profile!,
                      onEditAvatar: pickAvatar,
                    ),

                    const SizedBox(height: 24),

                    if (availableAccesses.length > 1) ...[
                      _buildTile(
                        icon: Icons.swap_horiz,
                        title: "Changer d'établissement / rôle",
                        onTap: openContextSelection,
                      ),

                      if (activeSchoolName != null && activeRoleName != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 16,
                            left: 8,
                            right: 8,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Espace actuel : $activeSchoolName • $activeRoleName",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                    ],

                    _buildTile(
                      icon: Icons.person_outline,
                      title: "Informations personnelles",
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProfileScreen(
                              profile: profile!,
                            ),
                          ),
                        );

                        if (result == true) {
                          loadProfile();
                        }
                      },
                    ),

                    _buildTile(
                      icon: Icons.lock_outline,
                      title: "Changer le mot de passe",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const ChangePasswordScreen(),
                          ),
                        );
                      },
                    ),

                    _buildTile(
                      icon: Icons.notifications_outlined,
                      title: "Notifications",
                      onTap: () {},
                    ),

                    _buildTile(
                      icon: Icons.help_outline,
                      title: "Aide & Support",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HelpSupportScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                        onPressed: () async {
                          final confirm =
                              await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Déconnexion"),
                              content: const Text(
                                "Voulez-vous vraiment vous déconnecter ?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(
                                    context,
                                    false,
                                  ),
                                  child: const Text("Annuler"),
                                ),
                                FilledButton(
                                  onPressed: () =>
                                      Navigator.pop(
                                    context,
                                    true,
                                  ),
                                  child:
                                      const Text("Déconnexion"),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await AuthService.logout(
                              context,
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Déconnexion",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(

    padding: const EdgeInsets.only(
      bottom: 12,
    ),

    child: Material(

      color: Colors.white,

      elevation: 1,

      borderRadius: BorderRadius.circular(
        18,
      ),

      clipBehavior: Clip.antiAlias,

      child: ListTile(

        onTap: onTap,

        contentPadding: const EdgeInsets.symmetric(

          horizontal: 20,

          vertical: 4,

        ),

        leading: Icon(

          icon,

          color: const Color(
            0xff6214BE,
          ),

        ),

        title: Text(

          title,

          style: const TextStyle(

            fontWeight: FontWeight.w600,

          ),

        ),

        trailing: const Icon(

          Icons.chevron_right,

        ),

      ),

    ),

  );
  }
}