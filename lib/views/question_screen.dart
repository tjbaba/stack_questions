import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../constants/constants.dart';
import 'answer_screen.dart';

class QuestionScreen extends ConsumerStatefulWidget {
  const QuestionScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends ConsumerState<QuestionScreen> {
  late ScrollController _controller;
  late StreamSubscription subscription;
  bool isDeviceConnected = false;



  @override
  void initState() {
    super.initState();
    getConnectivity();

    _controller = ScrollController();
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
            (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected) {
            print("changed");
           ref.read(provider).InterNetCheck();
            setState(() {});
          } else {
            ref.read(provider).InterNetCheck();
            setState(() {

            });
          }
        },
      );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.watch(provider).InterNetCheck();
    _controller.addListener(() {
      ref.watch(provider).loadMore(_controller);
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(provider);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: const Image(image: AssetImage("assets/logo.png"),),
          elevation: 1,
          title: const Text("Stack Questions"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          actions: [
           Center(
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: data.result == false? Row(
                 children: [
                   Icon(Icons.circle, color: Colors.red,size: 14,),
                   Text("Offline"),
                 ],
               ): Row(
                 children: [
                   Icon(Icons.circle, color: Colors.green,size: 14,),
                   Text("Online"),
                 ],
               ),
             ),
           )
          ],
        ),
        body: data.isFirstLoadRunning
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Expanded(
                    child: data.postsModel == null? Center(
                      child: Text("No Data Found, Connect with Internet"),
                    ): ListView.builder(
                      controller: _controller,
                      itemCount: data.postsModel!.items.length,
                      itemBuilder: (_, index) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AnswerScreen(
                                        index: index,
                                      )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: data
                                        .postsModel!.items[index].owner.profileImage,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      height:
                                          MediaQuery.of(context).size.width * 0.1,
                                      width:
                                          MediaQuery.of(context).size.width * 0.1,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 0.3),
                                        borderRadius: BorderRadius.circular(5),
                                        color: data
                                            .postsModel!.items[index].isAnswered? const Color(0xff5eba7d): Colors.white
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                                        child: Text(data
                                            .postsModel!.items[index].score.toString(), style: TextStyle(
                                          color:  data
                                              .postsModel!.items[index].isAnswered? Colors.white: Colors.black54, fontWeight: FontWeight.bold
                                        ),),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Expanded(
                                child: Card(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "${data.postsModel!.items[index].owner.displayName.toString().split(' ')[0]}",
                                              style: const TextStyle(
                                                  color: Colors.black38,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              " asked at ${timeago.format(DateTime.fromMillisecondsSinceEpoch(data.postsModel!.items[index].creationDate * 1000))}",
                                              style: const TextStyle(
                                                  color: Colors.black26),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                          child: Text(
                                            data.postsModel!.items[index].title,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.message, color: Colors.black26,size: 16,),
                                            Expanded(
                                              child: Text(
                                                  " ${data.postsModel!.items[index].answerCount} in ${data.postsModel!.items[index].tags.toString().replaceAll(']', '').replaceAll('[', '')}",
                                              style: const TextStyle(
                                                color: Colors.black38
                                              ), overflow: TextOverflow.ellipsis, maxLines: 1,),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // when the _loadMore function is running
                  if (data.isLoadMoreRunning == true)
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 25),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),

                  // When nothing else to load
                  if (data.hasNextPage == false)
                    Container(
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      color: Colors.amber,
                      child: const Center(
                        child: Text('You have fetched all of the content'),
                      ),
                    ),
                ],
              ));
  }

  @override
  void dispose() {
    _controller.removeListener(() {
      ref.read(provider).loadMore(_controller);
    });
    super.dispose();
  }
}
