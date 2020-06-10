import 'package:flutter/material.dart';
import 'package:idomuss/components/feed_clipper.dart';
import 'package:idomuss/helpers/ColorsSys.dart';

class FeedDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: FeedClipper(),
      child: Container(
        height: 180.0,
        padding: const EdgeInsets.only(
            left: 20.0, right: 16.0, top: 24.0, bottom: 12.0),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                child:Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.4), width: 2.0),
                    ),
                    height: 40.0,
                    width: 40.0,
                    child: Center(
                        child: Icon(Icons.favorite, color: ColorSys.primary,)),
                  ),
                  Text("54"),
                ],
              ),
              onTap: (){
                
              },
              )
            ),
            
          ],
        ),
      ),
    );
  }
}


