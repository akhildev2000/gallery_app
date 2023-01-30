import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery/Screen/home_screen.dart';
import 'package:gallery/database/dbmodel.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:photo_view/photo_view.dart';

class DisplayImage extends StatelessWidget {
  final String? image;
  final int index;

  const DisplayImage({Key? key, required this.image, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(212, 233, 229, 229),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('Back To Gallery'),
        centerTitle: true,
        actions: [
          InkWell(
            child: const Icon(
              Icons.delete,
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: ((context) => AlertDialog(
                        content:
                            const Text('Do you want to delete the image ?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('CANCEL'),
                          ),
                          TextButton(
                              onPressed: () {
                                Hive.box<Gallery>('gallery').deleteAt(index);
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen()),
                                    (Route<dynamic> route) => false);
                              },
                              child: const Text('OK'))
                        ],
                      )));
            },
          )
        ],
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: PhotoView(
                      backgroundDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      imageProvider: FileImage(
                        File(image!),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
