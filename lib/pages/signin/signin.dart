import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../mixins/validation_mixin.dart';

class SignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignInPageState();
  }
}

String userLogin = """
  mutation userLogin(\$email: String!, \$password: String!) {
    userLogin(
      input: {
        email: \$email,
        password: \$password
      }
    )
  }
""";

class SignInPageState extends State<SignInPage> with ValidationMixin {
  final formkey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  Widget build(context) {
    return Mutation(
      options: MutationOptions(
        documentNode: gql(userLogin),
        // or do something with the result.data on completion
        onCompleted: (dynamic resultData) async {
          if (resultData['userLogin'] != null) {
            print(resultData['userLogin']);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('jwt', resultData['userLogin']);
          }
        },
      ),
      builder: (
        RunMutation runMutation,
        QueryResult result,
      ) {
        return Scaffold(
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
                    child: Text('Submit'),
                    onPressed: () {
                      if (formkey.currentState.validate()) {
                        formkey.currentState.save();
                        print('email: $email password: $password');
                        runMutation({
                          'email': email,
                          'password': password,
                        });
                      }
                    },
                    color: Colors.blue,
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
        labelText: 'Password',
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
