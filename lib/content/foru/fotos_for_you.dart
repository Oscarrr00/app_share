import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:foto_share_app/content/foru/item_public.dart';

class FotosForYou extends StatelessWidget {
  const FotosForYou({super.key});

  @override
  Widget build(BuildContext context) {
    return FirestoreListView(
        query: FirebaseFirestore.instance.collection("Fshare").where(
              "public",
              isEqualTo: true,
            ),
        itemBuilder: (context, doc) {
          return ItemPublic(publicFData: doc.data());
        });
  }
}
