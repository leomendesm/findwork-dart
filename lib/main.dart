import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphqlex/pages/forms/historical.dart';
import 'package:graphqlex/pages/forms/project.dart';
import 'package:graphqlex/pages/home.dart';
import 'package:graphqlex/pages/signin/signin.dart';
import 'package:graphqlex/pages/signout/signout.dart';
import 'package:graphqlex/pages/signup/complete.dart';
import 'package:graphqlex/pages/signup/signup.dart';
import 'package:graphqlex/pages/welcome/welcome.dart';

// variável global para criar rota fora do contexto (onboarding)
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
final ip = 'http://192.168.100.64';
void main() {
  // setup do graphql
  WidgetsFlutterBinding.ensureInitialized();

  final HttpLink link = HttpLink(
    // mudar para o seu ip caso queira rodar localmente
    uri: ip + ':4000/',
  );

  //sistema de caching do graphql, mudar mais pra frente se possível para reduzir as queries
  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      cache: InMemoryCache(),
      link: link,
    ),
  );

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  //pega o cliente criado no setup e passa para o provider para poder fazer chamadas dentro dos componentes (insere direto no context)
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
            '/': (context) => WelcomePage(),
            '/home': (context) => HomePage(),
            '/signin': (context) => SignInPage(),
            '/signup': (context) => SignUpPage(),
            '/signout': (context) => SignOutPage(),
            '/projectform': (context) => ProjectFormPage(),
            '/historicalform': (context) => HistoricalFormPage(),
            '/completeprofile': (context) => UserCompletePage(),
          },
        ),
      ),
    );
  }
}
