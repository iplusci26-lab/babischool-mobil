import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

import '../../shared/models/conversation_model.dart';

import '../../shared/widgets/error_view.dart';

import '../../shared/widgets/loading_view.dart';

import '../../shared/widgets/section_title.dart';

import 'conversation_screen.dart';

import 'messaging_service.dart';

import 'widgets/conversation_tile.dart';

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

      appBar: AppBar(

        elevation: 0,

        backgroundColor:
            Colors.white,

        centerTitle: false,

        title: const Text(

          "Messagerie",

          style: TextStyle(

            color: Colors.black,

            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body: RefreshIndicator(

        onRefresh: loadData,

        child: Column(

          children: [

            Container(

              color: Colors.white,

              padding:
                  const EdgeInsets.only(

                left: 20,

                right: 20,

                bottom: 20,
              ),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  const SectionTitle(

                    title:
                        "Vos conversations",
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  TextField(

                    controller:
                        searchController,

                    onChanged:
                        filterConversation,

                    decoration:
                        InputDecoration(

                      prefixIcon:
                          const Icon(
                        Icons.search,
                      ),

                      hintText:
                          "Rechercher...",

                      filled: true,

                      fillColor:
                          Colors.grey
                              .shade100,

                      border:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),

                        borderSide:
                            BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
                            child:

                  filteredConversations
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

                            return ConversationTile(

                              conversation:
                                  conversation,

                              onTap: () async {

                                await Navigator.push(

                                  context,

                                  MaterialPageRoute(

                                    builder: (_) =>

                                        ConversationScreen(

                                      conversationId:
                                          conversation.id,
                                    ),
                                  ),
                                );

                                loadData();
                              },
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