class TsBedsRequest {
  final String bedName;
  final int roomId;

  TsBedsRequest({
    required this.bedName,
    required this.roomId,
  });

  Map<String, dynamic> toJson() {
    return {
      'bedName': bedName,
      'roomId': roomId,
    };
  }
  debugPrint() {
    print('Bed Name: $bedName, Room ID: $roomId');
  }
}