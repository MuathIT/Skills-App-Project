


import 'package:flutter/material.dart';

// hold the controllers in a separate file instead of double define them.
class TextFieldControllers {
  // email controller
  static final _emailController = TextEditingController();
  // password controller
  static final _passwordController = TextEditingController();

  // getters functions for the controllers.
  static TextEditingController getEmail(){return _emailController;}
  static TextEditingController getPassword(){return _passwordController;}



}