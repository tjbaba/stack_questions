import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stack_questions/constants/constants.dart';
import 'package:stack_questions/state/questions/model/question_model.dart';

class QuestionProvider extends ChangeNotifier {
  int _page = 1;
  final int _limit = 30;
  bool hasNextPage = true;
  bool isFirstLoadRunning = false;
  bool isLoadMoreRunning = false;
  QuestionModel? postsModel;
  List posts=[];
  List cachedPosts = [];
  bool result = false;

  void firstLoad() async {
    final prefs = await SharedPreferences.getInstance();
    isFirstLoadRunning = true;
    try {
      final res = await http.get(Uri.parse(
          "${Constants.baseUrl}?_page=$_page&pagesize=$_limit&order=desc&sort=activity&site=stackoverflow&filter=!6VvPDzPyz3f6q"));
      // var data=jsonDecode(res.body);
      postsModel = questionModelFromJson(res.body);
      await prefs.setString('data', res.body);
    } catch (err) {
      if (kDebugMode) {
        print('$err');
      }
    }
    isFirstLoadRunning = false;
    notifyListeners();
  }

  Future<void> InterNetCheck() async {
    var res = await (Connectivity().checkConnectivity());
    if (res == ConnectivityResult.mobile) {
      result = true;
      firstLoad();
    } else if (res == ConnectivityResult.wifi) {
      result = true;
      firstLoad();
    }
     else {
       result = false;
       cacheLoad();
    }
    // print(result);
  }

  void  loadMore(controller) async {
    if (hasNextPage == true &&
        isFirstLoadRunning == false &&
        isLoadMoreRunning == false &&
        controller.position.extentAfter < 300) {
      isLoadMoreRunning = true;
      notifyListeners();
      _page += 1;
      try {
        final res = await http.get(Uri.parse(
            "${Constants.baseUrl}?_page=$_page&pagesize=$_limit&order=desc&is_answered=true&sort=activity&site=stackoverflow&filter=!95kkh65WFZ)RhgpIx)CICUjWUcI0zc7mF5moTK(msTJOtjUZmFore2f2z5RGtW8a5o1fOtSuXjBXbXbnQWAoExQo_fU89xxwPx)Gi"));

        QuestionModel fetchedPosts;
        fetchedPosts = questionModelFromJson(res.body);
        if (fetchedPosts.items.isNotEmpty) {
          postsModel!.items.addAll(fetchedPosts.items);
        } else {
          hasNextPage = false;
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }
      isLoadMoreRunning = false;
      notifyListeners();
    }
  }

  Future<void> cacheLoad() async {
    final prefs = await SharedPreferences.getInstance();
    postsModel = prefs.getString('data') == null? null: questionModelFromJson(prefs.getString('data')!);
  }

}
