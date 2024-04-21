import 'package:flutter/material.dart';
import 'package:sharing_cafe/constants.dart';

class EventCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String dateTime;
  final String address;
  final int attendeeCount;
  final Function() onTap;
  final Function()? onMoreButtonClick;
  final GlobalKey? moreButtonKey;

  const EventCard(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.dateTime,
      required this.address,
      required this.attendeeCount,
      required this.onTap,
      this.onMoreButtonClick,
      this.moreButtonKey});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                child: Image.network(
                  imageUrl,
                  height: 150.0,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 8.0),
                  Text(
                    dateTime,
                    style: const TextStyle(
                      color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(title, style: heading2Style),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: kPrimaryColor,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        address,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        '$attendeeCount người sẽ tham gia',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      // 3 dot button
                      const Spacer(),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
