import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HistoricalFormPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HistoricalFormPageState();
  }
}

String query = """
  mutation addHistorical(
    \$jwt: String!,
    \$job: String!,
    \$company: String!,
    \$description: String!,
    \$start: String!,
    \$end: String!,
    ) {
    addHistorical(
      jwt: \$jwt,
      input: {
        job: \$job,
        company: \$company,
        description: \$description,
        start: \$start,
        end: \$end,
      }
    ) {
      name
    }
  }
""";

class HistoricalFormPageState extends State<HistoricalFormPage> {
  final formkey = GlobalKey<FormState>();
  var startController = new MaskedTextController(mask: '00/00/0000');
  var endController = new MaskedTextController(mask: '00/00/0000');
  String jwt = '';
  String job = '';
  String company = '';
  String description = '';
  String start = '';
  String end = '';
  bool checked = false;
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
        documentNode: gql(query),
        // or do something with the result.data on completion
        onCompleted: (dynamic resultData) async {
          if (resultData["addHistorical"]["name"] != null) {
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
            title: Text('Adicionar novo histórico'),
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
                    companyField(),
                    jobField(),
                    descriptionField(),
                    startField(),
                    endField(),
                    checkField(),
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
                            'job': job,
                            'company': company,
                            'start': start,
                            'end': end,
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

  Widget jobField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Nome do cargo',
        hintText: 'Desenvolvedor FrontEnd',
      ),
      keyboardType: TextInputType.text,
      onSaved: (newValue) {
        this.setState(() {
          job = newValue;
        });
      },
    );
  }

  Widget companyField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Nome do empresa',
        hintText: 'Centro Universitário Módulo',
      ),
      keyboardType: TextInputType.text,
      onSaved: (newValue) {
        this.setState(() {
          company = newValue;
        });
      },
    );
  }

  Widget descriptionField() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'Descrição da vaga',
        hintText:
            'Descreva quais foram as tecnologias utilizadas, suas responsabilidades, etc.',
      ),
      onSaved: (newValue) {
        this.setState(() {
          description = newValue;
        });
      },
    );
  }

  Widget startField() {
    return TextFormField(
      controller: startController,
      decoration: InputDecoration(
        labelText: 'Data de início',
      ),
      keyboardType: TextInputType.number,
      onSaved: (newValue) {
        this.setState(() {
          start = newValue;
        });
      },
    );
  }

  Widget endField() {
    if (checked) {
      return Container();
    }
    return TextFormField(
      controller: endController,
      decoration: InputDecoration(
        labelText: 'Data de fim',
      ),
      keyboardType: TextInputType.number,
      onSaved: (newValue) {
        this.setState(() {
          end = newValue;
        });
      },
    );
  }

  Widget checkField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: checked,
          onChanged: (check) {
            setState(() {
              checked = check;
              end = "Atual";
            });
          },
        ),
        Text('Emprego atual?'),
      ],
    );
  }
}
