import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphqlex/main.dart';
import 'package:graphqlex/pages/forms/delete_project.dart';
import 'package:shared_preferences/shared_preferences.dart';

//classe state da página User
class ProjectsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProjectsPageState();
  }
}

//query do graphql
class _ProjectsPageState extends State<ProjectsPage> {
  final String _query = """
  query projects(\$jwt: String!) {
    userMe(jwt: \$jwt) {
      projects {
        id
        name
        description
        photo
      }
    }
  }
  """;

  String jwt = '';
  bool logged = false;
  bool reload = false;
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

        final List projects = result.data["userMe"]["projects"];

        if (projects == null || projects.isEmpty) {
          return Container(
            child: Center(
              child: Text(
                "Nenhum projeto encontrado!",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        } else {
          return RefreshIndicator(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10, bottom: 40),
              shrinkWrap: true,
              itemCount: projects.length,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final project = projects[projects.length - index - 1];
                Widget leading =
                    project['photo'] != null && project['photo'] != ''
                        ? Image.network(ip + ":3000/" + project['photo'])
                        : FlutterLogo(
                            size: 50,
                          );
                return Column(
                  children: <Widget>[
                    Card(
                      elevation: 2,
                      color: Colors.cyan[600],
                      child: ListTile(
                        contentPadding: EdgeInsets.all(20),
                        leading: leading,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "${project['name']}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          "${project['description']}",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DeleteProjectPage(
                                  projectId: project['id'],
                                ),
                              ),
                            );
                          },
                          child: Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                      bottom: 8,
                      left: 8,
                      right: 8,
                    )),
                  ],
                );
              },
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
