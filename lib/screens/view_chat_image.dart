import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:unione/api/apis.dart';
import 'package:unione/utils/date_time_util.dart';

class ViewChatImage extends StatefulWidget {
  final String imgUrl;
  final String username;
  final String time;
  const ViewChatImage(
      {required this.imgUrl,
      super.key,
      required this.username,
      required this.time});

  @override
  State<ViewChatImage> createState() => _ViewChatImageState();
}

class _ViewChatImageState extends State<ViewChatImage> {
  bool hideAppBar = false;

  @override
  void initState() {
    setState(() {});
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    Future.delayed(Duration(milliseconds: 1)).then(
      (value) => SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Color.fromARGB(81, 0, 0, 0),
          systemNavigationBarColor: Color.fromARGB(81, 0, 0, 0),
        ),
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  hideAppBar = !hideAppBar;
                });
              },
              child: PhotoView(
                minScale: PhotoViewComputedScale.contained * 1,
                maxScale: PhotoViewComputedScale.covered * 7,
                initialScale: PhotoViewComputedScale.contained,
                basePosition: Alignment.center,
                imageProvider: CachedNetworkImageProvider(widget.imgUrl),
              ),
            ),
            Positioned(
              top: 0,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: hideAppBar ? 0.0 : 1.0,
                child: Container(
                  color: Color.fromARGB(81, 0, 0, 0),
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.username,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          Text(
                            DateUtil.getFormattedTime(context, widget.time),
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
