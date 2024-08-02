// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ffi';

class ChatRoomModel {
  int? count;
  String? next;
  String? previous;
  List<ChatRoomResultsModel>? results;

  ChatRoomModel({this.count, this.next, this.previous, this.results});

  ChatRoomModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <ChatRoomResultsModel>[];
      json['results'].forEach((v) {
        results!.add(ChatRoomResultsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChatRoomResultsModel {
  String? uuid;
  List<ChatRoomUsersModel>? users;
  int? unreadMessages;
  String? createdAt;
  String? updatedAt;
  String? name;
  ProductInRoomModel? productId;

  ChatRoomResultsModel(
      {this.uuid,
      this.users,
      this.unreadMessages,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.productId});

  ChatRoomResultsModel.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    if (json['users'] != null) {
      users = <ChatRoomUsersModel>[];
      json['users'].forEach((v) {
        users!.add(ChatRoomUsersModel.fromJson(v));
      });
    }
    unreadMessages = json['unread_messages'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    productId = json['product_id'] is Map<String, dynamic> ? ProductInRoomModel.fromJson(json['product_id']):null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['uuid'] = this.uuid;
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    data['unread_messages'] = this.unreadMessages;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.name;
    data['product_id'] = this.productId;
    return data;
  }

  @override
  String toString() {
    return 'ChatRoomResultsModel(uuid: $uuid, users: $users, unreadMessages: $unreadMessages, createdAt: $createdAt, updatedAt: $updatedAt, name: $name, productId: $productId)';
  }
}

class ChatRoomUsersModel {
  int? id;
  ChatRoomUserModel? user;
  String? createdAt;
  String? updatedAt;
  bool? isOnline;
  String? name;
  String? avatar;

  ChatRoomUsersModel(
      {this.id,
      this.user,
      this.createdAt,
      this.updatedAt,
      this.isOnline,
      this.name,
      this.avatar});

  ChatRoomUsersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user =
        json['user'] != null ? ChatRoomUserModel.fromJson(json['user']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isOnline = json['is_online'];
    name = json['name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_online'] = this.isOnline;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    return data;
  }
}

class ChatRoomUserModel {
  int? id;
  String? lastLogin;
  String? firstName;
  String? lastName;
  bool? isActive;
  String? dateJoined;
  String? createdAt;
  String? updatedAt;
  String? phone;
  String? image;
  String? middleName;
  String? email;

  ChatRoomUserModel(
      {this.id,
      this.lastLogin,
      this.firstName,
      this.lastName,
      this.isActive,
      this.dateJoined,
      this.createdAt,
      this.updatedAt,
      this.phone,
      this.image,
      this.middleName,
      this.email});

  ChatRoomUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lastLogin = json['last_login'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    isActive = json['is_active'];
    dateJoined = json['date_joined'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    phone = json['phone'];
    image = json['image'];
    middleName = json['middle_name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['last_login'] = this.lastLogin;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['is_active'] = this.isActive;
    data['date_joined'] = this.dateJoined;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['middle_name'] = this.middleName;
    data['email'] = this.email;
    return data;
  }
}

class MessagesModel {
  String? type;
  String? body;
  String? file;
  String? photo;
  String? createdAt;
  String? name;
  String? typeMessage;
  String? avatar;
  int? messageId;
  int? chatUserId;
  int? userId;

  MessagesModel(
      {this.type,
      this.body,
      this.file,
      this.photo,
      this.createdAt,
      this.name,
      this.typeMessage,
      this.avatar,
      this.messageId,
      this.chatUserId,
      this.userId});

  MessagesModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    body = json['body'];
    file = json['file'];
    photo = json['photo'];
    createdAt = json['created_at'];
    name = json['name'];
    typeMessage = json['type_message'];
    avatar = json['avatar'];
    messageId = json['message_id'];
    chatUserId = json['chat_user_id'];
    userId = json['user_id']??json['chat_user']['user']['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['body'] = this.body;
    data['file'] = this.file;
    data['photo'] = this.photo;
    data['created_at'] = this.createdAt;
    data['name'] = this.name;
    data['type_message'] = this.typeMessage;
    data['avatar'] = this.avatar;
    data['message_id'] = this.messageId;
    data['chat_user_id'] = this.chatUserId;
    data['user_id'] = this.userId;
    return data;
  }
}

//Messages------------------------------------------------------------
class MessagesOldModel {
  int? count;
  String? next;
  String? previous;
  List<MessagesModel>? results;

  MessagesOldModel({this.count, this.next, this.previous, this.results});

  MessagesOldModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <MessagesModel>[];
      json['results'].forEach((v) {
        results!.add(MessagesModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'MessagesOldModel(count: $count, next: $next, previous: $previous, results: $results)';
  }
}

class ProductInRoomModel {
  int? id;
  List<PhotosModel>? photos;
  bool? favorite;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? description;
  String? price;
  String? photo;
  String? ownerName;
  String? ownerPhone;
  String? ownerEmail;
  String? address;
  int? category;

  ProductInRoomModel(
      {this.id,
      this.photos,
      this.favorite,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.description,
      this.price,
      this.photo,
      this.ownerName,
      this.ownerPhone,
      this.ownerEmail,
      this.address,
      this.category});

  ProductInRoomModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['photos'] != null) {
      photos = <PhotosModel>[];
      json['photos'].forEach((v) {
        photos!.add(PhotosModel.fromJson(v));
      });
    }
    favorite = json['favorite'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    photo = json['photo'];
    ownerName = json['owner_name'];
    ownerPhone = json['owner_phone'];
    ownerEmail = json['owner_email'];
    address = json['address'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.photos != null) {
      data['photos'] = this.photos!.map((v) => v.toJson()).toList();
    }
    data['favorite'] = this.favorite;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['photo'] = this.photo;
    data['owner_name'] = this.ownerName;
    data['owner_phone'] = this.ownerPhone;
    data['owner_email'] = this.ownerEmail;
    data['address'] = this.address;
    data['category'] = this.category;
    return data;
  }
}

class PhotosModel {
  int? id;
  String? photo;

  PhotosModel({this.id, this.photo});

  PhotosModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['photo'] = this.photo;
    return data;
  }
}
