import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_training_2/login.dart';
import 'package:flutter_training_2/sign_up.dart';
import 'package:flutter_training_2/chat.dart';
import 'package:flutter_training_2/add_post.dart';

// ユーザー情報の受け渡しを行うためのProvider
final userProvider = StateProvider((ref) {
  return FirebaseAuth.instance.currentUser;
});

// エラー情報の受け渡しを行うためのProvider
// ※ autoDisposeを付けることで自動的に値をリセットできます
final infoTextProvider = StateProvider.autoDispose((ref) {
  return '';
});

// メールアドレスの受け渡しを行うためのProvider
// ※ autoDisposeを付けることで自動的に値をリセットできます
final emailProvider = StateProvider.autoDispose((ref) {
  return '';
});

// パスワードの受け渡しを行うためのProvider
// ※ autoDisposeを付けることで自動的に値をリセットできます
final passwordProvider = StateProvider.autoDispose((ref) {
  return '';
});

// メッセージの受け渡しを行うためのProvider
// ※ autoDisposeを付けることで自動的に値をリセットできます
final messageTextProvider = StateProvider.autoDispose((ref) {
  return '';
});

// StreamProviderを使うことでStreamも扱うことができる
// ※ autoDisposeを付けることで自動的に値をリセットできます
final postsQueryProvider = StreamProvider.autoDispose((ref) {
  return FirebaseFirestore.instance
      .collection('posts')
      .orderBy('date')
      .snapshots();
});
/*
class UserState extends ChangeNotifier {
  User? user;

  void setUser(User newUser) {
    user = newUser;
    notifyListeners();  //これを呼ぶと変更が通知される
  }
}
*/
Future<void> main() async {
  // Firebase初期化
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    // Riverpodでデータを受け渡しできる状態にする
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatApp',
      //home: const LoginPage(),
      initialRoute: '/login',
      routes: {
        '/login' : (context) => const LoginPage(),
        '/sign_up' : (context) => const SignUpPage(),
        '/chat' : (context) => const ChatPage(),
        '/add_post' : (context) => const AddPostPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
/*
  // ユーザーの情報を管理するデータ
  final UserState userState = UserState();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserState>(
        create: (context) => UserState(),
        child:MaterialApp(
          title: 'Flutter Demo',
          //home: const LoginPage(),
          initialRoute: '/login',
          routes: {
            '/login' : (context) => const LoginPage(),
            '/sign_up' : (context) => const SignUpPage(),
            '/chat' : (context) => const ChatPage(),
            '/add_post' : (context) => const AddPostPage(),
          },
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
        ),
    );
  }
*/
}