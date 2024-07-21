
import 'package:bloc/bloc.dart';
import 'package:expense_test_app/utils/resources/color_resources.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(_lightTheme);


  static final _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: StyleResources.primarycolor,
  );

 
  static final _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.red,
  );

 
  void toggleTheme() {
    emit(state.brightness == Brightness.dark ? _lightTheme : _darkTheme);
  }
}
