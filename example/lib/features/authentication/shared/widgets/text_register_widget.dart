import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';

import '../../../../router/app_router.dart';

class TextRegisterWidget extends StatelessWidget {
  const TextRegisterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kToolbarHeight / 3),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Bạn không có tài khoản?"),
              TextButton(
                onPressed: () => context.pushRoute(const RegisterRoute()),
                child: Text(
                  "Đăng ký ngay!",
                  style: TextStyle(color: context.theme.colorScheme.error),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () => context.pushRoute(const HomeRoute()),
            child: const Text(
              "Tôi muốn đặt vé không cần tạo tài khoản >>",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}

class TextLoginWidget extends StatelessWidget {
  const TextLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kToolbarHeight / 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Bạn đã có tài khoản?"),
          TextButton(
            onPressed: () => context.pushRoute(const LoginRoute()),
            child: Text(
              "Đăng nhập ngay!",
              style: TextStyle(color: context.theme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
