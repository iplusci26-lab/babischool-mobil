import 'package:flutter/material.dart';

import '../../auth/contact_screen.dart';

import 'help_center_screen.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

      appBar: AppBar(
        backgroundColor: const Color(0xff6214BE),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Aide & Support",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // --------------------------------------------------
              // INTRODUCTION
              // --------------------------------------------------

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),

                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff6214BE),
                      Color(0xff8D4EF7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),

                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Icon(
                      Icons.support_agent,
                      color: Colors.white,
                      size: 36,
                    ),

                    SizedBox(height: 14),

                    Text(
                      "Comment pouvons-nous vous aider ?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      "Retrouvez les informations utiles "
                      "et les moyens de contacter notre équipe.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // --------------------------------------------------
              // BESOIN D'AIDE
              // --------------------------------------------------

              Text(
                "Besoin d'aide",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),

              const SizedBox(height: 12),

              // --------------------------------------------------
              // CENTRE D'AIDE
              // --------------------------------------------------

              _buildTile(
                context: context,
                icon: Icons.help_outline,
                title: "Centre d'aide",
                subtitle:
                    "Consultez les réponses aux questions fréquentes.",
                onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const HelpCenterScreen(),
                    ),
                    );
                },
                ),

              const SizedBox(height: 12),

              // --------------------------------------------------
              // NOUS CONTACTER
              // --------------------------------------------------

              _buildTile(
                context: context,
                icon: Icons.headset_mic_outlined,
                title: "Nous contacter",
                subtitle:
                    "Appelez-nous, écrivez-nous sur WhatsApp ou par email.",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ContactScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 28),

              // --------------------------------------------------
              // INFORMATIONS
              // --------------------------------------------------

              Text(
                "Informations",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),

              const SizedBox(height: 12),

              // --------------------------------------------------
              // À PROPOS DE BABISCHOOL
              // --------------------------------------------------

              _buildTile(
                context: context,
                icon: Icons.info_outline,
                title: "À propos de BabiSchool",
                subtitle:
                    "Informations sur l'application.",
                onTap: () {
                  _showAboutDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // POPUP À PROPOS
  // --------------------------------------------------

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),

          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // --------------------------------------------------
                // ICÔNE
                // --------------------------------------------------

                Container(
                  width: 72,
                  height: 72,

                  decoration: BoxDecoration(
                    color: const Color(0xff6214BE),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: const Icon(
                    Icons.school_outlined,
                    color: Colors.white,
                    size: 38,
                  ),
                ),

                const SizedBox(height: 18),

                // --------------------------------------------------
                // NOM
                // --------------------------------------------------

                const Text(
                  "BabiSchool",
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff6214BE),
                  ),
                ),

                const SizedBox(height: 6),

                // --------------------------------------------------
                // VERSION
                // --------------------------------------------------

                Text(
                  "Version 1.0.0",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 20),

                // --------------------------------------------------
                // DESCRIPTION
                // --------------------------------------------------

                Text(
                  "BabiSchool est une plateforme destinée "
                  "aux écoles partenaires, aux parents, "
                  "et aux enseignants.",
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),

                // --------------------------------------------------
                // BOUTON FERMER
                // --------------------------------------------------

                SizedBox(
                  width: double.infinity,

                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },

                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xff6214BE),
                      foregroundColor: Colors.white,

                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    child: const Text(
                      "Fermer",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --------------------------------------------------
  // TILE
  // --------------------------------------------------

  Widget _buildTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      elevation: 1,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,

      child: ListTile(
        onTap: onTap,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 8,
        ),

        leading: Container(
          width: 48,
          height: 48,

          decoration: BoxDecoration(
            color: const Color(0xff6214BE).withOpacity(0.10),
            borderRadius: BorderRadius.circular(14),
          ),

          child: Icon(
            icon,
            color: const Color(0xff6214BE),
          ),
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              height: 1.3,
            ),
          ),
        ),

        trailing: const Icon(
          Icons.chevron_right,
        ),
      ),
    );
  }
}