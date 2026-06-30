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

      padding:
          const EdgeInsets.all(
        24,
      ),

      decoration: BoxDecoration(

        borderRadius:
            BorderRadius.circular(
          24,
        ),

        gradient:
            const LinearGradient(

          begin:
              Alignment.topLeft,

          end:
              Alignment.bottomRight,

          colors: [

            Color(0xff6214BE),

            Color(0xff7E3AF2),
          ],
        ),
      ),

      child: Column(

        children: [

          Stack(

  alignment:
      Alignment.bottomRight,

  children: [

            CircleAvatar(

            radius: 45,

            backgroundColor:
                Colors.white,

            backgroundImage:

                profile.avatar != null &&
                        profile.avatar!
                            .isNotEmpty

                    ? NetworkImage(
                        profile.avatar!,
                        )

                    : null,

            child:

                profile.avatar == null ||
                        profile.avatar!
                            .isEmpty

                    ? const Icon(
                        Icons.person,
                        size: 45,
                        color: Color(
                            0xff6214BE,
                        ),
                        )

                    : null,
            ),

            GestureDetector(

            onTap: onEditAvatar,

            child: Container(

                padding:
                    const EdgeInsets.all(
                6,
                ),

                decoration:
                    const BoxDecoration(

                color: Colors.white,

                shape:
                    BoxShape.circle,
                ),

                child: const Icon(
                Icons.camera_alt,
                size: 18,
                color: Color(
                    0xff6214BE,
                ),
                ),
            ),
            ),
        ],
        ),

          const SizedBox(
            height: 16,
          ),

          Text(

            profile.fullName,

            textAlign:
                TextAlign.center,

            style:
                const TextStyle(

              color:
                  Colors.white,

              fontSize: 22,

              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 6,
          ),

          Text(

            profile.role ??
                profile.userType,

            style:
                const TextStyle(

              color:
                  Colors.white70,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          Text(

            profile.phone,

            style:
                const TextStyle(

              color:
                  Colors.white,
            ),
          ),

          const SizedBox(
            height: 6,
          ),

          Text(

            profile.schoolName ??
                "",

            style:
                const TextStyle(

              color:
                  Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}