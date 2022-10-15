import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_assignment/admin/admin_screen.dart';
import 'package:work_assignment/clients/home_screen.dart';
import 'package:work_assignment/clients/sign_cubit.dart';
import 'package:work_assignment/clients/sign_state.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool showPassword = false;

  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: const Text('Lịch công tác'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 160),
            const Text(
              'Đăng nhập',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 30.0),
            Container(
              padding: const EdgeInsets.only(left: 24),
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2,
                    offset: Offset(4, 4),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
              child: TextField(
                onChanged: (text) {
                  email = text;
                },
                decoration: const InputDecoration(
                  hintText: 'Email',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.only(left: 24),
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2,
                    offset: Offset(4, 4),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
              child: TextField(
                onChanged: (text) {
                  password = text;
                },
                obscureText: !showPassword,
                decoration: InputDecoration(
                  hintText: 'Mật khẩu',
                  border: InputBorder.none,
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    child: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            BlocListener<SignCubit, SignState>(
              listener: (context, state) {
                if (state is SignIned) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                }
                if (state is AdminSignIned) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) =>
                          const AdminPage(title: 'Quản trị lịch công tác'),
                    ),
                  );
                }
              },
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(32.0),
                color: Colors.blue,
                child: InkWell(
                  onTap: () {
                    context.read<SignCubit>().signIn(email, password);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    width: double.infinity,
                    child: const Text(
                      'Đăng nhập',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
