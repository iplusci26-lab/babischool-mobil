import 'package:flutter/material.dart';

import '../../auth/contact_screen.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController searchController =
      TextEditingController();

  String searchQuery = '';

  final List<HelpCategory> categories = [
    HelpCategory(
      title: "Compte et connexion",
      icon: Icons.person_outline,
      questions: [
        HelpQuestion(
          question: "Comment me connecter à BabiSchool ?",
          answer:
              "Pour vous connecter, utilisez le numéro de téléphone "
              "associé à votre compte ainsi que votre mot de passe. "
              "Si votre compte a été créé par votre école, utilisez "
              "les identifiants qui vous ont été communiqués.",
        ),
        HelpQuestion(
          question: "J'ai oublié mon mot de passe. Que faire ?",
          answer:
              "Si vous avez oublié votre mot de passe, contactez votre "
              "école ou l'équipe BabiSchool afin d'obtenir de l'aide "
              "pour récupérer l'accès à votre compte.",
        ),
        HelpQuestion(
          question: "Comment modifier mon mot de passe ?",
          answer:
              "Depuis votre profil, ouvrez « Changer le mot de passe », "
              "saisissez votre ancien mot de passe puis choisissez "
              "votre nouveau mot de passe.",
        ),
      ],
    ),

    HelpCategory(
      title: "École et inscription",
      icon: Icons.school_outlined,
      questions: [
        HelpQuestion(
          question: "Comment utiliser BabiSchool ?",
          answer:
              "BabiSchool est une plateforme utilisée par les écoles "
              "partenaires. Pour utiliser l'application, vous devez "
              "être rattaché à une école qui utilise BabiSchool.",
        ),
        HelpQuestion(
          question: "Pourquoi mon école n'apparaît pas ?",
          answer:
              "BabiSchool fonctionne avec les écoles partenaires. "
              "Si votre école n'utilise pas encore BabiSchool, "
              "vous ne pourrez pas encore accéder aux services "
              "proposés par cette école dans l'application.",
        ),
        HelpQuestion(
          question: "Comment rattacher mon enfant à mon compte ?",
          answer:
              "Le rattachement d'un enfant est effectué à partir "
              "des informations communiquées par l'école. Si votre "
              "enfant n'apparaît pas dans votre compte, contactez "
              "son établissement pour vérifier son inscription.",
        ),
      ],
    ),

    HelpCategory(
      title: "Notes et résultats",
      icon: Icons.assessment_outlined,
      questions: [
        HelpQuestion(
          question: "Où consulter les notes de mon enfant ?",
          answer:
              "Lorsque l'école a publié les résultats, vous pouvez "
              "consulter les notes de votre enfant depuis la section "
              "prévue à cet effet dans l'application.",
        ),
        HelpQuestion(
          question: "Pourquoi une note n'apparaît-elle pas ?",
          answer:
              "Les notes apparaissent uniquement après leur publication "
              "par l'établissement. Si une note attendue n'est toujours "
              "pas visible, contactez l'école concernée.",
        ),
      ],
    ),

    HelpCategory(
      title: "Présences et absences",
      icon: Icons.event_available_outlined,
      questions: [
        HelpQuestion(
          question: "Où consulter les absences de mon enfant ?",
          answer:
              "Les informations de présence et d'absence sont disponibles "
              "dans la section dédiée lorsque l'établissement les a "
              "enregistrées et publiées.",
        ),
        HelpQuestion(
          question: "Une absence affichée est incorrecte. Que faire ?",
          answer:
              "Si vous constatez une erreur concernant une présence ou "
              "une absence, contactez directement l'établissement afin "
              "qu'il puisse vérifier et corriger l'information.",
        ),
      ],
    ),

    HelpCategory(
      title: "Devoirs",
      icon: Icons.menu_book_outlined,
      questions: [
        HelpQuestion(
          question: "Où consulter les devoirs ?",
          answer:
              "Les devoirs publiés par les enseignants sont accessibles "
              "depuis la section dédiée aux devoirs de l'application.",
        ),
        HelpQuestion(
          question: "Pourquoi un devoir n'apparaît-il pas ?",
          answer:
              "Un devoir doit être publié par l'enseignant avant "
              "d'apparaître dans l'application. Si vous pensez qu'un "
              "devoir devrait être disponible, contactez l'établissement.",
        ),
      ],
    ),

    HelpCategory(
      title: "Paiements",
      icon: Icons.payments_outlined,
      questions: [
        HelpQuestion(
          question: "Où consulter les paiements de mon enfant ?",
          answer:
              "Les informations financières disponibles pour votre compte "
              "sont accessibles depuis la section dédiée aux paiements.",
        ),
        HelpQuestion(
          question: "Pourquoi mon paiement n'apparaît-il pas ?",
          answer:
              "La mise à jour des informations de paiement dépend de "
              "l'enregistrement effectué par l'établissement. Si votre "
              "paiement n'apparaît pas, contactez votre école avec "
              "votre justificatif de paiement.",
        ),
      ],
    ),

    HelpCategory(
      title: "Notifications et messages",
      icon: Icons.notifications_outlined,
      questions: [
        HelpQuestion(
          question: "Pourquoi je ne reçois pas les notifications ?",
          answer:
              "Vérifiez que les notifications de BabiSchool sont "
              "autorisées dans les paramètres de votre téléphone. "
              "Vérifiez également votre connexion Internet.",
        ),
        HelpQuestion(
          question: "Comment contacter mon école ?",
          answer:
              "Lorsque la messagerie de votre établissement est activée, "
              "vous pouvez utiliser la section de messagerie de "
              "BabiSchool pour communiquer avec l'école.",
        ),
      ],
    ),

    HelpCategory(
      title: "Problèmes techniques",
      icon: Icons.build_outlined,
      questions: [
        HelpQuestion(
          question:
              "L'application ne fonctionne pas correctement. Que faire ?",
          answer:
              "Commencez par vérifier votre connexion Internet et assurez-"
              "vous d'utiliser la dernière version disponible de "
              "BabiSchool. Si le problème persiste, contactez notre équipe.",
        ),
        HelpQuestion(
          question:
              "Que faire si l'application se ferme toute seule ?",
          answer:
              "Fermez complètement l'application puis relancez-la. "
              "Vérifiez également que votre téléphone dispose de suffisamment "
              "d'espace de stockage et que BabiSchool est à jour. "
              "Si le problème persiste, contactez-nous.",
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();

    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = searchController.text.trim().toLowerCase();
    });
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  List<HelpCategory> get filteredCategories {
    if (searchQuery.isEmpty) {
      return categories;
    }

    return categories
        .map((category) {
          final filteredQuestions =
              category.questions.where((question) {
            final questionText =
                question.question.toLowerCase();

            final answerText =
                question.answer.toLowerCase();

            return questionText.contains(searchQuery) ||
                answerText.contains(searchQuery);
          }).toList();

          return HelpCategory(
            title: category.title,
            icon: category.icon,
            questions: filteredQuestions,
          );
        })
        .where(
          (category) => category.questions.isNotEmpty,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = filteredCategories;

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xff6214BE),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Centre d'aide",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // --------------------------------------------------
            // RECHERCHE
            // --------------------------------------------------

            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                10,
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Rechercher dans l'aide...",
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xff6214BE),
                  ),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            searchController.clear();
                          },
                          icon: const Icon(Icons.clear),
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xff6214BE),
                      width: 1.2,
                    ),
                  ),
                ),
              ),
            ),

            // --------------------------------------------------
            // CONTENU
            // --------------------------------------------------

            Expanded(
              child: results.isEmpty
                  ? _buildEmptyState()
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        10,
                        20,
                        30,
                      ),
                      children: [
                        if (searchQuery.isEmpty)
                          _buildIntroduction(),

                        ...results.map(
                          _buildCategory,
                        ),

                        const SizedBox(height: 20),

                        _buildContactCard(),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // INTRODUCTION
  // --------------------------------------------------

  Widget _buildIntroduction() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 24,
      ),
      child: Text(
        "Trouvez rapidement les réponses aux "
        "questions les plus fréquentes concernant BabiSchool.",
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 14,
          height: 1.4,
        ),
      ),
    );
  }

  // --------------------------------------------------
  // CATÉGORIE
  // --------------------------------------------------

  Widget _buildCategory(HelpCategory category) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xff6214BE)
                      .withOpacity(0.10),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Icon(
                  category.icon,
                  color: const Color(0xff6214BE),
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  category.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ...category.questions.map(
            _buildQuestion,
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // QUESTION
  // --------------------------------------------------

  Widget _buildQuestion(HelpQuestion question) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 2,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            18,
          ),
          iconColor: const Color(0xff6214BE),
          collapsedIconColor: Colors.grey.shade600,
          title: Text(
            question.question,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                question.answer,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // AUCUN RÉSULTAT
  // --------------------------------------------------

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xff6214BE)
                    .withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off,
                color: Color(0xff6214BE),
                size: 34,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              "Aucun résultat",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Nous n'avons trouvé aucune réponse "
              "correspondant à votre recherche.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 20),

            OutlinedButton.icon(
              onPressed: _openContact,
              icon: const Icon(
                Icons.headset_mic_outlined,
              ),
              label: const Text(
                "Nous contacter",
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor:
                    const Color(0xff6214BE),
                side: const BorderSide(
                  color: Color(0xff6214BE),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // CARTE CONTACT
  // --------------------------------------------------

  Widget _buildContactCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xff6214BE)
            .withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xff6214BE)
              .withOpacity(0.12),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xff6214BE),
              borderRadius:
                  BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.headset_mic_outlined,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            "Vous ne trouvez pas votre réponse ?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "Notre équipe est disponible pour "
            "vous accompagner.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _openContact,
              icon: const Icon(
                Icons.headset_mic_outlined,
              ),
              label: const Text(
                "Nous contacter",
              ),
              style: FilledButton.styleFrom(
                backgroundColor:
                    const Color(0xff6214BE),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // OUVRIR CONTACT
  // --------------------------------------------------

  void _openContact() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ContactScreen(),
      ),
    );
  }
}

// ==================================================
// MODÈLES
// ==================================================

class HelpCategory {
  final String title;
  final IconData icon;
  final List<HelpQuestion> questions;

  const HelpCategory({
    required this.title,
    required this.icon,
    required this.questions,
  });
}

class HelpQuestion {
  final String question;
  final String answer;

  const HelpQuestion({
    required this.question,
    required this.answer,
  });
}