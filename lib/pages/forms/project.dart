import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ProjectFormPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProjectFormPageState();
  }
}

String userLogin = """
  mutation addProject(\$jwt: String!, \$name: String!, \$description: String!) {
    addProject(
      jwt: \$jwt,
      name: \$name,
      description: \$description
    ) {
      name
    }
  }
""";

class ProjectFormPageState extends State<ProjectFormPage> {
  final formkey = GlobalKey<FormState>();

  String name = '';
  String description = '';

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

  Widget build(context) {
    return Mutation(
      options: MutationOptions(
        documentNode: gql(userLogin),
        // or do something with the result.data on completion
        onCompleted: (dynamic resultData) async {
          if (resultData["addProject"]["name"] != null) {
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
            title: Text('Criar novo projeto'),
            backgroundColor: Colors.cyan[600],
          ),
          body: Container(
            margin: EdgeInsets.all(20),
            child: Form(
              key: formkey,
              child: Column(
                children: <Widget>[
                  nameField(),
                  descriptionField(),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                  ),
                  RaisedButton(
                    child: Text('Salvar'),
                    onPressed: () {
                      if (formkey.currentState.validate()) {
                        formkey.currentState.save();
                        print(
                            'jwt: $jwt name: $name description: $description');
                        runMutation({
                          'jwt': jwt,
                          'name': name,
                          'description': description,
                        });
                      }
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

  Widget nameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Nome do projeto',
        hintText: 'Projeto integrado',
      ),
      keyboardType: TextInputType.text,
      onSaved: (newValue) {
        this.setState(() {
          name = newValue;
        });
      },
    );
  }

  Widget descriptionField() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: 5,
      decoration: InputDecoration(
        labelText: 'Descrição do projeto',
      ),
      onSaved: (newValue) {
        this.setState(() {
          description = newValue;
        });
      },
    );
  }
}
