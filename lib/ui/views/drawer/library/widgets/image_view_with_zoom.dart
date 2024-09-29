import 'package:flutter/material.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';

class ImageViewWidget extends StatelessWidget {
  const ImageViewWidget({super.key, required this.imagePath, required this.fileName});

  final String imagePath;
  final String fileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_rounded, color: Theme.of(context).disabledColor),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Text(
                  fileName,
                  style: w500_15Poppins(color: Theme.of(context).disabledColor),
                )
              ],
            ),
            // SizedBox(height: MediaQuery.of(context).size.height * 0.25,),
            const Spacer(),
            SizedBox(
              height: ScreenConfig.height * 0.7,
              width: ScreenConfig.width,
              child: InteractiveViewer(
                panEnabled: false,
                boundaryMargin: const EdgeInsets.all(20.0),
                minScale: 0.1,
                maxScale: 5,
                child: Image.network(
                  imagePath,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
