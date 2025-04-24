import 'dart:convert';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../datasource/network/dio_network_service.dart';


class OdooWebSocketService {
  late WebSocketChannel channel;

  OdooWebSocketService() {
    // Kết nối WebSocket với Odoo

    final baseUrl = GetIt.instance<DioNetworkService>().baseUrl;
    final url = "$baseUrl/websocket";
    final uri = Uri.parse(url).replace(scheme: url.contains("https") ? "wss" : "ws");
    channel = IOWebSocketChannel(WebSocket.connect(uri.toString(), headers: {"Origin": baseUrl}));
    channel.sink.add(jsonEncode({"Origin": GetIt.instance<DioNetworkService>().baseUrl}));
  }

  void subscribeToChannel(String channelName) {
    final request = jsonEncode({
      "event_name": "subscribe",
      "data": {
        "channels": [channelName],
        "last": 0,
      },
    });

    channel.sink.add(request);
  }

  void close() {
    channel.sink.close(status.normalClosure);
  }
}
