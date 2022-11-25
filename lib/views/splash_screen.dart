import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stack_questions/views/question_screen.dart';

import '../constants/constants.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {

  @override
  void initState() {
    ref.read(provider).InterNetCheck();
    // ref.read(provider).firstLoad();
    // print(ref.watch(provider).result);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset('assets/logo.png'),
      title: Text("Stack Questions", style: TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold
      ),),
      logoWidth: 150,
      backgroundColor: Colors.white,
      showLoader: false,
      navigator: QuestionScreen(),
      durationInSeconds: 3,
    );
  }
}
