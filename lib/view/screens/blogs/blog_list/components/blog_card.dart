import 'package:flutter/material.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/view/components/custom_network_image.dart';

class BlogCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String dateTime;
  final String avtUrl;
  final String ownerName;
  final String time;
  final Function() onTap;
  final Function()? onMoreButtonClick;
  final GlobalKey? moreButtonKey;

  const BlogCard(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.dateTime,
      required this.onTap,
      required this.avtUrl,
      required this.ownerName,
      required this.time,
      this.onMoreButtonClick,
      this.moreButtonKey});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              child: CustomNetworkImage(
                url: imageUrl,
                height: 128.0,
                width: 128.0,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 8.0),
                  Text(
                    title,
                    style: heading2Style,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
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
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    time,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (onMoreButtonClick != null)
              IconButton(
                key: moreButtonKey,
                icon: const Icon(
                  Icons.more_vert,
                  color: kPrimaryColor,
                ),
                onPressed: onMoreButtonClick,
              ),
          ],
        ),
      ),
    );
  }
}
