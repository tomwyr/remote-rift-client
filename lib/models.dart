import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

sealed class RemoteRiftState {
  RemoteRiftState();

  factory RemoteRiftState.fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    return switch (type) {
      'preGame' => PreGame(),
      'lobby' => Lobby.fromJson(json),
      'found' => Found.fromJson(json),
      'inGame' => InGame(),
      'unknown' => Unknown(),
      _ => throw ArgumentError('Unexpected RemoteRiftState type $type'),
    };
  }

  String get displayName => switch (this) {
    PreGame() => 'Pre game',
    Lobby(:var state) => switch (state) {
      GameLobbyState.idle => 'Lobby',
      GameLobbyState.searching => 'Searching game',
    },
    Found(:var state) => switch (state) {
      GameFoundState.pending => 'Game found',
      GameFoundState.accepted => 'Game accepted',
      GameFoundState.declined => 'Game rejected',
    },
    InGame() => 'In game',
    Unknown() => 'Unknown',
  };
}

class PreGame extends RemoteRiftState {}

@JsonSerializable()
class Lobby extends RemoteRiftState {
  Lobby({required this.state});

  final GameLobbyState state;

  factory Lobby.fromJson(Map<String, dynamic> json) => _$LobbyFromJson(json);
}

@JsonSerializable()
class Found extends RemoteRiftState {
  Found({required this.state});

  final GameFoundState state;

  factory Found.fromJson(Map<String, dynamic> json) => _$FoundFromJson(json);
}

class InGame extends RemoteRiftState {}

class Unknown extends RemoteRiftState {}

enum GameLobbyState { idle, searching }

enum GameFoundState { pending, accepted, declined }
