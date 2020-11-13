import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class DeleteProjectPage extends StatefulWidget {
  final projectId;

  const DeleteProjectPage({
    Key key,
    @required this.projectId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DeleteProjectPageState();
  }
}

String query = """
  mutation removeProject(\$jwt: String!, \$projectId: String!) {
    removeProject(
      jwt: \$jwt,
      projectId: \$projectId
    ) {
      name
    }
  }
""";

class DeleteProjectPageState extends State<DeleteProjectPage> {
  final formkey = GlobalKey<FormState>();

  String projectId = "";

  String jwt = "";
  var cellphoneController;
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
    projectId = widget.projectId;
  }

  Widget build(context) {
    return Mutation(
      options: MutationOptions(
        documentNode: gql(query),
        onCompleted: (dynamic resultData) async {
          if (resultData["removeProject"]["name"] != null) {
            Navigator.pop(context);
          }
        },
      ),
      builder: (
        RunMutation runMutation,
        QueryResult result,
      ) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Excluir projecto'),
            backgroundColor: Colors.cyan[600],
          ),
          body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 250),
                  ),
                  Text('Deseja excluir este projeto?'),
                  RaisedButton(
                    child: Text('Confirmar'),
                    onPressed: () {
                      runMutation({
                        'jwt': jwt,
                        'projectId': projectId,
                      });
                    },
                    color: Colors.cyan[600],
                    textColor: Colors.white,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
