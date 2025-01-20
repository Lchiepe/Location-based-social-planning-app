class UserProfile {
  String? uid;
  String? name;
  String? pfpURL;


  UserProfile({
    required this.uid,
    required this.name,
    required this.pfpURL,

});
  UserProfile.fromJson(Map<String, dynamic> json){
    uid = json['uid'];
    name = json['name'];
    pfpURL = json['pfpURL'];


  }


  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['pfpURL'] = pfpURL;
    data['uid'] = uid;

    return data;
  }

}


class LocationProfile{
  double? latitude;
  double? longitude;

  LocationProfile({
    required this.latitude,
    required this.longitude

  });


  LocationProfile.fromJson(Map<String, dynamic> json){
    latitude = json['latitude'];
    longitude = json['longitude'];

  }


  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] =latitude;
    data['longitude'] =longitude;

    return data;
  }

}