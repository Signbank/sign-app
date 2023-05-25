import 'package:flutter/material.dart';
import 'package:sign_app/controllers/login_controller.dart';
import 'package:sign_app/token_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final LoginController _controller = LoginController();
  String _username = '';
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          icon: const Icon(
            Icons.close,
            color: Colors.grey,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
            AppLocalizations.of(context)!.createAnAccount,
            style: const TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32.0),
          _formField(
              labelText: AppLocalizations.of(context)!.email,
              validator: _validateEmail,
              save: _saveEmail,
              inputType: TextInputType.emailAddress),
          _formField(
              labelText: AppLocalizations.of(context)!.username,
              validator: _validateUsername,
              save: _saveUsername),
          _formField(
              labelText: AppLocalizations.of(context)!.password,
              validator: _validatePassword,
              save: _savePassword,
              obscureText: true),
          _formField(
              labelText: AppLocalizations.of(context)!.repeatPassword,
              validator: _validateRepeatPassword,
              save: (value) {},
              obscureText: true),
          ElevatedButton(
            child: Text(AppLocalizations.of(context)!.register),
            onPressed: () async {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              _formKey.currentState!.save();

              _controller
                  .register(_username, _password, _email)
                  .then((tokenData) {
                if (tokenData != null) {
                  TokenHelper().saveToken(tokenData);
                  Navigator.pop(context);
                }
              });
            },
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
      required save}) {
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
        height: 12,
      ),
    ]);
  }

  String? _validateEmail(String? value) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.emptyEmail;
    }
    if (!value.contains('@')) {
      return AppLocalizations.of(context)!.invalidEmail;
    }
    return null;
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

    _password = value;
    return null;
  }

  String? _validateRepeatPassword(String? value) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.emptyRepeatPassword;
    }
    if (_password != value) {
      return AppLocalizations.of(context)!.passwordDoNotMatch;
    }
    return null;
  }

  void _saveEmail(String? value) {
    _email = value!;
  }

  void _saveUsername(String? value) {
    _username = value!;
  }

  void _savePassword(String? value) {
    _password = value!;
  }
}
