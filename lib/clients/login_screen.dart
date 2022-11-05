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

  late TextEditingController emailController;
  late TextEditingController passwordController;

  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  bool inValidAccount = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: const Text('Lịch công tác'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
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
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng điền email';
                    }
                    bool isValidate = RegExp(
                            r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                        .hasMatch(value);
                    if (!isValidate) {
                      return 'Email chưa hợp lệ';
                    }
                    return null;
                  },
                  controller: emailController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng điền mật khẩu';
                    }
                    return null;
                  },
                  controller: passwordController,
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Mật khẩu',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
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
                const SizedBox(height: 16.0),
                Visibility(
                  visible: inValidAccount,
                  child: Text(
                    'Sai thông tin đăng nhập',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.red),
                  ),
                ),
                const SizedBox(height: 16.0),
                BlocListener<SignCubit, SignState>(
                  listener: (context, state) {
                    if (state is SignIned) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                      // context.read<HomeCubit>().getAllTasks();
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
                      onTap: () async {
                        bool isValidate =
                            _formKey.currentState?.validate() ?? false;
                        if (!isValidate) {
                          return;
                        }
                        bool result = await context.read<SignCubit>().signIn(
                              emailController.text,
                              passwordController.text,
                            );
                        if (!result) {
                          setState(() {
                            inValidAccount = true;
                          });
                        }
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
        ),
      ),
    );
  }
}
