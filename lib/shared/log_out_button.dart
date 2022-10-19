import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_assignment/clients/sign_cubit.dart';

class LogOutButton extends StatefulWidget {
  const LogOutButton({super.key});

  @override
  State<LogOutButton> createState() => _LogOutButtonState();
}

class _LogOutButtonState extends State<LogOutButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async => await BlocProvider.of<SignCubit>(context).logOut(),
      child: const Tooltip(
        message: 'Đăng xuất',
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Icon(
            Icons.logout_rounded,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
