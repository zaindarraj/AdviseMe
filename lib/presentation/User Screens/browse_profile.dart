import 'package:advise_me/logic/classes/consts.dart';
import 'package:advise_me/logic/classes/porfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'browse_schedules.dart';

class BrowseConProfile extends StatefulWidget {
  ProfileModel profileModel;
  BrowseConProfile({super.key, required this.profileModel});

  @override
  State<BrowseConProfile> createState() => _BrowseConProfileState();
}

class _BrowseConProfileState extends State<BrowseConProfile> {
  @override
  void initState() {
    super.initState();
  }

  String? path;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(widget.profileModel.userImage);
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: SizedBox(
              width: size.width * 0.9,
              height: size.height,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        height: 120,
                        width: 120,
                        margin: const EdgeInsets.all(8),
                        child: ClipOval(
                            child: (widget.profileModel.userImage != null
                                ? Image.network(
                                    mainUrl + widget.profileModel.userImage!,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    "assets/default.jpg",
                                    fit: BoxFit.cover,
                                  )))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.profileModel.fname} ${widget.profileModel.lname}",
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                        Text(
                          widget.profileModel.spec is String
                              ? "* ${widget.profileModel.spec!}"
                              : AppLocalizations.of(context)!.not_spec,
                          overflow: TextOverflow.fade,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 18),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.price_dotted,
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.profileModel.price.toString(),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.star_rate,
                                  color: Colors.yellow,
                                  size: 40,
                                ),
                                Text(
                                  widget.profileModel.rate,
                                  style: const TextStyle(fontSize: 18),
                                )
                              ],
                            ),
                            Text(
                              AppLocalizations.of(context)!.feedbacks,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(
                          width: size.width * 0.7,
                          child: Text(
                            widget.profileModel.bio is String
                                ? widget.profileModel.bio!
                                : AppLocalizations.of(context)!.not_spec,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 20),
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      flex: 4,
                      child: widget.profileModel.feedbacks!.isEmpty
                          ? Center(
                              child: Text(
                                  AppLocalizations.of(context)!.no_feedbacks),
                            )
                          : ListView.builder(
                              itemCount: widget.profileModel.feedbacks!.length,
                              itemBuilder: (context, index) {
                                return Container(
                                    margin: const EdgeInsets.all(7),
                                    padding: const EdgeInsets.all(10),
                                    width: size.width * 0.85,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 10,
                                            offset: Offset(2, 2))
                                      ],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: size.width * 0.2,
                                              height: size.height * 0.1,
                                              child: ClipOval(
                                                  child: (widget.profileModel
                                                              .feedbacks![index]
                                                          ["user_img"] is String
                                                      ? Image.network(
                                                          mainUrl +
                                                              widget
                                                                  .profileModel
                                                                  .feedbacks![
                                                                      index][
                                                                      "user_img"]
                                                                  .toString(),
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.asset(
                                                          "assets/default.jpg",
                                                          fit: BoxFit.cover,
                                                        ))),
                                            ),
                                            Text(
                                              widget.profileModel
                                                          .feedbacks![index]
                                                      ["fname"] +
                                                  " " +
                                                  widget.profileModel
                                                          .feedbacks![index]
                                                      ["lname"],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              widget.profileModel
                                                  .feedbacks![index]["message"],
                                              textAlign: TextAlign.center,
                                              maxLines: 6,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.arvo(
                                                  fontSize: 16),
                                            ),
                                          ),
                                        )
                                      ],
                                    ));
                              }),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (contex) => BrowseSchedules(
                                      conID: widget.profileModel.id)));
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).primaryColor,
                            ),
                            alignment: Alignment.center,
                            width: size.width,
                            height: size.height * 0.05,
                            child: Text(
                              AppLocalizations.of(context)!.book,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                            )))
                  ],
                ),
              )),
        ));
  }
}
