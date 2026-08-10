import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

import '../../shared/models/conversation_model.dart';

import '../../shared/widgets/conversation_card.dart';

import '../../shared/widgets/app_header.dart';

import '../../shared/widgets/app_search_bar.dart';

import '../../shared/widgets/error_view.dart';

import '../../shared/widgets/loading_view.dart';

import '../../shared/widgets/section_title.dart';

import 'conversation_screen.dart';

import 'messaging_service.dart';



class MessagingScreen
    extends StatefulWidget {

  const MessagingScreen({
    super.key,
  });

  @override
  State<MessagingScreen>
      createState() =>
          _MessagingScreenState();
}

class _MessagingScreenState
    extends State<MessagingScreen> {

  bool loading = true;

  final TextEditingController
      searchController =
      TextEditingController();

  List<ConversationModel>
      conversations = [];

  List<ConversationModel>
      filteredConversations = [];

  Future<void> loadData()
  async {

    try {

      final data =

          await MessagingService()
              .getConversations();

      conversations =

          data
              .map<ConversationModel>(
                (e) =>
                    ConversationModel
                        .fromJson(
                  e,
                ),
              )
              .toList();

      filteredConversations =
          conversations;

    } catch (e) {

      debugPrint(
        e.toString(),
      );
    }

    if (mounted) {

      setState(() {

        loading = false;
      });
    }
  }

  void filterConversation(
      String value) {

    if (value.isEmpty) {

      setState(() {

        filteredConversations =
            conversations;
      });

      return;
    }

    setState(() {

      filteredConversations =

          conversations

              .where(

                (conversation) =>

                    conversation
                        .studentName
                        .toLowerCase()
                        .contains(

                          value
                              .toLowerCase(),
                        ),
              )

              .toList();
    });
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
  Widget build(
      BuildContext context) {

    if (loading) {

      return const Scaffold(

        body:
            LoadingView(),
      );
    }

    return Scaffold(

      backgroundColor:
          AppColors.background,

    
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
                      subtitle: "Discuter avec un personnel de l'établissement",
                      
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
                   
                  child:filteredConversations
                          .isEmpty

                      ? ListView(

                          physics:
                              const AlwaysScrollableScrollPhysics(),

                          children: const [

                            SizedBox(
                              height: 120,
                            ),

                            Icon(

                              Icons.chat_bubble_outline,

                              size: 70,

                              color: Colors.grey,
                            ),

                            SizedBox(
                              height: 20,
                            ),

                            Center(

                              child: Text(

                                "Aucune conversation",

                                style: TextStyle(

                                  fontSize: 20,

                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 8,
                            ),

                            Center(

                              child: Padding(

                                padding:
                                    EdgeInsets.symmetric(
                                  horizontal: 40,
                                ),

                                child: Text(

                                  "Commencez une discussion avec votre établissement.",

                                  textAlign:
                                      TextAlign.center,

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

                          padding:
                              const EdgeInsets.all(
                            20,
                          ),

                          

                          itemCount:
                              filteredConversations
                                  .length,

                          itemBuilder:
                              (
                            context,
                            index,
                          ) {

                            final conversation =

                                filteredConversations[
                                    index];

                            return Padding(

                                padding: const EdgeInsets.only(bottom: 16),

                                child: ConversationCard(

                                    name: conversation.contact.name,

                                    role: conversation.contact.role,

                                    studentName: conversation.studentName,

                                    lastMessage: conversation.lastMessage,

                                    lastMessageType: conversation.lastMessageType,

                                    time: conversation.updatedTime,

                                    unreadCount: conversation.unreadCount,

                                    avatarUrl: conversation.contact.avatar,

                                    onTap: () async {

                                        await Navigator.push(

                                            context,

                                            MaterialPageRoute(

                                                builder: (_) => ConversationScreen(

                                                    conversationId: conversation.id,

                                                ),

                                            ),

                                        );

                                        loadData();

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