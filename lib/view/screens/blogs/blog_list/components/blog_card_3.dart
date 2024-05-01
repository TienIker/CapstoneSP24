import 'package:flutter/material.dart';
import 'package:sharing_cafe/view/components/custom_network_image.dart';

class BlogCard3 extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String number;
  final Function() onTap;

  const BlogCard3({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.onTap,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 200,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            child: Stack(
              children: [
                CustomNetworkImage(
                  url: imageUrl,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text("$number blogs",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
