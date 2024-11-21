
import 'package:expense_test_app/bloc/login_cubit/login_cubit.dart';
import 'package:expense_test_app/widgets/bottom_button_widget.dart';
import 'package:expense_test_app/widgets/snackbar.dart';
import 'package:expense_test_app/widgets/textfiled_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  LoginScreen({super.key});

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
                builder: (context) => const HomeScreen(),
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
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  'Login To Expense Tracker',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                const SizedBox(
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
                const SizedBox(height: 240),
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    if (state is LoginLoading) {
                      return const Center(child: CircularProgressIndicator());
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
