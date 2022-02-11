import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_training_2/main.dart';

// 投稿画面用Widget
// ConsumerWidgetでProviderから値を受け渡す
class AddPostPage extends ConsumerWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Providerから値を受け取る
    final user = ref.watch(userProvider)!;
    final messageText = ref.watch(messageTextProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('チャット投稿'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: '投稿メッセージ'),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onChanged: (String value) {
                  // Providerから値を更新
                  //context.read(messageTextProvider).state = value;
                  ref.read(messageTextProvider.state).update((state) => value);
                },
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text('投稿'),
                  onPressed: () async {
                    final date = DateTime.now().toLocal().toIso8601String();
                    final email = user.email;
                    await FirebaseFirestore.instance
                        .collection('posts')
                        .doc()
                        .set({
                      'text': messageText,
                      'email': email,
                      'date': date
                    });
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
/*
class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  // 入力した投稿メッセージ
  String messageText = '';

  @override
  Widget build(BuildContext context) {
    // Provider.of<T>(context) で親Widgetから
    // ユーザー情報を受け取る
    final UserState userState = Provider.of<UserState>(context);
    final User user = userState.user!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('チャット投稿'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 投稿メッセージ入力
              TextFormField(
                decoration: const InputDecoration(labelText: '投稿メッセージ'),
                // 複数行のテキスト入力
                keyboardType: TextInputType.multiline,
                // 最大3行
                maxLines: 3,
                onChanged: (String value) {
                  setState(() {
                    messageText = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text('投稿'),
                  onPressed: () async {
                    final date =
                    DateTime.now().toLocal().toIso8601String(); // 現在の日時
                    final email = user.email; // AddPostPage のデータを参照
                    // 投稿メッセージ用ドキュメント作成
                    await FirebaseFirestore.instance
                        .collection('posts') // コレクションID指定
                        .doc() // ドキュメントID自動生成
                        .set({
                      'text': messageText,
                      'email': email,
                      'date': date
                    });
                    // 1つ前の画面に戻る
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
*/