import 'package:flutter/material.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/view/components/custom_network_image.dart';

class EventCard2 extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String dateTime;
  final String address;
  final int attendeeCount;
  final Function() onTap;

  const EventCard2({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.dateTime,
    required this.address,
    required this.attendeeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 300,
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
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        dateTime,
                        style: const TextStyle(
                          color: kPrimaryColor,
                        ),
                      ),
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
                          Expanded(
                            child: Text(
                              address,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey[600],
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
