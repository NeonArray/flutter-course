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
		return TextField(
			keyboardType: TextInputType.emailAddress,
			decoration: InputDecoration(
				labelText: 'E-Mail',
				filled: true,
				fillColor: Colors.white,
			),
			onChanged: (String value) => setState(() => _emailValue = value),
		);
	}

	Widget _buildPasswordTextField () {
		return TextField(
			obscureText: true,
			decoration: InputDecoration(
				labelText: 'Password',
				filled: true,
				fillColor: Colors.white,
			),
			onChanged: (String value) => setState(() => _passwordValue = value),
		);
	}

	SwitchListTile _buildAcceptSwitchTile() {
		return SwitchListTile(
			value: _acceptTerms,
			onChanged: (bool value) {
				setState(() => _acceptTerms = value);
			},
			title: Text('Accept Terms'),
		);
	}

	Widget _buildLoginButton() {
		return RaisedButton(
			color: Theme.of(context).primaryColor,
			child: Text('LOGIN'),
			onPressed: () => Navigator.pushReplacementNamed(context, '/products'),
		);
	}

	@override
	Widget build(BuildContext context) {
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
		);
	}
}