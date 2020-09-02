import 'package:flutter/material.dart';
import 'package:idomuss/components/feed_clipper.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/screens/home/feed.dart';

class FeedDetails extends StatelessWidget {
  bool premium;
  List<int> limite;
  String servico;
  int curtidas;

  FeedDetails(this.curtidas, this.servico, this.limite, this.premium);

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  child: Column(
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
                            child: Icon(
                          Icons.favorite,
                          color: ColorSys.primary,
                        )),
                      ),
                      Text(curtidas.toString()),
                    ],
                  ),
                  onTap: () {},
                )),
            SizedBox(
              height: 30,
            ),
            Expanded(
              flex: 1,
              child: Text(
                servico,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Icon(
                    Icons.monetization_on,
                    color: ColorSys.primary,
                  ),
                  Text(
                    "R\$" +
                        limite[0].toStringAsFixed(2) +
                        " ~ " +
                        limite[1].toStringAsFixed(2),
                    style: TextStyle(
                        color: ColorSys.black, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            //Image.asset("assets/geral/premium.png")
          ],
        ),
      ),
    );
  }
}
