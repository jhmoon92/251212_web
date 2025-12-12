import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
part 'account_resp.g.dart';

// --------------------------------------------------------------- //
@JsonSerializable()
class UserLogin {
  String token_type;
  String access_token;
  int expires_in;

  UserLogin(this.token_type, this.access_token, this.expires_in);

  factory UserLogin.fromJson(Map<String, dynamic> json) => _$UserLoginFromJson(json);
  Map<String, dynamic> toJson() => _$UserLoginToJson(this);
}
@JsonSerializable()
class UserListResponse {
  final List<User> content;
  final Pageable pageable;
  final int total;
  final bool last;
  final int totalPages;
  final int totalElements;
  final int size;
  final int number;
  final Sort sort;
  final bool first;
  final int numberOfElements;
  final bool empty;

  UserListResponse({
    required this.content,
    required this.pageable,
    required this.total,
    required this.last,
    required this.totalPages,
    required this.totalElements,
    required this.size,
    required this.number,
    required this.sort,
    required this.first,
    required this.numberOfElements,
    required this.empty,
  });

  factory UserListResponse.fromJson(Map<String, dynamic> json) => _$UserListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserListResponseToJson(this);
}

@JsonSerializable()
class User {
  final int id;
  final String email;
  final String status;
  final String signInDate;
  final bool isPaired;
  final int pairedNum;
  final String createdAt;
  final String memo;

  User({
    required this.id,
    required this.email,
    required this.status,
    required this.signInDate,
    required this.isPaired,
    required this.pairedNum,
    required this.createdAt,
    required this.memo,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Pageable {
  final int page;
  final int size;
  final Sort sort;
  final int offset;
  final int pageNumber;
  final int pageSize;
  final bool paged;
  final bool unpaged;

  Pageable({
    required this.page,
    required this.size,
    required this.sort,
    required this.offset,
    required this.pageNumber,
    required this.pageSize,
    required this.paged,
    required this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) => _$PageableFromJson(json);
  Map<String, dynamic> toJson() => _$PageableToJson(this);
}

@JsonSerializable()
class Sort {
  final List<Order> orders;
  final bool empty;
  final bool sorted;
  final bool unsorted;

  Sort({
    required this.orders,
    required this.empty,
    required this.sorted,
    required this.unsorted,
  });

  factory Sort.fromJson(Map<String, dynamic> json) => _$SortFromJson(json);
  Map<String, dynamic> toJson() => _$SortToJson(this);
}

@JsonSerializable()
class Order {
  final String direction;
  final String property;
  final bool ignoreCase;
  final String nullHandling;
  final bool ascending;
  final bool descending;

  Order({
    required this.direction,
    required this.property,
    required this.ignoreCase,
    required this.nullHandling,
    required this.ascending,
    required this.descending,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
