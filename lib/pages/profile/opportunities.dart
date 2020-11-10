import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OpportunitiesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OpportunitiesPageState();
  }
}

class _OpportunitiesPageState extends State<OpportunitiesPage> {
//query do graphql
  final String _query = """
  query opportunities {
    opportunities {
      title
      experience
      contract
      createdAt
      remuneration {
        min
        max
      }
    }
  }
  """;

  String jwt = '';
  void autoLogIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String _jwt = prefs.getString("jwt");
    setState(() {
      jwt = _jwt;
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
      options: QueryOptions(documentNode: gql(_query)),
      builder: (
        QueryResult result, {
        VoidCallback refetch,
        FetchMore fetchMore,
      }) {
        if (result.loading) {
          return Container(
            child: Center(
              child: Text("Carregando"),
            ),
          );
        }

        if (result.hasException) {
          print(result.exception);

          return Text('Ocorreu um erro');
        }

        final List opportunities = result.data["opportunities"];

        if (opportunities == null || opportunities.isEmpty) {
          return Container(
            child: Center(
              child: Text(
                "Nenhuma vaga encontrada!",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        } else {
          return Column(
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                itemCount: opportunities.length,
                itemBuilder: (context, index) {
                  final user = opportunities[index];
                  final min =
                      (user['remuneration']['min'] / 1000).toStringAsFixed(0);
                  final max =
                      (user['remuneration']['max'] / 1000).toStringAsFixed(0);
                  return Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.all(8)),
                      Card(
                        elevation: 5,
                        color: Colors.cyan[600],
                        child: ListTile(
                          contentPadding: EdgeInsets.all(20),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "${user['title']}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Chip(
                                  shape: StadiumBorder(
                                    side: BorderSide(
                                      color: Colors.grey[900],
                                      width: 1.0,
                                    ),
                                  ),
                                  avatar: Icon(
                                    Icons.calendar_today,
                                    color: Colors.grey[850],
                                  ),
                                  backgroundColor: Colors.grey[50],
                                  label: Text(
                                    "${user['createdAt']}",
                                    style: TextStyle(color: Colors.grey[850]),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Chip(
                                  shape: StadiumBorder(
                                    side: BorderSide(
                                      color: Colors.green[900],
                                      width: 1.0,
                                    ),
                                  ),
                                  avatar: Icon(
                                    Icons.attach_money,
                                    color: Colors.green[900],
                                  ),
                                  backgroundColor: Colors.green[100],
                                  labelPadding:
                                      EdgeInsets.only(left: -2.0, right: 5),
                                  label: Text(
                                    "$min\-$max\k",
                                    style: TextStyle(
                                      color: Colors.green[900],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 20, top: 10),
                                child: Text(
                                  "${user['experience']} - ${user['contract']}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        }
      },
    );
  }
}
