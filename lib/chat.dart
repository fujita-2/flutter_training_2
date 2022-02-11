import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_training_2/main.dart';

// チャット画面用Widget
class ChatPage extends ConsumerWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Providerから値を受け取る
    final User user = ref.watch(userProvider)!;
    final AsyncValue<QuerySnapshot> asyncPostsQuery = ref.watch(postsQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('チャット'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              /*
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }),
              );
              */
              await Navigator.of(context).pushReplacementNamed('/login',);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Text('ログイン情報：${user.email}'),
          ),
          Expanded(
            // StreamProviderから受け取った値は .when() で状態に応じて出し分けできる
            child: asyncPostsQuery.when(
              // 値が取得できたとき
              data: (QuerySnapshot query) {
                return ListView(
                  children: query.docs.map((document) {
                    return Card(
                      child: ListTile(
                        title: Text(document['text']),
                        subtitle: Text(document['email']),
                        trailing: document['email'] == user.email
                            ? IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            // 投稿メッセージのドキュメントを削除
                            await FirebaseFirestore.instance
                                .collection('posts')
                                .doc(document.id)
                                .delete();
                          },
                        )
                            : null,
                      ),
                    );
                  }).toList(),
                );
              },
              // 値が読込中のとき
              loading: () {
                return const Center(
                  child: Text('読込中...'),
                );
              },
              // 値の取得に失敗したとき
              error: (e, stackTrace) {
                return Center(
                  child: Text(e.toString()),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          /*
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return AddPostPage();
            }),
          );
          */
          await Navigator.of(context).pushReplacementNamed('/add_post',);
        },
      ),
    );
  }
}
/*
class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Provider.of<T>(context) で親Widgetから
    // ユーザー情報を受け取る
    final UserState userState = Provider.of<UserState>(context);
    final User user = userState.user!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('チャット'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // ログアウト処理
              // 内部で保持しているログイン情報等が初期化される
              // （現時点ではログアウト時はこの処理を呼び出せばOKと、思うぐらいで大丈夫です）
              await FirebaseAuth.instance.signOut();
              // ログイン画面に遷移＋チャット画面を破棄
              /*
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) {
                  return const LoginPage();
                }),
              );
              */
              await Navigator.pushReplacementNamed(context, '/login',);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Text('ログイン情報：${user.email}'),
          ),
          Expanded(
            // StreamBuilder
            // 非同期処理の結果を元にWidgetを作れる
            child: StreamBuilder<QuerySnapshot>(
              // 投稿メッセージ一覧を取得（非同期処理）
              // 投稿日時でソート
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('date')
                  .snapshots(),
              builder: (context, snapshot) {
                // データが取得できた場合
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> documents = snapshot.data!.docs;
                  // 取得した投稿メッセージ一覧を元にリスト表示
                  return ListView(
                    children: documents.map((document) {
                      return Card(
                        child: ListTile(
                          title: Text(document['text']),
                          subtitle: Text(document['email']),
                          // 自分の投稿メッセージの場合は削除ボタンを表示
                          trailing: document['email'] == user.email
                              ? IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              // 投稿メッセージのドキュメントを削除
                              await FirebaseFirestore.instance
                                  .collection('posts')
                                  .doc(document.id)
                                  .delete();
                            },
                          )
                              : null,
                        ),
                      );
                    }).toList(),
                  );
                }
                // データが読込中の場合
                return const Center(
                  child: Text('読込中...'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // 投稿画面に遷移
          /*
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return const AddPostPage();
            }),
          );
          */
          await Navigator.pushNamed(context, '/add_post',);
        },
      ),
    );
  }
}
*/