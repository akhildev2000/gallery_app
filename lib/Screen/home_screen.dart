import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery/Screen/display_screen.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';

import '../database/dbmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? _imageFile;

  chooseImage(ImageSource src) async {
    final pickedFile = await ImagePicker().pickImage(source: src);

    setState(
      () {
        if (pickedFile != null) {
          _imageFile = pickedFile;
          Hive.box<Gallery>('gallery').add(
            Gallery(imagePath: _imageFile?.path),
          );
        }
      },
    );
    if (_imageFile != null) {
      File(_imageFile!.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(212, 233, 229, 229),
      appBar: AppBar(
          title: const Text('Gallery'),
          centerTitle: true,
          elevation: 20,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
          backgroundColor: Colors.purple),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Gallery>('gallery').listenable(),
        builder: (context, Box<Gallery> box, widget) {
          List keys = box.keys.toList();
          if (keys.isEmpty) {
            return const Center(
              child: Text(
                "Click on the 'Camera icon' to add images ",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple),
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 160,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (context, index) {
              List<Gallery>? data = box.values.toList();
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DisplayImage(
                        image: data[index].imagePath, index: index),
                  ));
                },
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: const Text(
                        'Do you want to delete the image?',
                        style: TextStyle(color: Colors.red),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () {
                            data[index].delete();
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: Colors.purple,
                        width: 1,
                        style: BorderStyle.solid),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(
                        File(
                          data[index].imagePath!,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: keys.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 100,
        backgroundColor: Colors.purple,
        onPressed: () {
          chooseImage(ImageSource.camera);
        },
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.purple,
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 50),
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.photo,
                    color: Colors.white,
                    size: 30,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 50),
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.photo_library_outlined,
                    color: Colors.white,
                    size: 30,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
