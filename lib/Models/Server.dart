class ServerModel {
  final String country;
  final String flagEmoji;
  final int locationCount;
  final int basePing;
  bool isConnected;

  ServerModel({
    required this.country,
    required this.flagEmoji,
    required this.locationCount,
    required this.basePing,
    this.isConnected = false,
  });
}