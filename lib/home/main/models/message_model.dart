class MessageModel
{
  String? messageId;
  String? sender;
  String? text;
  bool? seen;
  DateTime? createdOn;
  int? index;
  MessageModel({this.messageId,this.sender,this.text,this.seen,this.createdOn,this.index });
  MessageModel.fromMap(Map<String,dynamic> map)
  {
    sender = map["sender"];
    text = map["text"];
    seen = map["seen"];
    createdOn = map["createdOn"];
    messageId = map["messageId"];
  }
  Map<String,dynamic> toMap ()
  {
    return {
      "sender" : sender,
      "text" : text,
      "seen" : seen,
      "createdOn" : createdOn,
      "messageId" : messageId,
      "index" : index
    };
  }
}