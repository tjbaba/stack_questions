import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/constants.dart';
import 'package:timeago/timeago.dart' as timeago;


class AnswerScreen extends ConsumerStatefulWidget {
  final index;
  const AnswerScreen({Key? key, required this.index}) : super(key: key);

  @override
  ConsumerState<AnswerScreen> createState() => _AnswerScreenState();
}

class _AnswerScreenState extends ConsumerState<AnswerScreen> {
  @override
  void initState() {
    ref.read(provider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(provider);

    Future<void> _launchInBrowser(Uri url) async {
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      )) {
        throw 'Could not launch $url';
      }
    }



    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Answer"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: data.postsModel!.items[widget.index].owner.profileImage,
                    imageBuilder: (context, imageProvider) => Container(
                      height: 30, width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,),
                      ),
                    ),
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Text(
                        data.postsModel!.items[widget.index].title,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "${data.postsModel!.items[widget.index].owner.displayName.toString().split(' ')[0]}",
                    style: const TextStyle(
                        color: Colors.black38,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    " asked at ${timeago.format(DateTime.fromMillisecondsSinceEpoch(data.postsModel!.items[widget.index].creationDate * 1000))}",
                    style: const TextStyle(
                        color: Colors.black26),
                  ),
                ],
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child:
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                  MarkdownBody(

                      onTapLink: (String text, String? href, String title) =>
                          _launchInBrowser(Uri.parse(href!)),
                      data: HtmlUnescape().convert(data
                          .postsModel!.items[widget.index].bodyMarkdown)),
                )
              ),
              Divider(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  'Answers',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
              ...(data.postsModel!.items[widget.index].answers ?? []).map((answer) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl: "${answer['owner']['profile_image']}",
                            imageBuilder: (context, imageProvider) => Container(
                              height: 30, width: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,),
                              ),
                            ),
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                          const Icon(Icons.arrow_drop_up_sharp, color: Colors.black26, size: 30,),
                          Text("${answer['score']}"),
                          const Icon(Icons.arrow_drop_down_sharp, color: Colors.black26,size: 30,),
                          answer['is_accepted'] ? const Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Icon(Icons.check_circle, color: Colors.green,),
                          ): const SizedBox()
                        ],
                      ),
                      Expanded(child: Column(
                        children: [
                          Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: answer['is_accepted']? const Color(0xffcefad0): Colors.white,
                              child:  Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MarkdownBody(
                                    onTapLink: (String text, String? href, String title) =>
                                        _launchInBrowser(Uri.parse(href!)),
                                    data: HtmlUnescape().convert(answer['body_markdown'])),
                              )
                          ),
                          Row(
                            children: [
                              Text(
                                "${answer['owner']['display_name'].toString().split(' ')[0]}",
                                style: const TextStyle(
                                    color: Colors.black38,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                " answered at ${timeago.format(DateTime.fromMillisecondsSinceEpoch(answer['creation_date'] * 1000))}",
                                style: const TextStyle(
                                    color: Colors.black26),
                              ),
                            ],
                          ),
                        ],
                      )),
                    ],
                  ),
                );
              }),
              data.postsModel!.items[widget.index].answers.length == 0? Center(
                child: Text("No Answer Yet"),
              ): SizedBox(),
              SizedBox(height: 30,)
            ],
          ),
        ),
      ),
    );
  }
}
