import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
	@override
	_AuthPageState createState() => new _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
	String _emailValue;
	String _passwordValue;
	bool _acceptTerms = false;

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

	Widget _buildPasswordTextField () {
		return TextFormField(
			obscureText: true,
			decoration: InputDecoration(
				labelText: 'Password',
				filled: true,
				fillColor: Colors.white,
			),
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
		return RaisedButton(
			child: Text('LOGIN'),
			onPressed: () {
				if (!_formKey.currentState.validate() || !_formData['acceptTerms']) {
					return;
				}

				_formKey.currentState.save();
				Navigator.pushReplacementNamed(context, '/products');
			},
		);
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