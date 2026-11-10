
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'messaging_service.dart';

class NewConversationScreen extends StatefulWidget {
  const NewConversationScreen({super.key});

  @override
  State<NewConversationScreen> createState() =>
      _NewConversationScreenState();
}

class _NewConversationScreenState
    extends State<NewConversationScreen> {
  final MessagingService service = MessagingService();
  final TextEditingController searchController =
      TextEditingController();

  bool loading = true;
  String? error;
  List<dynamic> recipients = [];
  List<dynamic> filteredRecipients = [];

  @override
  void initState() {
    super.initState();
    loadRecipients();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadRecipients() async {
    try {
      final data = await service.getRecipients();

      if (!mounted) return;

      setState(() {
        recipients = data;
        filteredRecipients = data;
        loading = false;
        error = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
        error = "Impossible de charger les destinataires.";
      });

      debugPrint("Erreur destinataires : $e");
    }
  }

  void filterRecipients(String value) {
    final query = value.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        filteredRecipients = recipients;
      } else {
        filteredRecipients = recipients.where((recipient) {
          final name =
              (recipient["name"] ?? "").toString().toLowerCase();
          final role =
              (recipient["role"] ?? "").toString().toLowerCase();
          final function =
              (recipient["function"] ?? "").toString().toLowerCase();

          return name.contains(query) ||
              role.contains(query) ||
              function.contains(query);
        }).toList();
      }
    });
  }

  Future<void> selectRecipient(
    Map<String, dynamic> recipient,
  ) async {
    final recipientId = recipient["id"]?.toString();

    if (recipientId == null || recipientId.isEmpty) {
      return;
    }

    try {
      final conversationId = await service.startConversation(
        recipientId: recipientId,
      );

      if (!mounted) return;

      Navigator.pop(context, conversationId);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Impossible de démarrer cette discussion.",
          ),
          backgroundColor: Colors.red,
        ),
      );

      debugPrint("Erreur création conversation : $e");
    }
  }

  Widget buildAvatar(Map<String, dynamic> recipient) {
    final avatar = recipient["avatar"]?.toString();
    final name = recipient["name"]?.toString() ?? "?";

    if (avatar != null && avatar.isNotEmpty) {
      return CircleAvatar(
        radius: 25,
        backgroundColor: AppColors.primary.withOpacity(0.1),
        backgroundImage: NetworkImage(avatar),
        onBackgroundImageError: (_, __) {},
      );
    }

    return CircleAvatar(
      radius: 25,
      backgroundColor: AppColors.primary.withOpacity(0.1),
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : "?",
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Nouvelle discussion"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: filterRecipients,
              decoration: InputDecoration(
                hintText: "Rechercher un contact...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : error != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(error!),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  loading = true;
                                });
                                loadRecipients();
                              },
                              child: const Text("Réessayer"),
                            ),
                          ],
                        ),
                      )
                    : filteredRecipients.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: Text(
                                "Aucun contact disponible.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            itemCount: filteredRecipients.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final recipient =
                                  Map<String, dynamic>.from(
                                filteredRecipients[index],
                              );

                              final name =
                                  recipient["name"]?.toString() ?? "";
                              final role =
                                  recipient["role"]?.toString() ?? "";
                              final function =
                                  recipient["function"]?.toString() ?? "";

                              return ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 6,
                                ),
                                leading: buildAvatar(recipient),
                                title: Text(
                                  name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  function.isNotEmpty
                                      ? "$role • $function"
                                      : role,
                                ),
                                trailing: const Icon(
                                  Icons.chat_outlined,
                                  color: AppColors.primary,
                                ),
                                onTap: () =>
                                    selectRecipient(recipient),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
