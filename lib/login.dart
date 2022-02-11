import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_training_2/main.dart';

// ConsumerWidgetでProviderから値を受け渡す
class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

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
                child: OutlinedButton(
                  child: const Text('ログイン'),
                  onPressed: () async {
                    try {
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      await auth.signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
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
                      //"ログインに失敗しました：${e.toString()}";
                      ref.read(infoTextProvider.state).update((state) => "ログインに失敗しました：${e.toString()}");
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
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // 入力されたメールアドレス（ログイン）
  String loginUserEmail = "";
  // 入力されたパスワード（ログイン）
  String loginUserPassword = "";
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

              /* ログイン */
              TextFormField(
                decoration: const InputDecoration(labelText: "メールアドレス"),
                onChanged: (String value) {
                  setState(() {
                    loginUserEmail = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "パスワード"),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    loginUserPassword = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  try {
                    // メール/パスワードでログイン
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    final UserCredential result =
                    await auth.signInWithEmailAndPassword(
                      email: loginUserEmail,
                      password: loginUserPassword,
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
                    // ログインに失敗した場合
                    setState(() {
                      infoText = "ログインNG：${e.toString()}";
                    });
                  }
                },
                child: const Text("ログイン"),
              ),
              Text(infoText),
              const SizedBox(height: 24),
              ElevatedButton(
                  child: const Text('新規登録'),
                  onPressed:() {
                    /*
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context)=>const SignUpPage()
                        )
                    );
                    */
                    Navigator.pushNamed(context, '/sign_up',);
                  }
              ),
              const SizedBox(height: 8),

            ],
          ),
        ),
      ),
    );
  }
}
*/