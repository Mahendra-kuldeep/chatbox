class ChatRoom{
  String? chatroomid;
  List<String>? participets;

  ChatRoom({this.chatroomid,this.participets});

  ChatRoom.fromMap(Map<String,dynamic>map){
    chatroomid = map["chatroomid"];
    participets = map["participets"];
  }

  Map<String,dynamic>toMap(){
    return{
      "chatroomid":chatroomid,
      "participets":participets,
    };
  }
}