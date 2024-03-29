import 'package:flutter/material.dart';

class DiscountBanner extends StatelessWidget {
  const DiscountBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        // image: const DecorationImage(
        //     fit: BoxFit.cover, image: AssetImage("assets/images/cafe.png")),
        color: const Color(0xFFA4634D),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text.rich(
        TextSpan(
          style: TextStyle(color: Colors.white),
          children: [
            TextSpan(
              text: "Hãy kết bạn và trò chuyện với mọi người ngay bây giờ!\n",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
                text: "Tham gia",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ))
          ],
        ),
      ),
    );
  }
}
