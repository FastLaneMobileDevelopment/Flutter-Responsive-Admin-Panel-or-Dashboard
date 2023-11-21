import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:yupcity_admin/constants.dart';
import 'package:yupcity_admin/controllers/CurrentMenuController.dart';
import 'package:yupcity_admin/models/events/LanguageEvent.dart';
import 'package:yupcity_admin/models/events/LogoutEvent.dart';
import 'package:yupcity_admin/screens/login_page.dart';
import 'package:yupcity_admin/screens/main/main_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:event_bus/event_bus.dart';
import 'package:yupcity_admin/screens/recovery_password.dart';
import 'package:yupcity_admin/screens/register_page.dart';
import 'package:yupcity_admin/services/http_overries.dart';
import 'package:yupcity_admin/services/local_storage_service.dart';
import 'package:yupcity_admin/services/login_service.dart';
import 'package:yupcity_admin/services/navigator_service.dart';
import 'package:yupcity_admin/i18n.dart';

import 'services/http_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    HttpOverrides.global = MyHttpOverrides();

  }
  catch(ex)
  {
     debugPrint(ex.toString());
  }

  await setupLocator();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
       runApp(MaterialApp(
           key: GetIt.I.get<NavigationService>().appKey,
           home: MyApp()));
  });

}

Future<void> initializeDefault() async {
  FirebaseApp app = await Firebase.initializeApp(); /*options: FirebaseOptions(apiKey: "AIzaSyANcDoFUuAvrC6EBDblLj0MfYVo3n_O_os",
      appId: "1:907434599832:android:cc9e8ba323645cdf5877ed",
      messagingSenderId: "3861027408", projectId: "yupcity-omnitec", androidClientId: "907434599832-kn6e0gk0sd8qqianviq09kn8h4mrpies.apps.googleusercontent.com")); */
  assert(app != null);
  print('Initialized default app $app');
}

class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _locale = "en";

  @override
  void initState() {
    _registerEvents();
    super.initState();
  }

  void _registerEvents() async {
    GetIt.I.get<EventBus>().on<LanguageEvent>().listen((event) {
      if (mounted) {
        setState(() {
          _locale = event.currentLanguage;
        });
      }
    });

    GetIt.I.get<EventBus>().on<LogoutEvent>().listen((event) {
        setState(() {
        });
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: GetIt.I.get<NavigationService>().navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Admin Panel',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      localizationsDelegates: const [
        I18nDelegate(),
        // ... app-specific localization delegate[s] here
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      locale: Locale(_locale),
      routes: {
        NavigationService.registerPage: (BuildContext context) => const RegisterScreenPage(),
        NavigationService.recoverPage: (BuildContext context) => const RecoverLoginPage(),
      },
      supportedLocales: I18nDelegate.supportedLocals,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => CurrentMenuController(),
          ),
        ],
        child:  FutureBuilder<bool>(
            future: LoginService.CheckLogin(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (!snapshot.hasData) {
                return LoginScreenPage();
              }
              if (snapshot.data == false)
              {
                return  LoginScreenPage();
              }
              else {
                return  MainScreen();
              }
            }),
      ),
    );

  }
}
Future setupLocator() async {


  await initializeDefault();
  GetIt locator = GetIt.I;
  try {
    locator.registerSingleton<LocalStorageService>( await LocalStorageService.getInstance());
    locator.registerSingleton<EventBus>(EventBus());
    locator.registerSingleton<NavigationService>(NavigationService());
    locator.registerSingleton<HttpClient>(HttpClient());
    locator.registerSingleton<CurrentMenuController>(CurrentMenuController());
    locator.registerSingleton<FirebaseAnalytics>(FirebaseAnalytics.instance);
    return Future.value(true);
  } catch (e) {
    debugPrint(e.toString());
  }
}