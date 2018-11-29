import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_course/scoped_models/main.dart';


enum AuthMode {
	Signup,
	Login,
}


class AuthPage extends StatefulWidget {
	@override
	_AuthPageState createState() => new _AuthPageState();
}


class _AuthPageState extends State<AuthPage> {
	final Map<String, dynamic> _formData = {
		'email': null,
		'password': null,
		'acceptTerms': false,
	};
	final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
	final TextEditingController _passwordTextController = TextEditingController();
	AuthMode _authMode = AuthMode.Login;


	DecorationImage _buildBackgroundImage() {
		return DecorationImage(
			fit: BoxFit.cover,
			colorFilter: ColorFilter.mode(
				Colors.black.withOpacity(0.5),
				BlendMode.dstATop,
			),
			image: AssetImage('assets/background.jpg'),
		);
	}


	Widget _buildEmailTextField() {
		return TextFormField(
			keyboardType: TextInputType.emailAddress,
			decoration: InputDecoration(
				labelText: 'E-Mail',
				filled: true,
				fillColor: Colors.white,
			),
			validator: (String value) {
				if (value.isEmpty || !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?").hasMatch(value)) {
					return 'Invalid email address, please ente valid email';
				}
			},
			onSaved: (String value) {
				_formData['email'] = value;
			}
		);
	}


	Widget _buildPasswordConfirmTextField() {
		return TextFormField(
			obscureText: true,
			decoration: InputDecoration(
				labelText: 'Confirm Password',
				filled: true,
				fillColor: Colors.white,
			),
			validator: (String value) {
				if (_passwordTextController.text != value) {
					return 'Passwords must match';
				}
			},
		);
	}


	Widget _buildPasswordTextField() {
		return TextFormField(
			obscureText: true,
			decoration: InputDecoration(
				labelText: 'Password',
				filled: true,
				fillColor: Colors.white,
			),
			controller: _passwordTextController,
			validator: (String value) {
				if (value.isEmpty || value.length < 6) {
					return 'Password invalid';
				}
			},
			onSaved: (String value) {
				_formData['password'] = value;
			}
		);
	}


	SwitchListTile _buildAcceptSwitchTile() {
		return SwitchListTile(
			value: _formData['acceptTerms'],
			onChanged: (bool value) {
				setState(() => _formData['acceptTerms'] = value);
			},
			title: Text('Accept Terms'),
		);
	}


	Widget _buildLoginButton() {
		return ScopedModelDescendant<MainModel>(
			builder: (BuildContext context, Widget child, MainModel model) {
				return model.isLoading
					? CircularProgressIndicator()
					: RaisedButton(
						child: Text(_authMode == AuthMode.Login ? 'LOGIN' : 'Signup'),
						onPressed: () => _submitForm(model.login, model.signup),
					);
			}
		);
	}


	void _submitForm(Function login, Function signup) async {
		if (!_formKey.currentState.validate() || !_formData['acceptTerms']) {
			return;
		}

		_formKey.currentState.save();

		if (_authMode == AuthMode.Login) {
			login(_formData['email'], _formData['password']);
		} else {
			final Map<String, dynamic> successInformation = await signup(_formData['email'], _formData['password']);

			if (successInformation['success']) {
				Navigator.pushReplacementNamed(context, '/products');
			} else {
				showDialog(
					context: context,
					builder: (BuildContext context) {
						return AlertDialog(
							title: Text('An Error Occurred!'),
							content: Text(successInformation['message']),
							actions: <Widget>[
								FlatButton(
									child: Text('Okay'),
									onPressed: () {
										Navigator.of(context).pop();
									},
								)
							],
						);
					},
				);
			}
		}
	}


	@override
	Widget build(BuildContext context) {
		final double deviceWidth = MediaQuery.of(context).size.width;
		final double targetWidth = deviceWidth > 768.0 ? 500.0 : deviceWidth * 0.85;

		return Scaffold(
			appBar: AppBar(
				title: Text('Login'),
			),
			body: Container(
				decoration: BoxDecoration(
					image: _buildBackgroundImage(),
				),
				padding: EdgeInsets.all(10.0),
				child: Center(
					child: SingleChildScrollView(
						child: Container(
							width: targetWidth,
							child: Form(
								key: _formKey,
								child: Column(
									children: <Widget>[
										_buildEmailTextField(),
										SizedBox(
											height: 10.0,
										),
										_buildPasswordTextField(),
										_buildAcceptSwitchTile(),
										SizedBox(
											height: 30.0,
										),
										_buildLoginButton(),
									],
								),
							),
						),
					),
				),
			),
		);
	}
}