import 'package:flutter/material.dart';
import 'package:sign_app/controllers/login_controller.dart';
import 'package:sign_app/token_helper.dart';
import 'package:sign_app/views/register.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final LoginController _controller = LoginController();
  String _username = "", _password = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            color: Colors.grey,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: _form(),
          ),
        ),
      ),
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.login,
            style: const TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32.0),
          _formField(
              labelText: AppLocalizations.of(context)!.username,
              validator: _validateUsername,
              save: (value) {
                _username = value;
              }),
          _formField(
              labelText: AppLocalizations.of(context)!.password,
              validator: _validatePassword,
              save: (value) {
                _password = value;
              },
              obscureText: true),
          const SizedBox(height: 32.0),
          ElevatedButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              _formKey.currentState!.save();

              _controller.login(_username, _password).then((tokenData) {
                if (tokenData != null) {
                  TokenHelper().saveToken(tokenData);
                  Navigator.pop(context);
                }
              });
            },
            child: Text(AppLocalizations.of(context)!.login),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const RegisterPage()));
            },
            child: Text(AppLocalizations.of(context)!.createAnAccount),
          ),
        ],
      ),
    );
  }

  Widget _formField(
      {obscureText = false,
      inputType = TextInputType.text,
      required String labelText,
      required validator,
      save}) {
    return Column(children: [
      TextFormField(
        obscureText: obscureText,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: labelText,
        ),
        validator: validator,
        onSaved: save,
        textInputAction: TextInputAction.next,
      ),
      const SizedBox(
        height: 16,
      ),
    ]);
  }

  String? _validateUsername(String? value) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.emptyUsername;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.emptyPassword;
    }
    if (value.length < 6) {
      return AppLocalizations.of(context)!.invalidPassword;
    }
    return null;
  }
}
