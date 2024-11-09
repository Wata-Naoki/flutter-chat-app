import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mychatapp/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ChatApp',
        theme: ThemeData(
          primarySwatch: Colors.blue, // AppBarの背景色を青に設定
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.blue, foregroundColor: Colors.white),
        ),
        home: LoginPage());
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String infoText = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ログイン'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // メールアドレス
                    TextFormField(
                      decoration: InputDecoration(labelText: 'メールアドレス'),
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                    ),
                    SizedBox(height: 32.0),
                    // パスワード入力
                    TextFormField(
                      decoration: InputDecoration(labelText: 'パスワード'),
                      obscureText: true,
                      onChanged: (value) => {
                        setState(() {
                          password = value;
                        })
                      },
                    ),

                    Container(
                        padding: EdgeInsets.all(16), child: Text(infoText)),
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        width: double.infinity,
                        height: 80,
                        child: ElevatedButton(
                            child: Text('ユーザー登録'),
                            onPressed: () async {
                              try {
                                final FirebaseAuth auth = FirebaseAuth.instance;
                                final result =
                                    await auth.createUserWithEmailAndPassword(
                                        email: email, password: password);

                                await Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) {
                                  return ChatPage(result.user!);
                                }));
                              } catch (e) {
                                setState(() {
                                  infoText = "登録に失敗しました：${e.toString()}";
                                });
                              }
                            })),
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        width: double.infinity,
                        height: 80,
                        child: OutlinedButton(
                            child: Text('ログイン'),
                            onPressed: () async {
                              try {
                                final FirebaseAuth auth = FirebaseAuth.instance;
                                final result =
                                    await auth.signInWithEmailAndPassword(
                                        email: email, password: password);

                                await Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) {
                                  return ChatPage(result.user!);
                                }));
                              } catch (e) {
                                setState(() {
                                  infoText = 'ログインに失敗しました：${e.toString()}';
                                });
                              }
                            }))
                  ],
                )),
              ],
            ),
          ),
        ));
  }
}

class ChatPage extends StatelessWidget {
  ChatPage(this.user);
  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('チャット'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }),
              );
            },
          )
        ],
      ),
      body: Center(
        child: Text('ログイン情報：${user.email}'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return AddPostPage(user);
            }),
          );
        },
      ),
    );
  }
}

class AddPostPage extends StatefulWidget {
  AddPostPage(this.user);
  final User user;

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  String messageText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('チャット投稿'),
      ),
      body: Center(
          child: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: '投稿メッセージ'),
            )
          ],
        ),
      )),
    );
  }
}
