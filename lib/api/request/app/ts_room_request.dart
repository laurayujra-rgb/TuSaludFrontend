class TsRoomRequest {
  final String roomName;

  TsRoomRequest({
    required this.roomName,
  });
  Map<String, dynamic> toMap() {
    return {
      'roomName': roomName,
    };
  }

  debugPrint(){
    print('Room Name: $roomName');
  }
}