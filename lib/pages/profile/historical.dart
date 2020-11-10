import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline/model/timeline_model.dart';
import 'package:timeline/timeline.dart';

//classe state da página User
class HistoricalPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HistoricalPageState();
  }
}

//query do graphql
class _HistoricalPageState extends State<HistoricalPage> {
  final String _query = """
  query historical(\$jwt: String!) {
    userMe(jwt: \$jwt) {
      historical {
        company
        job
        time {
          start
          end
        }
      }
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

        final List historical = result.data["userMe"]["historical"];

        if (historical == null || historical.isEmpty) {
          return Container(
            child: Center(
              child: Text(
                "Nenhum histórico encontrado!",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        } else {
          List<TimelineModel> list = [];
          historical.forEach((element) {
            list.add(
              TimelineModel(
                id: "1",
                title: "${element['company']} - ${element['job']}",
                description:
                    "${element['time']['start']} - ${element['time']['end']}",
              ),
            );
          });
          return RefreshIndicator(
            child: TimelineComponent(
              timelineList: list,
              lineColor: Colors.white,
              backgroundColor: Colors.cyan[800],
              headingColor: Colors.white,
              descriptionColor: Colors.grey[50],
            ),
            onRefresh: () async {
              refetch();
            },
          );
        }
      },
    );
  }
}
