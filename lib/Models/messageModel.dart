class MessageModel{
  String? sender; //message sender
  String? text; // message in text format
  String? seen; // userresponse
  String? createdon;


  MessageModel({this.sender,this.text,this.seen,this.createdon});

  //fromMap()
  MessageModel.fromMap(Map<String,dynamic>map){
    sender = map["sender"];
    text = map["text"];
    seen = map["seen"];
    createdon = map["createdon"];
  }


  //tomap()
  Map<String,dynamic>toMap(){
   return{
     "sender":sender,
     "text":text,
     "seen":seen,
     "createdon":createdon
   };
  }
}