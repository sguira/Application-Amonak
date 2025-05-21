import 'dart:convert';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/accueils/home.dart';
import 'package:application_amonak/interface/accueils/home_tab_menu.dart';
import 'package:application_amonak/interface/accueils/welcome.dart';
import 'package:application_amonak/local_storage.dart';
import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/prod.dart';
import 'package:application_amonak/services/auths.dart';
import 'package:application_amonak/services/socket/chatProvider.dart';
import 'package:application_amonak/services/socket/publication.dart';
import 'package:application_amonak/services/user.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:application_amonak/services/socket/commentSocket.dart';
import 'package:application_amonak/services/socket/notificationSocket.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Notificationsocket notificationsocket;
  bool isAuth = false;
  bool loading = true;
  veriticationUserIsConnect() async {
    await LocalStorage.getToken().then((value) {
      if (value != null) {
        tokenValue = value;
      }
    }).catchError((e) {
      setState(() {
        loading = false;
        isAuth = false;
      });
    });

    try {
      if (tokenValue != null) {
        await LocalStorage.getDateTokenTimeout().then((value) {
          if (value != null) {
            print("La date est ${value}");
            if (DateTime.parse(value).isAfter(DateTime.now())) {
              // loadData();
              LocalStorage.getUserId().then((value) async {
                if (value != null) {
                  UserService.getUser(userId: value).then((value) {
                    if (value.statusCode == 200) {
                      DataController.user =
                          User.fromJson(jsonDecode(value.body));
                      print("ok ok");
                      setState(() {
                        isAuth = true;
                        loading = false;
                      });
                    }
                  });
                }
              }).catchError((e) {
                setState(() {
                  loading = false;
                  isAuth = false;
                });
              });
            } else {
              setState(() {
                loading = false;
                isAuth = false;
              });
            }
          } else {
            setState(() {
              loading = false;
            });
          }
        });
      } else {
        setState(() {
          loading = false;
          isAuth = false;
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
        isAuth = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // notificationsocket=Notificationsocket();
    veriticationUserIsConnect();
  }

  @override
  void dispose() {
    notificationsocket.dispose();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ScreenSize.width = MediaQuery.of(context).size.width;
    ScreenSize.height = MediaQuery.of(context).size.height;
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        routes: {'/home': (context) => const HomePageTab()},
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: loading == true
            ? const Loading()
            : !isAuth
                ? const WelcomePage()
                : const HomePageTab());
  }
}

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset("assets/icons/amonak.png"),
            ),
            Container(
              child: LoadingAnimationWidget.newtonCradle(
                color: couleurPrincipale,
                size: 36,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
