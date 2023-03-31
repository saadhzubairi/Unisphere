import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ViewProfileImage extends StatelessWidget {
  final String imgUrl;
  const ViewProfileImage({required this.imgUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Image",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1),
        child: Center(
          child: InkWell(
            //onTap: () => Navigator.of(context).pop(),
            onTapDown: (TapDownDetails details) {
              Navigator.of(context).pop();
            },
            child: Hero(
              tag: 'image',
              child: CachedNetworkImage(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                fit: BoxFit.fill,
                imageUrl: imgUrl,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.person),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
