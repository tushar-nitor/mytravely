class HotelListResponse {
  final bool status;
  final String message;
  final int responseCode;
  final List<Hotel> data;

  HotelListResponse({required this.status, required this.message, required this.responseCode, required this.data});

  factory HotelListResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List? ?? []);
    return HotelListResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      responseCode: json['responseCode'] ?? 0,
      data: list.map((e) => Hotel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class Hotel {
  final String propertyName;
  final int propertyStar;
  final String propertyImage;
  final String propertyCode;
  final String propertyType;
  final Price markedPrice;
  final Price staticPrice;
  final PoliciesAndAmenities propertyPoliciesAndAmmenities;
  final GoogleReview googleReview;
  final String propertyUrl;
  final PropertyAddress propertyAddress;

  Hotel({
    required this.propertyName,
    required this.propertyStar,
    required this.propertyImage,
    required this.propertyCode,
    required this.propertyType,
    required this.markedPrice,
    required this.staticPrice,
    required this.propertyPoliciesAndAmmenities,
    required this.googleReview,
    required this.propertyUrl,
    required this.propertyAddress,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      propertyName: json['propertyName'] ?? '',
      propertyStar: (json['propertyStar'] ?? 0) is int
          ? json['propertyStar']
          : int.tryParse('${json['propertyStar']}') ?? 0,
      propertyImage: (json['propertyImage'] is String)
          ? json['propertyImage']
          : (json['propertyImage'] is Map ? json['propertyImage']['fullUrl'] ?? '' : ''),
      propertyCode: json['propertyCode'] ?? '',
      propertyType: json['propertyType'] ?? '',
      markedPrice: Price.fromJson(json['markedPrice'] ?? const {}),
      staticPrice: Price.fromJson(json['staticPrice'] ?? const {}),
      propertyPoliciesAndAmmenities: PoliciesAndAmenities.fromJson(json['propertyPoliciesAndAmmenities'] ?? const {}),
      googleReview: GoogleReview.fromJson(json['googleReview'] ?? const {}),
      propertyUrl: json['propertyUrl'] ?? '',
      propertyAddress: PropertyAddress.fromJson(json['propertyAddress'] ?? const {}),
    );
  }
}

class Price {
  final num amount;
  final String displayAmount;
  final String currencyAmount;
  final String currencySymbol;

  const Price({
    required this.amount,
    required this.displayAmount,
    required this.currencyAmount,
    required this.currencySymbol,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return const Price(amount: 0, displayAmount: '', currencyAmount: '', currencySymbol: '');
    }
    return Price(
      amount: (json['amount'] ?? 0) is num ? json['amount'] : num.tryParse('${json['amount']}') ?? 0,
      displayAmount: json['displayAmount'] ?? '',
      currencyAmount: json['currencyAmount'] ?? '',
      currencySymbol: json['currencySymbol'] ?? '',
    );
  }
}

class PoliciesAndAmenities {
  final bool present;
  final PolicyData? data;

  PoliciesAndAmenities({required this.present, required this.data});

  factory PoliciesAndAmenities.fromJson(Map<String, dynamic> json) {
    final present = json['present'] ?? false;
    final dataJson = json['data'];
    return PoliciesAndAmenities(
      present: present,
      data: dataJson is Map<String, dynamic> ? PolicyData.fromJson(dataJson) : null,
    );
  }
}

class PolicyData {
  final String cancelPolicy;
  final String refundPolicy;
  final String childPolicy;
  final String damagePolicy;
  final String propertyRestriction;
  final bool petsAllowed;
  final bool coupleFriendly;
  final bool suitableForChildren;
  final bool bachularsAllowed;
  final bool freeWifi;
  final bool freeCancellation;
  final bool payAtHotel;
  final bool payNow;
  final String lastUpdatedOn;

  PolicyData({
    required this.cancelPolicy,
    required this.refundPolicy,
    required this.childPolicy,
    required this.damagePolicy,
    required this.propertyRestriction,
    required this.petsAllowed,
    required this.coupleFriendly,
    required this.suitableForChildren,
    required this.bachularsAllowed,
    required this.freeWifi,
    required this.freeCancellation,
    required this.payAtHotel,
    required this.payNow,
    required this.lastUpdatedOn,
  });

  factory PolicyData.fromJson(Map<String, dynamic> json) {
    return PolicyData(
      cancelPolicy: json['cancelPolicy'] ?? '',
      refundPolicy: json['refundPolicy'] ?? '',
      childPolicy: json['childPolicy'] ?? '',
      damagePolicy: json['damagePolicy'] ?? '',
      propertyRestriction: json['propertyRestriction'] ?? '',
      petsAllowed: json['petsAllowed'] ?? false,
      coupleFriendly: json['coupleFriendly'] ?? false,
      suitableForChildren: json['suitableForChildren'] ?? false,
      bachularsAllowed: json['bachularsAllowed'] ?? false,
      freeWifi: json['freeWifi'] ?? false,
      freeCancellation: json['freeCancellation'] ?? false,
      payAtHotel: json['payAtHotel'] ?? false,
      payNow: json['payNow'] ?? false,
      lastUpdatedOn: json['lastUpdatedOn'] ?? '',
    );
  }
}

class GoogleReview {
  final bool reviewPresent;
  final double overallRating;
  final int totalUserRating;
  final int withoutDecimal;

  GoogleReview({
    required this.reviewPresent,
    required this.overallRating,
    required this.totalUserRating,
    required this.withoutDecimal,
  });

  factory GoogleReview.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty || (json['reviewPresent'] ?? false) == false) {
      return GoogleReview(
        reviewPresent: json['reviewPresent'] ?? false,
        overallRating: 0.0,
        totalUserRating: 0,
        withoutDecimal: 0,
      );
    }
    final data = json['data'] ?? const {};
    return GoogleReview(
      reviewPresent: json['reviewPresent'] ?? false,
      overallRating: (data['overallRating'] ?? 0).toDouble(),
      totalUserRating: data['totalUserRating'] ?? 0,
      withoutDecimal: data['withoutDecimal'] ?? 0,
    );
  }
}

class PropertyAddress {
  final String street;
  final String city;
  final String state;
  final String country;
  final String zipcode;
  final String mapAddress;
  final double latitude;
  final double longitude;

  PropertyAddress({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.zipcode,
    required this.mapAddress,
    required this.latitude,
    required this.longitude,
  });

  factory PropertyAddress.fromJson(Map<String, dynamic> json) {
    return PropertyAddress(
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      zipcode: json['zipcode'] ?? '',
      mapAddress: json['map_address'] ?? '',
      latitude: (json['latitude'] ?? 0) is num
          ? (json['latitude'] as num).toDouble()
          : double.tryParse('${json['latitude']}') ?? 0.0,
      longitude: (json['longitude'] ?? 0) is num
          ? (json['longitude'] as num).toDouble()
          : double.tryParse('${json['longitude']}') ?? 0.0,
    );
  }
}
