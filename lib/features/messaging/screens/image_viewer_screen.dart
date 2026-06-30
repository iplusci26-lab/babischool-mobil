import 'package:flutter/material.dart';

class ImageViewerScreen extends StatelessWidget {

  final String imageUrl;

  final String heroTag;

  const ImageViewerScreen({

    super.key,

    required this.imageUrl,

    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        backgroundColor: Colors.transparent,

        elevation: 0,

        foregroundColor: Colors.white,

        actions: [

          IconButton(

            icon: const Icon(
              Icons.share,
            ),

            onPressed: () {

              // Bloc 4
            },
          ),

          IconButton(

            icon: const Icon(
              Icons.download,
            ),

            onPressed: () {

              // Bloc 3
            },
          ),
        ],
      ),

      body: Center(

        child: Hero(

          tag: heroTag,

          child: InteractiveViewer(

            minScale: 0.5,

            maxScale: 5,

            child: Image.network(

              imageUrl,

              fit: BoxFit.contain,

              loadingBuilder:

                  (

                    context,

                    child,

                    progress,

                  ) {

                if (progress == null) {

                  return child;
                }

                return const Center(

                  child:
                      CircularProgressIndicator(),
                );
              },

              errorBuilder:

                  (

                    context,

                    error,

                    stack,

                  ) {

                return const Column(

                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [

                    Icon(

                      Icons.broken_image,

                      color: Colors.white,

                      size: 80,
                    ),

                    SizedBox(
                      height: 16,
                    ),

                    Text(

                      "Impossible de charger l'image",

                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}