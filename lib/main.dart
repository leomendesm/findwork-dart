import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphqlex/pages/forms/project.dart';
import 'package:graphqlex/pages/home.dart';
import 'package:graphqlex/pages/signin/signin.dart';
// ignore: unused_import
import 'package:graphqlex/pages/welcome/welcome.dart';

// variável global para criar rota fora do contexto (onboarding)
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final HttpLink link = HttpLink(
    // mudar para o seu ip caso queira rodar localmente
    uri: 'http://192.168.100.64:4000/',
  );

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      cache: InMemoryCache(),
      link: link,
    ),
  );

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;

  const MyApp({Key key, this.client}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: CacheProvider(
          child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        initialRoute: '/',
        routes: {
          //'/': (context) => WelcomePage(),
          '/': (context) => HomePage(),
          '/home': (context) => HomePage(),
          '/signin': (context) => SignInPage(),
          '/projectform': (context) => ProjectFormPage(),
        },
      )),
    );
  }
}
