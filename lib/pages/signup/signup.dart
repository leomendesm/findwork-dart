import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../mixins/validation_mixin.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignUpPageState();
  }
}

String userRegister = """
  mutation userRegister(\$email: String!, \$password: String!) {
    userRegister(
      input: {
        email: \$email,
        password: \$password
      }
    )
  }
""";

class SignUpPageState extends State<SignUpPage> with ValidationMixin {
  final formkey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  Widget build(context) {
    return Mutation(
      options: MutationOptions(
        documentNode: gql(userRegister),
        // or do something with the result.data on completion
        onCompleted: (dynamic resultData) async {
          if (resultData['userRegister'] != null) {
            print(resultData['userRegister']);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('jwt', resultData['userRegister']);
            Navigator.popAndPushNamed(context, '/completeprofile');
          }
        },
      ),
      builder: (
        RunMutation runMutation,
        QueryResult result,
      ) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Cadastre-se'),
            backgroundColor: Colors.cyan[600],
          ),
          body: Container(
            margin: EdgeInsets.all(20),
            child: Form(
              key: formkey,
              child: Column(
                children: <Widget>[
                  emailField(),
                  passwordField(),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                  ),
                  RaisedButton(
                    child: Text('Cadastrar'),
                    onPressed: () {
                      if (formkey.currentState.validate()) {
                        formkey.currentState.save();
                        runMutation({
                          'email': email,
                          'password': password,
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

  Widget emailField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'leo@test.com',
      ),
      keyboardType: TextInputType.emailAddress,
      validator: validateEmail,
      onSaved: (newValue) {
        this.setState(() {
          email = newValue;
        });
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Senha',
        hintText: '*******',
      ),
      obscureText: true,
      validator: validatePassword,
      onSaved: (newValue) {
        this.setState(() {
          password = newValue;
        });
      },
    );
  }
}
