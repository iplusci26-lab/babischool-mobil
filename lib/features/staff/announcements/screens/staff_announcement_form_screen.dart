
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../classrooms/models/staff_classroom_model.dart';
import '../services/staff_announcement_service.dart';

class StaffAnnouncementFormScreen extends StatefulWidget {
  const StaffAnnouncementFormScreen({super.key});

  @override
  State<StaffAnnouncementFormScreen> createState() =>
      _StaffAnnouncementFormScreenState();
}

class _StaffAnnouncementFormScreenState
    extends State<StaffAnnouncementFormScreen> {
  static const Color primaryColor = Color(0xFF6214BE);
  static const Color backgroundColor = Color(0xFFF8F8FD);
  static const Color darkColor = Color(0xFF292640);
  static const Color mutedColor = Color(0xFF85839A);

  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  List<StaffClassroomModel> classrooms = [];

  String targetType = 'classroom';
  String category = 'general';
  String priority = 'normal';

  String? selectedClassroomId;
  String? selectedLevelId;

  PlatformFile? selectedFile;

  bool sendNotification = true;
  bool loadingClassrooms = true;
  bool submitting = false;

  String? loadingError;

  @override
  void initState() {
    super.initState();
    _loadClassrooms();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // LOAD CLASSROOMS
  // ------------------------------------------------------------

  Future<void> _loadClassrooms() async {
    try {
      final result = await StaffAnnouncementService.getClassrooms();

      if (!mounted) return;

      setState(() {
        classrooms = result;
        loadingClassrooms = false;
        loadingError = null;

        if (result.isNotEmpty) {
          selectedClassroomId = result.first.id;

          final firstLevel = result.firstWhere(
            (item) => item.classroomLevelId != null &&
                item.classroomLevelId!.isNotEmpty,
            orElse: () => result.first,
          );

          selectedLevelId = firstLevel.classroomLevelId;
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loadingClassrooms = false;
        loadingError = e.toString();
      });
    }
  }

  Map<String, String> get availableLevels {
    final levels = <String, String>{};

    for (final classroom in classrooms) {
      final id = classroom.classroomLevelId;

      if (id != null && id.isNotEmpty) {
        levels[id] = classroom.classroomLevel;
      }
    }

    return levels;
  }

  // ------------------------------------------------------------
  // ATTACHMENT
  // ------------------------------------------------------------

  Future<void> _pickAttachment() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'jpg',
          'jpeg',
          'png',
          'doc',
          'docx',
        ],
        withData: true,
      );

      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;

      if (file.bytes == null) {
        _showMessage('Impossible de lire ce fichier.');
        return;
      }

      if (!mounted) return;

      setState(() {
        selectedFile = file;
      });
    } catch (e) {
      debugPrint('ERREUR SELECTION FICHIER: $e');
      _showMessage('Erreur lors de la sélection du fichier.');
    }
  }

  void _removeAttachment() {
    setState(() {
      selectedFile = null;
    });
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes octets';
    }

    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} Ko';
    }

    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} Mo';
  }

  // ------------------------------------------------------------
  // SUBMIT
  // ------------------------------------------------------------

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (targetType == 'classroom' &&
        selectedClassroomId == null) {
      _showMessage('Veuillez sélectionner une classe.');
      return;
    }

    if (targetType == 'classroom_level' &&
        selectedLevelId == null) {
      _showMessage('Veuillez sélectionner un niveau.');
      return;
    }

    if (targetType == 'classroom_level' &&
        !availableLevels.containsKey(selectedLevelId)) {
      _showMessage('Le niveau sélectionné est invalide.');
      return;
    }

    setState(() {
      submitting = true;
    });

    try {
      await StaffAnnouncementService.createAnnouncement(
        title: titleController.text,
        content: contentController.text,
        category: category,
        priority: priority,
        targetType: targetType,
        classroomId: selectedClassroomId,
        classroomLevelId: selectedLevelId,
        sendNotification: sendNotification,
        attachment: selectedFile,
      );

      if (!mounted) return;

      final messenger = ScaffoldMessenger.of(context);

      Navigator.pop(context, true);

      messenger.showSnackBar(
        const SnackBar(
          content: Text('Annonce publiée avec succès.'),
          backgroundColor: Color(0xFF269B55),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('ERREUR PUBLICATION ANNONCE: $e');
      debugPrint('STACKTRACE: $stackTrace');

      if (!mounted) return;

      _showMessage(_extractError(e));
    } finally {
      if (mounted) {
        setState(() {
          submitting = false;
        });
      }
    }
  }

  String _extractError(Object error) {
    final text = error.toString();

    if (text.contains('403')) {
      return 'Vous n’avez pas les droits pour publier cette annonce.';
    }

    if (text.contains('400')) {
      return 'Certaines informations sont invalides. Vérifiez le formulaire.';
    }

    if (text.contains('401')) {
      return 'Votre session a expiré. Veuillez vous reconnecter.';
    }

    if (text.contains('SocketException') ||
        text.contains('connection')) {
      return 'Impossible de contacter le serveur. Vérifiez votre connexion.';
    }

    return 'Impossible de publier l’annonce. Consultez les logs pour plus de détails.';
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ------------------------------------------------------------
  // INPUT DECORATION
  // ------------------------------------------------------------

  InputDecoration _decoration(
    String hint, {
    IconData? icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFF85839A),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      prefixIcon: icon != null
          ? Icon(
              icon,
              color: primaryColor,
              size: 21,
            )
          : null,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color(0xFFEAE6F3),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color(0xFFEAE6F3),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 1.4,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color(0xFFE53945),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color(0xFFE53945),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // SECTION TITLE
  // ------------------------------------------------------------

  Widget _sectionTitle(
    String title,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Icon(
            icon,
            color: primaryColor,
            size: 22,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: darkColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // WELCOME BANNER
  // ------------------------------------------------------------

  Widget _buildWelcomeBanner() {
    return Container(
      height: 105,
      padding: const EdgeInsets.symmetric(
        horizontal: 17,
        vertical: 15,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6214BE),
            Color(0xFF873BE0),
            Color(0xFF9029E8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -8,
            bottom: -28,
            child: Icon(
              Icons.campaign_rounded,
              size: 105,
              color: Colors.white.withValues(alpha: 0.13),
            ),
          ),
          Row(
            children: [
              Container(
                width: 47,
                height: 47,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.17),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.campaign_rounded,
                  color: Colors.white,
                  size: 27,
                ),
              ),
              const SizedBox(width: 13),
              const Expanded(
                child: Text(
                  'Communiquez rapidement avec les destinataires de votre choix.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // TARGET SELECTOR
  // ------------------------------------------------------------

  Widget _buildTargetSelector() {
    if (loadingClassrooms) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 25),
        child: Center(
          child: CircularProgressIndicator(
            color: primaryColor,
            strokeWidth: 2.5,
          ),
        ),
      );
    }

    if (loadingError != null) {
      return Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0F0),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Impossible de charger les classes.',
              style: TextStyle(
                color: Color(0xFFE53945),
                fontSize: 13,
              ),
            ),
            TextButton(
              onPressed: _loadClassrooms,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _targetOption(
                value: 'classroom',
                icon: Icons.groups_rounded,
                label: 'Une classe',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _targetOption(
                value: 'classroom_level',
                icon: Icons.layers_rounded,
                label: 'Un niveau',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _targetOption(
                value: 'school',
                icon: Icons.account_balance_rounded,
                label: 'Toute l’école',
              ),
            ),
          ],
        ),

        if (targetType == 'classroom') ...[
          const SizedBox(height: 17),
          _fieldLabel('Sélectionner une classe'),
          const SizedBox(height: 7),
          DropdownButtonFormField<String>(
            initialValue: classrooms.any(
              (item) => item.id == selectedClassroomId,
            )
                ? selectedClassroomId
                : null,
            isExpanded: true,
            decoration: _decoration(
              'Choisir une classe',
              icon: Icons.meeting_room_outlined,
            ),
            items: classrooms.map((classroom) {
              return DropdownMenuItem<String>(
                value: classroom.id,
                child: Text(
                  '${classroom.name} — ${classroom.classroomLevel}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: darkColor,
                    fontSize: 13,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedClassroomId = value;
              });
            },
            validator: (value) {
              if (targetType == 'classroom' && value == null) {
                return 'Sélectionnez une classe.';
              }
              return null;
            },
          ),
        ],

        if (targetType == 'classroom_level') ...[
          const SizedBox(height: 17),
          _fieldLabel('Sélectionner un niveau'),
          const SizedBox(height: 7),
          DropdownButtonFormField<String>(
            initialValue: availableLevels.containsKey(selectedLevelId)
                ? selectedLevelId
                : null,
            isExpanded: true,
            decoration: _decoration(
              'Choisir un niveau',
              icon: Icons.layers_outlined,
            ),
            items: availableLevels.entries.map((level) {
              return DropdownMenuItem<String>(
                value: level.key,
                child: Text(
                  level.value,
                  style: const TextStyle(
                    color: darkColor,
                    fontSize: 13,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedLevelId = value;
              });
            },
            validator: (value) {
              if (targetType == 'classroom_level' && value == null) {
                return 'Sélectionnez un niveau.';
              }
              return null;
            },
          ),
        ],

        if (targetType == 'school') ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF2EAFE),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: primaryColor,
                  size: 20,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Cette annonce sera adressée aux parents, enseignants et membres du personnel.',
                    style: TextStyle(
                      color: Color(0xFF62527C),
                      fontSize: 11,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _targetOption({
    required String value,
    required IconData icon,
    required String label,
  }) {
    final selected = targetType == value;

    return GestureDetector(
      onTap: submitting
          ? null
          : () {
              setState(() {
                targetType = value;
              });
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 100,
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFF2EAFE)
              : const Color(0xFFF7F6FB),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: selected
                ? const Color(0xFF9A50EE)
                : Colors.transparent,
            width: 1.4,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: primaryColor,
                    size: 27,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: darkColor,
                      fontSize: 10.5,
                      fontWeight: selected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Positioned(
                right: 0,
                top: 0,
                child: Icon(
                  Icons.check_circle,
                  color: primaryColor,
                  size: 17,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: const TextStyle(
          color: mutedColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // CATEGORY AND PRIORITY
  // ------------------------------------------------------------

  Widget _buildCategoryAndPriority() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _fieldLabel('Catégorie'),
              const SizedBox(height: 7),
              DropdownButtonFormField<String>(
                initialValue: category,
                isExpanded: true,
                decoration: _decoration(
                  'Catégorie',
                  icon: Icons.grid_view_rounded,
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'general',
                    child: Text('Général'),
                  ),
                  DropdownMenuItem(
                    value: 'finance',
                    child: Text('Finance'),
                  ),
                  DropdownMenuItem(
                    value: 'academic',
                    child: Text('Pédagogique'),
                  ),
                  DropdownMenuItem(
                    value: 'discipline',
                    child: Text('Discipline'),
                  ),
                  DropdownMenuItem(
                    value: 'holiday',
                    child: Text('Congé'),
                  ),
                  DropdownMenuItem(
                    value: 'meeting',
                    child: Text('Réunion'),
                  ),
                  DropdownMenuItem(
                    value: 'service',
                    child: Text('Note de service'),
                  ),
                  DropdownMenuItem(
                    value: 'emergency',
                    child: Text('Urgence'),
                  ),
                  DropdownMenuItem(
                    value: 'exam',
                    child: Text('Examen'),
                  ),
                  DropdownMenuItem(
                    value: 'other',
                    child: Text('Autre'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => category = value);
                  }
                },
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _fieldLabel('Priorité'),
              const SizedBox(height: 7),
              DropdownButtonFormField<String>(
                initialValue: priority,
                isExpanded: true,
                decoration: _decoration(
                  'Priorité',
                  icon: Icons.flag_outlined,
                ),
                items: [
                  DropdownMenuItem(
                    value: 'normal',
                    child: _priorityOption(
                      'Normal',
                      const Color(0xFF269B55),
                      const Color(0xFFE9F8EC),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'important',
                    child: _priorityOption(
                      'Important',
                      const Color(0xFFE69A18),
                      const Color(0xFFFFF3DF),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'urgent',
                    child: _priorityOption(
                      'Urgent',
                      const Color(0xFFE53945),
                      const Color(0xFFFFE9EB),
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => priority = value);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _priorityOption(
    String label,
    Color color,
    Color background,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // ATTACHMENT SELECTOR
  // ------------------------------------------------------------

  Widget _buildAttachmentSelector() {
    if (selectedFile != null) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF2EAFE),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE5D5FA),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _fileIcon(selectedFile!.extension),
                color: primaryColor,
                size: 23,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedFile!.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: darkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatFileSize(selectedFile!.size),
                    style: const TextStyle(
                      color: mutedColor,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: submitting ? null : _removeAttachment,
              icon: const Icon(
                Icons.close_rounded,
                color: Color(0xFFE53945),
                size: 21,
              ),
              tooltip: 'Retirer le fichier',
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: submitting ? null : _pickAttachment,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFBFAFF),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: const Color(0xFFC8A9F0),
            width: 1.2,
          ),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.cloud_upload_outlined,
              color: primaryColor,
              size: 32,
            ),
            const SizedBox(height: 9),
            const Text(
              'Ajouter un fichier',
              style: TextStyle(
                color: primaryColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'PDF, image ou document',
              style: TextStyle(
                color: mutedColor,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _fileIcon(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image_outlined;
      case 'doc':
      case 'docx':
        return Icons.description_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  // ------------------------------------------------------------
  // NOTIFICATION
  // ------------------------------------------------------------

  Widget _buildNotificationOption() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFF0EDF7),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFF2EAFE),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: primaryColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 11),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Envoyer une notification',
                  style: TextStyle(
                    color: darkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Informer les destinataires dès la publication',
                  style: TextStyle(
                    color: mutedColor,
                    fontSize: 10,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: sendNotification,
            activeTrackColor: primaryColor,
            onChanged: submitting
                ? null
                : (value) {
                    setState(() {
                      sendNotification = value;
                    });
                  },
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // MAIN BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: darkColor,
        ),
        title: const Text(
          'Nouvelle annonce',
          style: TextStyle(
            color: darkColor,
            fontSize: 19,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
      ),

      // Fixed publication button
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            16,
            12,
            16,
            14,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: darkColor.withValues(alpha: 0.045),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SizedBox(
            height: 54,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF873BE0),
                    Color(0xFF6214BE),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ElevatedButton(
                onPressed: submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: submitting
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 19,
                            height: 19,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 11),
                          Text(
                            'Publication...',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.send_rounded,
                            size: 21,
                          ),
                          SizedBox(width: 11),
                          Text(
                            'Publier l’annonce',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(
            16,
            16,
            16,
            25,
          ),
          children: [
            // Welcome
            _buildWelcomeBanner(),

            const SizedBox(height: 25),

            // General information
            _sectionTitle(
              'Informations générales',
              Icons.edit_document,
            ),

            TextFormField(
              controller: titleController,
              maxLength: 255,
              textCapitalization: TextCapitalization.sentences,
              decoration: _decoration(
                'Titre de l’annonce',
                icon: Icons.title_rounded,
              ).copyWith(
                counterStyle: const TextStyle(
                  color: mutedColor,
                  fontSize: 10,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Le titre est obligatoire.';
                }
                return null;
              },
            ),

            const SizedBox(height: 12),

            TextFormField(
              controller: contentController,
              minLines: 4,
              maxLines: 7,
              textCapitalization: TextCapitalization.sentences,
              decoration: _decoration(
                'Contenu de l’annonce',
                icon: Icons.notes_rounded,
              ).copyWith(
                alignLabelWithHint: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 19,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Le contenu est obligatoire.';
                }
                return null;
              },
            ),

            const SizedBox(height: 25),

            // Recipients
            _sectionTitle(
              'Destinataires',
              Icons.people_alt_outlined,
            ),

            _buildTargetSelector(),

            const SizedBox(height: 25),

            // Category and priority
            _sectionTitle(
              'Catégorie et priorité',
              Icons.sell_outlined,
            ),

            _buildCategoryAndPriority(),

            const SizedBox(height: 25),

            // Attachment
            _sectionTitle(
              'Pièce jointe (facultative)',
              Icons.attach_file_rounded,
            ),

            _buildAttachmentSelector(),

            const SizedBox(height: 20),

            // Notifications
            _buildNotificationOption(),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
