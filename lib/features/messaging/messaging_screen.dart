
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../shared/models/conversation_model.dart';
import '../../shared/widgets/conversation_card.dart';
import '../../shared/widgets/app_header.dart';
import '../../shared/widgets/app_search_bar.dart';
import '../../shared/widgets/loading_view.dart';

import 'new_conversation_screen.dart';
import 'conversation_screen.dart';
import 'messaging_service.dart';

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  bool loading = true;
  bool refreshing = false;

  final TextEditingController searchController =
      TextEditingController();

  final MessagingService messagingService = MessagingService();

  List<ConversationModel> conversations = [];
  List<ConversationModel> filteredConversations = [];

  Future<void> loadData() async {
    if (refreshing) return;

    refreshing = true;

    try {
      final data = await messagingService.getConversations();

      final loadedConversations = data
          .map<ConversationModel>(
            (e) => ConversationModel.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList();

      // Les conversations les plus récentes en premier.
      loadedConversations.sort(
        (a, b) => b.updatedAt.compareTo(a.updatedAt),
      );

      if (!mounted) return;

      setState(() {
        conversations = loadedConversations;
        _applySearch(searchController.text);
        loading = false;
      });
    } catch (e) {
      debugPrint("Erreur chargement conversations : $e");

      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    } finally {
      refreshing = false;
    }
  }

  void _applySearch(String value) {
    final query = value.trim().toLowerCase();

    if (query.isEmpty) {
      filteredConversations = List.from(conversations);
      return;
    }

    filteredConversations = conversations.where((conversation) {
      return conversation.contact.name.toLowerCase().contains(query) ||
          conversation.contact.role.toLowerCase().contains(query) ||
          conversation.studentName.toLowerCase().contains(query) ||
          conversation.lastMessage.toLowerCase().contains(query);
    }).toList();
  }

  void filterConversation(String value) {
    setState(() {
      _applySearch(value);
    });
  }

  Future<void> startNewConversation() async {
    final conversationId = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => const NewConversationScreen(),
      ),
    );

    if (!mounted) return;

    if (conversationId != null && conversationId.isNotEmpty) {
      await loadData();

      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ConversationScreen(
            conversationId: conversationId,
          ),
        ),
      );

      if (mounted) {
        await loadData();
      }
    }
  }

  Future<void> openConversation(String conversationId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConversationScreen(
          conversationId: conversationId,
        ),
      ),
    );

    if (mounted) {
      await loadData();
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: LoadingView(),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,

      floatingActionButton: FloatingActionButton.extended(
        onPressed: startNewConversation,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit),
        label: const Text("Nouvelle discussion"),
      ),

      body: RefreshIndicator(
        onRefresh: loadData,

        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                children: [
                  AppHeader(
                    title: "Messagerie",
                    subtitle:
                        "Discuter avec un personnel de l'établissement",
                  ),

                  const SizedBox(height: 28),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AppSearchBar(
                      controller: searchController,
                      hintText: "Rechercher une conversation...",
                      onChanged: filterConversation,
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),

            Expanded(
              child: filteredConversations.isEmpty
                  ? ListView(
                      physics:
                          const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 120),

                        Icon(
                          Icons.chat_bubble_outline,
                          size: 70,
                          color: Colors.grey,
                        ),

                        SizedBox(height: 20),

                        Center(
                          child: Text(
                            "Aucune conversation",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        SizedBox(height: 8),

                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 40,
                            ),
                            child: Text(
                              "Commencez une discussion avec votre établissement.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      physics:
                          const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      itemCount: filteredConversations.length,

                      itemBuilder: (context, index) {
                        final conversation =
                            filteredConversations[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ConversationCard(
                            name: conversation.contact.name,
                            role: conversation.contact.role,
                            studentName: conversation.studentName,
                            lastMessage: conversation.lastMessage,
                            lastMessageType:
                                conversation.lastMessageType,
                            time: conversation.updatedTime,
                            unreadCount: conversation.unreadCount,
                            avatarUrl: conversation.contact.avatar,

                            onTap: () {
                              openConversation(conversation.id);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
