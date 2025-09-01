import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:remote_rift_client/models.dart';
import 'package:web_socket_channel/io.dart';

class RemoteRiftApi {
  RemoteRiftApi({
    required this.httpClient,
    required this.httpBaseUrl,
    required this.webSocketClient,
    required this.webSocketBaseUrl,
  });

  factory RemoteRiftApi.create({required String noSchemeBaseUrl, String? proxy}) {
    final client = HttpClient();
    if (proxy != null) {
      client.findProxy = (url) => 'PROXY 192.168.50.252:9090';
    }

    return RemoteRiftApi(
      httpClient: IOClient(client),
      httpBaseUrl: 'http://$noSchemeBaseUrl',
      webSocketClient: client,
      webSocketBaseUrl: 'ws://$noSchemeBaseUrl',
    );
  }

  final Client httpClient;
  final String httpBaseUrl;
  final HttpClient webSocketClient;
  final String webSocketBaseUrl;

  Future<RemoteRiftState> getCurrentState() async {
    final url = '$httpBaseUrl/state/current';
    final response = await httpClient.get(Uri.parse(url));
    return RemoteRiftState.fromJson(jsonDecode(response.body));
  }

  Stream<RemoteRiftState> getCurrentStateStream() async* {
    final url = '$webSocketBaseUrl/state/watch';
    final ws = IOWebSocketChannel.connect(Uri.parse(url), customClient: webSocketClient);
    await for (var message in ws.stream) {
      yield RemoteRiftState.fromJson(jsonDecode(message));
    }
  }
}
