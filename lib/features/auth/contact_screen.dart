import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  // --------------------------------------------------
  // CONTACTS
  // --------------------------------------------------

  static const String phoneNumber1 = "+2250716667205";
  static const String phoneNumber2 = "+2250768676958";

  static const String whatsappNumber = "2250768676958";

  static const String emailAddress = "iplus.ci26@gmail.com";

  // --------------------------------------------------
  // APPELER
  // --------------------------------------------------

  Future<void> _call(String phoneNumber) async {
    final Uri uri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  // --------------------------------------------------
  // WHATSAPP
  // --------------------------------------------------

  Future<void> _openWhatsApp() async {
    final Uri uri = Uri.parse(
      "https://wa.me/$whatsappNumber",
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  // --------------------------------------------------
  // EMAIL
  // --------------------------------------------------

  Future<void> _sendEmail() async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: emailAddress,
      queryParameters: {
        'subject': 'Contact BabiSchool',
      },
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  // --------------------------------------------------
  // CONTACT ITEM
  // --------------------------------------------------

  Widget _contactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              blurRadius: 15,
              color: Colors.black12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xff6214BE).withOpacity(0.10),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: const Color(0xff6214BE),
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // BUILD
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

      appBar: AppBar(
        backgroundColor: const Color(0xff6214BE),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Nous contacter",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // --------------------------------------------------
              // HEADER
              // --------------------------------------------------

              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xff6214BE).withOpacity(0.10),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.support_agent,
                    color: Color(0xff6214BE),
                    size: 40,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Center(
                child: Text(
                  "Besoin d'aide ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Center(
                child: Text(
                  "Notre équipe est disponible pour "
                  "répondre à vos questions.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // --------------------------------------------------
              // CONTACT 1
              // --------------------------------------------------

              _contactItem(
                icon: Icons.phone_outlined,
                title: "Appeler",
                subtitle: "07 16 66 72 05",
                onTap: () => _call(phoneNumber1),
              ),

              const SizedBox(height: 16),

              // --------------------------------------------------
              // CONTACT 2
              // --------------------------------------------------

              _contactItem(
                icon: Icons.phone_outlined,
                title: "Appeler",
                subtitle: "07 68 67 69 58",
                onTap: () => _call(phoneNumber2),
              ),

              const SizedBox(height: 16),

              // --------------------------------------------------
              // WHATSAPP
              // --------------------------------------------------

              _contactItem(
                icon: Icons.chat_outlined,
                title: "WhatsApp",
                subtitle: "Nous écrire sur WhatsApp",
                onTap: _openWhatsApp,
              ),

              const SizedBox(height: 16),

              // --------------------------------------------------
              // EMAIL
              // --------------------------------------------------

              _contactItem(
                icon: Icons.email_outlined,
                title: "Email",
                subtitle: emailAddress,
                onTap: _sendEmail,
              ),

              const SizedBox(height: 30),

              Center(
                child: Text(
                  "BabiSchool",
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}