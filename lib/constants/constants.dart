import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../state/questions/providers/question_provider.dart';

@immutable
class Constants {
  static const baseUrl = 'https://api.stackexchange.com/2.3/questions';
  const Constants._();
}

final provider = ChangeNotifierProvider((ref) => QuestionProvider());