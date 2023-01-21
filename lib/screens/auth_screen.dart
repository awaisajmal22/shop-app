import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/httpException.dart';

import '../provider/auth.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
     var colorizeColors = [
  Colors.black,
  Colors.red,
  Colors.blue,
  Colors.yellow,
  Colors.black12
];
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child:  AnimatedTextKit(
  animatedTexts: [
    ColorizeAnimatedText(
      'Shop App',
      colors: colorizeColors,
      textStyle: const TextStyle(
        fontSize: 32.0,
        fontFamily: 'Monoton',
        letterSpacing: 2,
        wordSpacing: 6,
        fontWeight: FontWeight.w100
      ),
    ),
  ],
  
  displayFullTextOnTap: true,
  stopPauseOnTap: true,
  isRepeatingAnimation: true,
  repeatForever: true,
)
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with SingleTickerProviderStateMixin{
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  late AnimationController _controller;
  // late Animation<Size> heightAnimation;
  late Animation<double> opacityAnimation;
  late Animation<Offset> sliderAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
    vsync: this, 
    duration: Duration(milliseconds: 300)
    );
    sliderAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
      parent: _controller, 
      curve: Curves.fastOutSlowIn
      )
    );
    opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    // // heightAnimation.addListener(()=> setState(() {
      
    // // })
    // );
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _showErrorDailog(String message){
    showDialog(context: (context), builder: ((context) => AlertDialog(
      title: Text('An Error Occoured !'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: (){
          Navigator.of(context).pop();
        }, child: Text('Ok')
        )
      ],
    ))
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try
    {
      if (_authMode == AuthMode.Login) {
      // Log user in
      await Provider.of<Auth>(context, listen: false).login(_authData['email']!, _authData['password']!);
    } else {
      // Sign user up
      await Provider.of<Auth>(context, listen: false).signup(_authData['email']!, _authData['password']!);
    } 
    } on HttpException catch(error){
      var message = 'Authentication Failed';
      if(error.toString().contains('EMAIL_EXISTS')){
        message = 'This Email Adress is Already Exist';
      }
      else if(error.toString().contains('INVALID_EMAIL')){
        message = 'Please Enter a Valid Email';
      }
      else if(error.toString().contains('WEAK_PASSWORD')){
        message = 'Your Password is too Weak';
      }
      else if(error.toString().contains('EMAIL_NOT_FOUND')){
        message = 'Could Not Find the User with that Email';
      }
      else if(error.toString().contains('INVALID_PASSWORD')){
        message = 'Invalid Password';
      }
      _showErrorDailog(message);
    } catch(error){
      var message = 'Could not Authenticate Please Try Later.';
      _showErrorDailog(message);
    }

    setState(() {
      _isLoading = false;
    });
    } 
  

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
          height: _authMode == AuthMode.Signup ? 320 : 260,
          constraints:
              BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
          width: deviceSize.width * 0.75,
          padding: EdgeInsets.all(16.0),
          child:  Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'E-Mail'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                      return null;
                      
                    },
                    onSaved: (value) {
                      _authData['email'] = value!;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 5) {
                        return 'Password is too short!';
                      }
                    },
                    onSaved: (value) {
                      _authData['password'] = value!;
                    },
                  ),
                  if (_authMode == AuthMode.Signup)
                    AnimatedContainer(
                      constraints: BoxConstraints(
                        minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                        maxHeight: _authMode == AuthMode.Signup ? 120 : 0
                      ),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                      child: FadeTransition(
                        opacity: opacityAnimation,
                        child: SlideTransition(
                          position: sliderAnimation,
                          child: TextFormField(
                            enabled: _authMode == AuthMode.Signup,
                            decoration: InputDecoration(labelText: 'Confirm Password'),
                            obscureText: true,
                            validator: _authMode == AuthMode.Signup
                                ? (value) {
                                    if (value != _passwordController.text) {
                                      return 'Passwords do not match!';
                                    }
                                  }
                                : null,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  if (_isLoading)
                    CircularProgressIndicator()
                  else
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        )
                      ),
                      child:
                          Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                      onPressed: _submit,
                      
                    ),
                  TextButton(
                    child: Text(
                        '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                    onPressed: _switchAuthMode,
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}