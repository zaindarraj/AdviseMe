import 'dart:io';

import 'package:advise_me/logic/BloCs/User%20BloC/user_bloc.dart';
import 'package:advise_me/presentation/image_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../logic/Repos/userRepo.dart';
import '../logic/classes/message.dart';

class FirebaseChat extends StatefulWidget {
  final String session_id;
  final String remoteId;
  final String reciever_name;
  const FirebaseChat(
      {super.key,
      required this.session_id,
      required this.reciever_name,
      required this.remoteId});

  @override
  State<FirebaseChat> createState() => _FirebaseChatState();
}

class _FirebaseChatState extends State<FirebaseChat> {
  TextEditingController? messageInput;
  CollectionReference<Message>? messagesCollection;

  final storageRef = FirebaseStorage.instance.ref();

  final db = FirebaseFirestore.instance;

  void sendImage(File file) async {
    try {
      DocumentReference<Message> doc =
          sendMessage(file.path, "loadingImage", placeHolderImage: file.path);

      final uploadTask = await storageRef.child("images").putFile(file);
      doc.set(Message(
          imagePlaceHolder: file.path,
          message: await uploadTask.ref.getDownloadURL(),
          type: "image",
          server_time: FieldValue.serverTimestamp(),
          sender_id: BlocProvider.of<UserBloc>(context).user.id.toString()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error Occured Uploading the Image")));
    }
  }

  Widget resolveMessage(Message message, Size size) {
    switch (message.type) {
      case "image":
        final file = File(message.imagePlaceHolder!);

        Future<bool> futureBool = file.exists();
        return FutureBuilder(
            future: futureBool,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != true) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  ImagePreview(url: message.message)));
                    },
                    child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        constraints: BoxConstraints(
                            minWidth: 100, maxWidth: size.width * 0.7),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Theme.of(context).primaryColor)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CachedNetworkImage(imageUrl: message.message),
                                Text(message.time_stamp != null
                                    ? "${message.time_stamp!.toDate().toLocal().hour}:${message.time_stamp!.toDate().toLocal().minute}"
                                    : "${DateTime.timestamp().hour}:${DateTime.timestamp().minute}")
                              ],
                            )
                          ],
                        )),
                  );
                } else {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ImagePreview(
                                    file: file,
                                  )));
                    },
                    child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        constraints: BoxConstraints(
                            minWidth: 100, maxWidth: size.width * 0.7),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Theme.of(context).primaryColor)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Image.file(file),
                                Text(message.time_stamp != null
                                    ? "${message.time_stamp!.toDate().toLocal().hour}:${message.time_stamp!.toDate().toLocal().minute}"
                                    : "${DateTime.timestamp().hour}:${DateTime.timestamp().minute}")
                              ],
                            )
                          ],
                        )),
                  );
                }
              }
              return Container();
            });

        break;
      case "loadingImage":
        final file = File(message.imagePlaceHolder!);
        Future<bool> futureBool = file.exists();

        return FutureBuilder<bool>(
            future: futureBool,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == true) {
                  return Padding(
                    padding: EdgeInsets.all(8),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          child: Image.file(file),
                        ),
                        CircularProgressIndicator(),
                      ],
                    ),
                  );
                }
              }
              return Container();
            });

        break;
      case "message":
        return Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            constraints:
                BoxConstraints(minWidth: 100, maxWidth: size.width * 0.7),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Theme.of(context).primaryColor)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      message.message,
                      style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).textScaler.scale(19)),
                    )),
                Text(message.time_stamp != null
                    ? "${message.time_stamp!.toDate().toLocal().hour}:${message.time_stamp!.toDate().toLocal().minute}"
                    : "${DateTime.timestamp().hour}:${DateTime.timestamp().minute}")
              ],
            ));
      default:
        return Container();
    }
  }

  void rate(Size size) {
    List<Widget> stars = [];
    TextEditingController feed = TextEditingController();
    var starColor = List.filled(5, Colors.grey);
    var rate = 0;

    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
                padding: const EdgeInsets.all(5),
                width: size.width * 0.8,
                height: size.height * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.leave_rating,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.arvo(fontSize: 23),
                    ),
                    StatefulBuilder(builder: (context, setRating) {
                      stars = [];
                      for (int i = 0; i < 4; i++) {
                        stars.add(IconButton(
                            onPressed: () {
                              setRating(() {
                                for (int j = 0; j < 4; j++) {
                                  if (j <= i) {
                                    starColor[j] = Colors.amber;
                                    rate = j + 1;
                                  } else {
                                    starColor[j] = Colors.grey;
                                  }
                                }
                              });
                            },
                            icon: Icon(
                              Icons.star_rate,
                              color: starColor[i],
                            )));
                      }
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: stars);
                    }),
                    TextField(
                      controller: feed,
                    ),
                    GestureDetector(
                      onTap: () async {
                        Map<String, dynamic> res = await UserRepo.setRate({
                          "user_id": BlocProvider.of<UserBloc>(context).user.id,
                          "ratedUserID": super.widget.remoteId,
                          "message": feed.text.isEmpty ? "" : feed.text,
                          "rate": rate.toString()
                        });
                        print(res);
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: size.height * 0.08,
                        width: size.width * 0.7,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          AppLocalizations.of(context)!.rate,
                          style: GoogleFonts.arvo(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )),
          );
        });
  }

  DocumentReference<Message> sendMessage(String message, String type,
      {String? placeHolderImage}) {
    DocumentReference<Message> documentReference = messagesCollection!.doc();
    documentReference.set(Message(
        imagePlaceHolder: placeHolderImage,
        message: message,
        type: type,
        sender_id: BlocProvider.of<UserBloc>(context).user.id,
        server_time: FieldValue.serverTimestamp()));
    return documentReference;
  }

  @override
  void initState() {
    messageInput = TextEditingController();
    messagesCollection = FirebaseFirestore.instance
        .collection('sessions')
        .doc(widget.session_id)
        .collection("messages")
        .withConverter<Message>(
          fromFirestore: (snapshot, _) => Message.fromJson(snapshot.data()!),
          toFirestore: (message, _) => message.toJson(),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                rate(size);
              },
              icon: const Icon(
                Icons.star,
                color: Colors.amber,
                size: 30,
              ))
        ],
        title: Text(widget.reciever_name),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 9,
            child: FirestoreListView<Message>(
              reverse: true,
              loadingBuilder: (context) {
                return Center(
                  child: LinearProgressIndicator(),
                );
              },
              query:
                  messagesCollection!.orderBy('time_stamp', descending: true),
              itemBuilder: (context, snapshot) {
                Message message = snapshot.data();
                return Align(
                    alignment: message.sender_id ==
                            BlocProvider.of<UserBloc>(context).user.id
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: resolveMessage(message, size));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColorLight))),
                  controller: messageInput,
                )),
                IconButton(
                    onPressed: () {
                      if (messageInput!.text.isNotEmpty) {
                        sendMessage(messageInput!.text, "message");
                      }
                      messageInput!.clear();
                    },
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).primaryColor,
                    )),
                IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      XFile? xfile =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (xfile != null) {
                        sendImage(File(xfile.path));
                      }
                    },
                    icon: Icon(
                      Icons.image,
                      color: Theme.of(context).primaryColor,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
