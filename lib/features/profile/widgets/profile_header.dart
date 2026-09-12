import 'package:flutter/material.dart';
import '../models/profile_model.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileModel profile;
  final VoidCallback onEditAvatar;

  const ProfileHeader({
    super.key,
    required this.profile,
    required this.onEditAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 28,
      ),
      decoration: BoxDecoration(
        color: Color(0xff6214BE),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          //--------------------------------------------------
          // AVATAR
          //--------------------------------------------------

          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xff6214BE),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 54,
                  backgroundColor: const Color(0xffF5F7FB),
                  backgroundImage:
                      profile.avatar != null &&
                              profile.avatar!.isNotEmpty
                          ? NetworkImage(profile.avatar!)
                          : null,
                  child:
                      profile.avatar == null ||
                              profile.avatar!.isEmpty
                          ? const Icon(
                              Icons.person,
                              size: 56,
                              color: Color(0xff6214BE),
                            )
                          : null,
                ),
              ),

              Positioned(
                right: 2,
                bottom: 2,
                child: GestureDetector(
                  onTap: onEditAvatar,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xff6214BE),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          //--------------------------------------------------
          // NOM
          //--------------------------------------------------

          Text(
            profile.fullName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 12),

          //--------------------------------------------------
          // ROLE
          //--------------------------------------------------

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffF3E8FF),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              profile.userType == "teacher" ? "Enseignant" : profile.userType,
              style: const TextStyle(
                color: Color(0xff6214BE),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 24),

          //--------------------------------------------------
          // TELEPHONE
          //--------------------------------------------------

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.phone_outlined,
                size: 18,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                profile.phone,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white70,
                ),
              ),
            ],
          ),

          if ((profile.schoolName ?? "").isNotEmpty) ...[
            const SizedBox(height: 14),

            //--------------------------------------------------
            // ECOLE
            //--------------------------------------------------

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.school_outlined,
                  size: 18,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    profile.schoolName!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}