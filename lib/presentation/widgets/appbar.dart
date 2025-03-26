import 'package:espoir_marketing/core/const.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget myAppbar({List<Widget>? actions}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    automaticallyImplyLeading: true, // Display the default leading widget
    iconTheme:  IconThemeData(
      color:icontheme
    ),
    elevation: 0,
    title:  Padding(
      padding: EdgeInsets.all(8.0),
      child: SizedBox(
        width: 100,
        height: 100,
        child: Image(
          image: AssetImage(
            logoImage,
          ),
        ),
      ),
    ),
    actions: actions ?? [], // Use the provided actions or an empty list
  );
}
