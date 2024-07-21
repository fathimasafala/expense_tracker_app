
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/app_blocs.dart';
import '../widgets/bottom_button_widget.dart';
import '../widgets/snackbar.dart';
import '../widgets/textfiled_widget.dart';
import 'screens.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.read<LoginCubit>();

    return Scaffold(
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
            showSnackBar(context, 'Login successful! Welcome, ${state.user.name}');
            
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Login failed: ${state.error}'),
              ),
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Login To Expense Tracker',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                SizedBox(
                  height: 50,
                ),
                CustomTextFormFields(
                  title: 'Name',
                  controller: _nameController,
                ),
                CustomTextFormFields(
                  title: 'Phone Number',
                  keyboardType: TextInputType.number,
                  controller: _phoneNumberController,
                ),
                CustomTextFormFields(
                  title: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 240),
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    if (state is LoginLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return BottomCustomButton(
                      onTap: () {
                        final phoneNumber = _phoneNumberController.text;
                        final name = _nameController.text;
                        final email = _emailController.text;
                        context.read<LoginCubit>().login(phoneNumber, name, email);
                      },
                      text: 'Login',
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
