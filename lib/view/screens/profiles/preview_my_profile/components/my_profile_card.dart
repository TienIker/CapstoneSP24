import 'package:flutter/material.dart';

class MyProfileCard extends StatelessWidget {
  final String image;
  final String name;
  final String? description;
  final String age;
  const MyProfileCard({
    super.key,
    required this.image,
    required this.name,
    this.description,
    required this.age,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black, Colors.transparent],
                  stops: [0.0, 1.0]),
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  '$name, $age',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Wrap(
                  children: <Widget>[
                    if (description != null)
                      Text(
                        description!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
