import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphqlex/components/user_info.dart';
import 'package:graphqlex/components/user_label.dart';
import 'package:shared_preferences/shared_preferences.dart';

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

//classe state da página User
class UserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserPageState();
  }
}

//query do graphql
class _UserPageState extends State<UserPage> {
  final String _query = """
  query projects(\$jwt: String!) {
    userMe(jwt: \$jwt) {
      email
      name
      englishLevel
      city
      cellphone
      description
    }
  }
  """;

  String jwt = '';
  bool logged = false;
  void autoLogIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String _jwt = prefs.getString("jwt");
    setState(() {
      jwt = _jwt;
      logged = true;
    });
    return;
  }

  @override
  void initState() {
    super.initState();
    autoLogIn();
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        documentNode: gql(_query),
        variables: {'jwt': jwt != null ? jwt : "asd"},
      ),
      builder: (
        QueryResult result, {
        VoidCallback refetch,
        FetchMore fetchMore,
      }) {
        if (result.loading || logged == false) {
          return Container(
            child: Center(
              child: Text("Loading"),
            ),
          );
        }

        if (result.hasException) {
          print(result.exception);
          return Text('Ocorreu um erro');
        }

        final user = result.data["userMe"];

        return Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 24),
              ),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60.0),
                    child: Image.network(
                      "https://avatars2.githubusercontent.com/u/11414392?s=460&u=b1ddfd90d908c267ec662c2a372f06cd3aff4d36&v=4",
                      height: 60,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Column(
                    children: [
                      Text(
                        user["name"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        //alinha o texto junto a linha de cima, motivos desconhecidos por estar desalinhado
                        transform: Matrix4.translationValues(-8.0, 0.0, 0.0),
                        child: Text(
                          user["description"],
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              UserLabel(label: "EMAIL"),
              UserInfo(data: user["email"], icon: Icons.email),
              UserLabel(label: "lOCALIZAÇÃO"),
              UserInfo(data: capitalize(user["city"]), icon: Icons.map),
              UserLabel(label: "CELULAR"),
              UserInfo(data: user["cellphone"], icon: Icons.phone),
              UserLabel(label: "NIVEL DE INGLÊS"),
              UserInfo(
                  data: capitalize(user["englishLevel"]),
                  icon: Icons.translate),
            ],
          ),
        );
      },
    );
  }
}
