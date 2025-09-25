class TsRoomRequest {
  final String roomName;

  TsRoomRequest({
    required this.roomName,
  });
  Map<String, dynamic> toJson() {
    return {
      'roomName': roomName,
    };
  }

  debugPrint(){
    print('Room Name: $roomName');
  }
}