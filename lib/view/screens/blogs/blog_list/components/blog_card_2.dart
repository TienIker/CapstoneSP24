import 'package:flutter/material.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/view/components/custom_network_image.dart';

class BlogCard2 extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String dateTime;
  final String avtUrl;
  final String ownerName;
  final String time;
  final Function() onTap;

  const BlogCard2({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.dateTime,
    required this.onTap,
    required this.avtUrl,
    required this.ownerName,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 200,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  child: CustomNetworkImage(
                    url: imageUrl,
                    height: 150.0,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const SizedBox(height: 8.0),
                      Expanded(
                        child: Text(
                          title,
                          style: heading2Style,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                            child: CustomNetworkImage(
                              url: avtUrl,
                              height: 15.0,
                              width: 15.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            ownerName,
                            style: const TextStyle(
                              color: kPrimaryColor,
                              fontSize: 12,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Icon(
                            Icons.circle,
                            size: 4,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Expanded(
                            child: Text(
                              time,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
