import 'package:flutter/material.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // アプリ名
      title: 'ChatApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('ログイン'),
              onPressed: () async {
                await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) {
                    return ChatPage();
                  }),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

// チャット画面用ウィジェット
class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('チャット'),
        actions: [
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                // ログイン画面に遷移とチェット画面を破棄
                await Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }));
              })
        ],
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('戻る'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}

// 投稿画面用ウィジェット
class AddPostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('チャット投稿'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('戻る'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
