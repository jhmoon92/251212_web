// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLogin _$UserLoginFromJson(Map<String, dynamic> json) => UserLogin(
  json['token_type'] as String,
  json['access_token'] as String,
  (json['expires_in'] as num).toInt(),
);

Map<String, dynamic> _$UserLoginToJson(UserLogin instance) => <String, dynamic>{
  'token_type': instance.token_type,
  'access_token': instance.access_token,
  'expires_in': instance.expires_in,
};

UserListResponse _$UserListResponseFromJson(Map<String, dynamic> json) =>
    UserListResponse(
      content:
          (json['content'] as List<dynamic>)
              .map((e) => User.fromJson(e as Map<String, dynamic>))
              .toList(),
      pageable: Pageable.fromJson(json['pageable'] as Map<String, dynamic>),
      total: (json['total'] as num).toInt(),
      last: json['last'] as bool,
      totalPages: (json['totalPages'] as num).toInt(),
      totalElements: (json['totalElements'] as num).toInt(),
      size: (json['size'] as num).toInt(),
      number: (json['number'] as num).toInt(),
      sort: Sort.fromJson(json['sort'] as Map<String, dynamic>),
      first: json['first'] as bool,
      numberOfElements: (json['numberOfElements'] as num).toInt(),
      empty: json['empty'] as bool,
    );

Map<String, dynamic> _$UserListResponseToJson(UserListResponse instance) =>
    <String, dynamic>{
      'content': instance.content,
      'pageable': instance.pageable,
      'total': instance.total,
      'last': instance.last,
      'totalPages': instance.totalPages,
      'totalElements': instance.totalElements,
      'size': instance.size,
      'number': instance.number,
      'sort': instance.sort,
      'first': instance.first,
      'numberOfElements': instance.numberOfElements,
      'empty': instance.empty,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String,
  status: json['status'] as String,
  signInDate: json['signInDate'] as String,
  isPaired: json['isPaired'] as bool,
  pairedNum: (json['pairedNum'] as num).toInt(),
  createdAt: json['createdAt'] as String,
  memo: json['memo'] as String,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'status': instance.status,
  'signInDate': instance.signInDate,
  'isPaired': instance.isPaired,
  'pairedNum': instance.pairedNum,
  'createdAt': instance.createdAt,
  'memo': instance.memo,
};

Pageable _$PageableFromJson(Map<String, dynamic> json) => Pageable(
  page: (json['page'] as num).toInt(),
  size: (json['size'] as num).toInt(),
  sort: Sort.fromJson(json['sort'] as Map<String, dynamic>),
  offset: (json['offset'] as num).toInt(),
  pageNumber: (json['pageNumber'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
  paged: json['paged'] as bool,
  unpaged: json['unpaged'] as bool,
);

Map<String, dynamic> _$PageableToJson(Pageable instance) => <String, dynamic>{
  'page': instance.page,
  'size': instance.size,
  'sort': instance.sort,
  'offset': instance.offset,
  'pageNumber': instance.pageNumber,
  'pageSize': instance.pageSize,
  'paged': instance.paged,
  'unpaged': instance.unpaged,
};

Sort _$SortFromJson(Map<String, dynamic> json) => Sort(
  orders:
      (json['orders'] as List<dynamic>)
          .map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList(),
  empty: json['empty'] as bool,
  sorted: json['sorted'] as bool,
  unsorted: json['unsorted'] as bool,
);

Map<String, dynamic> _$SortToJson(Sort instance) => <String, dynamic>{
  'orders': instance.orders,
  'empty': instance.empty,
  'sorted': instance.sorted,
  'unsorted': instance.unsorted,
};

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
  direction: json['direction'] as String,
  property: json['property'] as String,
  ignoreCase: json['ignoreCase'] as bool,
  nullHandling: json['nullHandling'] as String,
  ascending: json['ascending'] as bool,
  descending: json['descending'] as bool,
);

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
  'direction': instance.direction,
  'property': instance.property,
  'ignoreCase': instance.ignoreCase,
  'nullHandling': instance.nullHandling,
  'ascending': instance.ascending,
  'descending': instance.descending,
};
