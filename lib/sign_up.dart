import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_training_2/main.dart';

// ConsumerWidgetでProviderから値を受け渡す
class SignUpPage extends ConsumerWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Providerから値を受け取る
    final infoText = ref.watch(infoTextProvider);
    final email = ref.watch(emailProvider);
    final password = ref.watch(passwordProvider);

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'メールアドレス'),
                onChanged: (String value) {
                  // Providerから値を更新
                  //context.read(emailProvider).state = value;
                  ref.read(emailProvider.state).update((state) => value);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'パスワード'),
                obscureText: true,
                onChanged: (String value) {
                  // Providerから値を更新
                  //context.read(passwordProvider).state = value;
                  ref.read(passwordProvider.state).update((state) => value);
                },
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Text(infoText),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text('ユーザー登録'),
                  onPressed: () async {
                    try {
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final result = await auth.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      // ユーザー情報を更新
                      //context.read(userProvider).state = result.user;
                      ref.read(userProvider.state).update((state) => result.user);

                      /*
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return ChatPage();
                        }),
                      );
                      */
                      await Navigator.of(context).pushReplacementNamed('/chat',);
                    } catch (e) {
                      // Providerから値を更新
                      //context.read(infoTextProvider).state =
                      //"登録に失敗しました：${e.toString()}";
                      ref.read(infoTextProvider.state).update((state) => "登録に失敗しました：${e.toString()}");
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/*
// ログイン画面用Widget
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  // 入力されたメールアドレス
  String newUserEmail = "";
  // 入力されたパスワード
  String newUserPassword = "";
  // 登録・ログインに関する情報を表示
  String infoText = "";

  @override
  Widget build(BuildContext context) {
    // Provider.of<T>(context) で親Widgetから
    // ユーザー情報を受け取る
    final UserState userState = Provider.of<UserState>(context);

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              /* 新規登録 */
              TextFormField(
                // テキスト入力のラベルを設定
                decoration: const InputDecoration(labelText: "メールアドレス"),
                onChanged: (String value) {
                  setState(() {
                    newUserEmail = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(labelText: "パスワード（６文字以上）"),
                // パスワードが見えないようにする
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    newUserPassword = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  try {
                    // メール/パスワードでユーザー登録
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    final UserCredential result =
                    await auth.createUserWithEmailAndPassword(
                      email: newUserEmail,
                      password: newUserPassword,
                    );

                    // ユーザー情報を更新
                    userState.setUser(result.user!);
                    // チャット画面に遷移＋ログイン画面を破棄
                    /*
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) {
                        return const ChatPage();
                      }),
                    );
                    */
                    Navigator.of(context).pushReplacementNamed('/chat',);
                  } catch (e) {
                    // 登録に失敗した場合
                    setState(() {
                      infoText = "登録NG：${e.toString()}";
                    });
                  }
                },
                child: const Text("ユーザー登録"),
              ),
              const SizedBox(height: 8),
              Text(infoText),

            ],
          ),
        ),
      ),
    );
  }
}
*/