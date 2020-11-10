import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UserCompletePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserCompletePageState();
  }
}

String query = """
  mutation userUpdate(
    \$jwt: String!,
    \$name: String!,
    \$city: String!,
    \$description: String!,
    \$cellphone: String!,
    \$englishLevel: String!,
    ) {
    userUpdate(
      jwt: \$jwt,
      input: {
        name: \$name,
        city: \$city,
        description: \$description,
        cellphone: \$cellphone,
        englishLevel: \$englishLevel,
      }
    )
  }
""";

class UserCompletePageState extends State<UserCompletePage> {
  final formkey = GlobalKey<FormState>();

  String name = "";
  String city = "";
  String description = "";
  String cellphone = "";
  String englishLevel = "";

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
    cellphoneController = MaskedTextController(mask: '(00)00000-0000');
  }

  Widget build(context) {
    return Mutation(
      options: MutationOptions(
        documentNode: gql(query),
        // or do something with the result.data on completion
        onCompleted: (dynamic resultData) async {
          if (resultData["userUpdate"]) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
      ),
      builder: (
        RunMutation runMutation,
        QueryResult result,
      ) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Complete seu perfil'),
            backgroundColor: Colors.cyan[600],
          ),
          body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Container(
              margin: EdgeInsets.all(20),
              child: Form(
                key: formkey,
                child: Column(
                  children: <Widget>[
                    nameField(),
                    cityField(),
                    descriptionField(),
                    cellphoneField(),
                    englishLevelField(),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                    ),
                    RaisedButton(
                      child: Text('Salvar'),
                      onPressed: () {
                        if (formkey.currentState.validate()) {
                          formkey.currentState.save();
                          runMutation({
                            'jwt': jwt,
                            'description': description,
                            'city': city,
                            'name': name,
                            'cellphone': cellphone,
                            'englishLevel': englishLevel,
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
          ),
        );
      },
    );
  }

  Widget nameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Nome completo',
        hintText: 'João da silva',
      ),
      keyboardType: TextInputType.text,
      onSaved: (newValue) {
        this.setState(() {
          name = newValue;
        });
      },
    );
  }

  Widget cityField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Cidade - Estado(sigla)',
        hintText: 'Caraguatatuba - SP',
      ),
      keyboardType: TextInputType.text,
      onSaved: (newValue) {
        this.setState(() {
          city = newValue;
        });
      },
    );
  }

  Widget descriptionField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Qual seu papel em sua empresa atual?',
        hintText: 'Desenvolvedor, Gerente, Auxiliar.',
      ),
      onSaved: (newValue) {
        this.setState(() {
          description = newValue;
        });
      },
    );
  }

  Widget cellphoneField() {
    return TextFormField(
      controller: cellphoneController,
      decoration: InputDecoration(
        labelText: 'Celular para contato',
      ),
      keyboardType: TextInputType.number,
      onSaved: (newValue) {
        this.setState(() {
          cellphone = newValue;
        });
      },
    );
  }

  final List<Map<String, dynamic>> _items = [
    {
      'value': 'nenhum',
      'label': 'Nenhum',
    },
    {
      'value': 'básico',
      'label': 'Básico',
    },
    {
      'value': 'intermediário',
      'label': 'Intermediário',
    },
    {
      'value': 'avançado',
      'label': 'Avançado',
    },
    {
      'value': 'fluente',
      'label': 'Fluente',
    }
  ];
  Widget englishLevelField() {
    return SelectFormField(
      labelText: 'Nível de inglês',
      initialValue: 'nenhum',
      items: _items,
      onChanged: (val) => setState(() => englishLevel = val),
    );
  }
}
