import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxdocs/Auth/Pages/login_screen.dart';
import 'package:taxdocs/Auth/Pages/password_reset.dart';
import 'package:taxdocs/Auth/Pages/register.dart';
import 'package:taxdocs/Database/scan_model.dart';
import 'package:taxdocs/Main/Pages/landing_page.dart';
import 'package:provider/provider.dart';
import 'package:taxdocs/Main/Pages/notifications.dart';
import 'package:taxdocs/Main/Pages/received_docs.dart';
import 'package:taxdocs/Notification/notification_init.dart';
import 'package:taxdocs/Provider/app_state.dart';
import 'package:taxdocs/constant.dart';
import 'Main/Pages/messages.dart';
import 'Main/Pages/scan_page.dart';
import 'Onboarding/Pages/onboarding_main.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'firebase_options.dart';
import 'package:toast/toast.dart';
import 'package:sentry_flutter/sentry_flutter.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey(
    debugLabel: "Main Navigator");

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Stripe.publishableKey = "pk_test_QfiXIJ9KHc8qsJL4h2NySQWr008LUCCkQN";
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Hive.initFlutter();
  Hive.registerAdapter(ScanModelAdapter());

  await FlutterDownloader.initialize(
      debug: true,
      // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );

  bool installed = false;
  SharedPreferences pref = await SharedPreferences.getInstance();

  Stripe.publishableKey = "pk_test_QfiXIJ9KHc8qsJL4h2NySQWr008LUCCkQN";

  if (pref.getBool('installed') != null) {
    installed = true;
  } else {
    installed = false;
  }

  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    final token = await user.getIdToken(true);
    pref.setString('token', token);
  }

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await SentryFlutter.init(
      (option) => {
            option.dsn = 'https://96fc98809ec64387bb315dc8051dda46@o178860.ingest.sentry.io/6654646',
            option.tracesSampleRate = 1.0,
          },
      appRunner: () => runApp(MultiProvider(
            providers: [
              ChangeNotifierProvider<appState>(create: (_) => appState())
            ],
            child: MyApp(
              installed: installed,
              user: user,
            ),
          )));
}

class MyApp extends StatefulWidget {
  final bool? installed;
  final User? user;

  const MyApp({Key? key, this.installed, this.user}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

      void initProvider() async {
      final app = Provider.of<appState>(context, listen: false);
      await app.dataInit().then((value) {
        FlutterNativeSplash.remove();
        app.setLoaderOff();
      });
    }


  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    MyNotification notification = MyNotification(context: context, globalKey: navigatorKey);
    notification.init(widget.user);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      initProvider();
    });

    return OverlaySupport.global(
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('zh'),
          Locale('fr'),
          Locale('es'),
          Locale('de'),
          Locale('ru'),
          Locale('ja'),
          Locale('ar'),
          Locale('fa'),
          Locale("es"),
        ],
        debugShowCheckedModeBanner: false,
        title: '360PC',
        navigatorKey: navigatorKey,
        routes: {
          '/': (context) => !widget.installed!
              ? const OnBoardingMain()
              : widget.user == null
                  ? const LoginPage()
                  : const HomePage(),
          // '/': (context)=> const HomePage(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/passwordreset': (context) => const PasswordReset(),
          '/home': (context) => const HomePage(),
          '/scan': (context) => const ScanPage(),
          '/receivedDocs': (context) => const ReceivedDocs(),
          '/message': (context) => const Message(),
          '/notification': (context) => const NotificationPage()
        },
        theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            scaffoldBackgroundColor: Colors.white,
            // primarySwatch: orangeColor2,
            primaryColor: orangeColor2,
            primarySwatch: Colors.orange,
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            fontFamily: 'Roboto'),
        initialRoute: '/',
      ),
    );
  }
}

//FlutterNativeSplash.remove();
