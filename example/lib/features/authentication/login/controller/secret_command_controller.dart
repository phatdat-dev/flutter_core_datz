import 'package:get_it/get_it.dart';

import '../../../../core/controller/base_controller.dart';
import '../../../../shared/datasource/network/dio_network_service.dart';

class SecretCommandController extends BaseController {
  final String inputField;
  SecretCommandController(this.inputField);

  final String secretCommand = "/";

  @override
  Future<void> onInitData() async {}

  /// get command and return the input field without the command
  Future<String> onLoginPasswordCommand() async {
    inputField.trim();

    final command = inputField.split(secretCommand).lastOrNull;
    if (command != null) {
      final commandList = command.split(":");
      if (commandList.length >= 2) {
        final key = commandList[0].toLowerCase();
        // value after the key
        final value = command.substring(key.length + 1);
        switch (key) {
          //? ex: /host: 192.168.1.1
          case "host":
            onHostCommand(value);
            break;
          //? ex: /admin
          case "admin":
            onAdminCommand();
            break;
          default:
            return inputField;
        }
        return inputField.replaceFirst("$secretCommand$command", "");
      }
    }
    return inputField;
  }

  void onHostCommand(String ip) async {
    if (ip.isEmpty) return;
    GetIt.instance<DioNetworkService>().dio.options.baseUrl = 'http://$ip';
  }

  void onAdminCommand() {}
}
