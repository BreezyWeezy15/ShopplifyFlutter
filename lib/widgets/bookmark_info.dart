import 'package:flutter/cupertino.dart';

class BookmarkIcon extends StatelessWidget {
  final bool isAdded;
  final VoidCallback onTap;

  const BookmarkIcon({
    Key? key,
    required this.isAdded,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String bookMarkImage = isAdded ? "assets/images/bookmark_filled.png" : "assets/images/bookmark_unfilled.png";

    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        bookMarkImage,
        width: 30,
        height: 30,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}