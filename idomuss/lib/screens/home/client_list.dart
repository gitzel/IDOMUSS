import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class Client_List extends StatefulWidget {
  @override
  _Client_ListState createState() => _Client_ListState();
}

class _Client_ListState extends State<Client_List> {
  @override
  Widget build(BuildContext context) {

    final collection = Provider.of<QuerySnapshot>(context);
    print(collection.documents);
    for (var doc in collection.documents){

    }

    return Container(


    );
  }
}
