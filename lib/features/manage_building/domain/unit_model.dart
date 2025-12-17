import 'dart:math';

import 'package:flutter/material.dart';

import '../../../common/util/util.dart';
import '../../../config/style.dart';
import '../../admin_member/presentation/admin_members_screen.dart';
import '../../alert/presentation/alert_screen.dart';

class Building {
  final String id;
  final String name;
  final String address;
  final int totalUnit;
  final int activeUnit;
  final int criticalUnit;
  final int warningUnit;
  final bool hasAlert;
  final String manager;
  final List<Unit> unitList;

  Building({
    required this.id,
    required this.name,
    required this.address,
    required this.totalUnit,
    required this.activeUnit,
    required this.criticalUnit,
    required this.warningUnit,
    this.hasAlert = false,
    required this.manager,
    required this.unitList,
  });
}

class Unit {
  final String id;
  final String number;
  final String status; // 'offline', 'critical', 'warning', 'normal'
  final int lastMotion;
  final bool isAlert;
  final bool isConnected;
  final ResidentDetail resident;
  final ManagerDetail manager;
  final List<InstalledDevice> devices;

  Unit({
    required this.id,
    required this.number,
    required this.status,
    required this.lastMotion,
    this.isAlert = false,
    this.isConnected = true,
    required this.resident,
    required this.manager,
    required this.devices,
  });

  // 타일 경계선 색상 결정
  Color get tileColor {
    if (isAlert) return Colors.red;
    if (status == 'offline') return commonGrey6;
    if (status == 'normal') return themeGreen;
    return commonGrey3;
  }
}

class ResidentDetail {
  final String name;
  final int born; // 태어난 연도
  final String gender;
  final String phone;

  ResidentDetail({required this.name, required this.born, required this.gender, required this.phone});

  // 선택 사항: JSON 역직렬화 (fromMap 또는 fromJson)
  factory ResidentDetail.fromJson(Map<String, dynamic> json) {
    return ResidentDetail(
      name: json['name'] as String,
      born: json['born'] as int,
      gender: json['gender'] as String,
      phone: json['phone'] as String,
    );
  }
}

class ManagerDetail {
  final String name;
  final String account; // 사용자 계정 ID
  final String contact; // 연락처

  ManagerDetail({required this.name, required this.account, required this.contact});

  factory ManagerDetail.fromJson(Map<String, dynamic> json) {
    return ManagerDetail(name: json['name'] as String, account: json['account'] as String, contact: json['contact'] as String);
  }

  // **** 여기에 아래 두 메서드를 추가하세요 ****

  // 1. operator == 오버라이드: name, account, contact가 모두 같을 때 true 반환
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    // 타입이 같고, 필드 값이 모두 같은지 확인
    return other is ManagerDetail &&
        name == other.name &&
        account == other.account &&
        contact == other.contact;
  }

  // 2. hashCode 오버라이드: Set이 중복을 효율적으로 찾을 수 있도록 필드들을 조합하여 해시 코드를 생성
  @override
  int get hashCode => name.hashCode ^ account.hashCode ^ contact.hashCode;
}

class InstalledDevice {
  final String name;
  final String serialNumber; // 191720010QWERA와 같은 고유 번호
  final String status; // ONLINE 상태
  final String installer;
  final DateTime installationDate;

  InstalledDevice({
    required this.name,
    required this.serialNumber,
    required this.status,
    required this.installer,
    required this.installationDate,
  });

  factory InstalledDevice.fromJson(Map<String, dynamic> json) {
    return InstalledDevice(
      name: json['name'] as String,
      serialNumber: json['serialNumber'] as String,
      status: json['status'] as String,
      installer: json['installer'] as String,
      installationDate: DateTime.parse(json['installationDate'] as String),
    );
  }
}

class Device {
  final String buildingName;
  final String unitNumber;
  final String residentName;
  // InstalledDevice の既存のプロパティ
  final String name;
  final String serialNumber;
  final String status;
  final String installer;
  final DateTime installationDate;

  Device({
    required this.buildingName,
    required this.unitNumber,
    required this.residentName,
    required this.name,
    required this.serialNumber,
    required this.status,
    required this.installer,
    required this.installationDate,
  });

  String toCsvString() {
    return [
      serialNumber,
      buildingName,
      unitNumber,
      residentName,
      status,
      installer,
      installationDate,
    ].join(',');
  }
}

class Installer {
  final String name;
  final String id;
  Installer(this.name, this.id);
}

final List<MemberCardData> members = [
  // 1. 최고 관리자 (Supervisor)
  MemberCardData(
    name: 'Tanaka',
    role: 'MASTER',
    isActive: true,
    accountEmail: 'tanaka.sup@monipod.jp',
    phoneNumber: '+81-3-1234-5678',
    assignedRegion: 'Global Access', // 전역 관리자
  ),
  // 2. 간토 지역 관리자 (Manager, Active)
  MemberCardData(
    name: 'Sato',
    role: 'SUBMASTER (MANAGER)',
    isActive: true,
    accountEmail: 'sato.mngr@monipod.jp',
    phoneNumber: '+81-3-2345-6789',
    assignedRegion: 'Kanto (Tokyo)', // 관동 지방 (도쿄)
  ),
  // 3. 간사이 지역 설치 기술자 (Installer, Active)
  MemberCardData(
    name: 'Kato',
    role: 'SUBMASTER (INSTALLER)',
    isActive: true,
    accountEmail: 'kato.inst@monipod.jp',
    phoneNumber: '+81-6-3456-7890',
    assignedRegion: 'Kansai (Osaka)', // 관서 지방 (오사카)
  ),
  // 4. 비활성화된 계정 (Inactive, Manager) - 홋카이도
  MemberCardData(
    name: 'Yamada',
    role: 'SUBMASTER (MANAGER)',
    isActive: false, // 🚨 비활성화 상태
    accountEmail: 'yamada.off@monipod.jp',
    phoneNumber: '+81-11-4567-8901',
    assignedRegion: 'Hokkaido', // 홋카이도
  ),
  // 5. 주부 지역 신규 설치 기술자 (New Installer) - 나고야
  MemberCardData(
    name: 'Suzuki',
    role: 'SUBMASTER (INSTALLER)',
    isActive: true,
    accountEmail: 'suzuki.new@monipod.jp',
    phoneNumber: '+81-52-5678-9012',
    assignedRegion: 'Chubu (Nagoya)', // 중부 지방 (나고야)
  ),
  // 6. 규슈 지역 예비 관리자 (Reserve Manager) - 후쿠오카
  MemberCardData(
    name: 'Takahashi',
    role: 'SUBMASTER (MANAGER)',
    isActive: false,
    accountEmail: 'takahashi.res@monipod.jp',
    phoneNumber: '+81-92-6789-0123',
    assignedRegion: 'Kyushu (Fukuoka)', // 규슈 지방 (후쿠오카)
  ),
  // 7. 도호쿠 지역 기술자 (Tohoku) - 센다이
  MemberCardData(
    name: 'Kobayashi',
    role: 'SUBMASTER (INSTALLER)',
    isActive: false,
    accountEmail: 'koba.field@monipod.jp',
    phoneNumber: '+81-22-7890-1234',
    assignedRegion: 'Tohoku (Sendai)', // 도호쿠 지방 (센다이)
  ),
];


// 1. 일본인 설치자 10명 구성
final List<Installer> dummyInstallers = [
  Installer('佐藤 太郎 (Sato Taro)', 'sato_t'),
  Installer('田中 花子 (Tanaka Hanako)', 'tanaka_h'),
  Installer('山本 一郎 (Yamamoto Ichiro)', 'yamamoto_i'),
  Installer('中村 美咲 (Nakamura Misaki)', 'nakamura_m'),
  Installer('小林 健太 (Kobayashi Kenta)', 'kobayashi_k'),
  Installer('加藤 陽子 (Kato Yoko)', 'kato_y'),
  Installer('吉田 拓海 (Yoshida Takumi)', 'yoshida_t'),
  Installer('山田 恵美 (Yamada Emi)', 'yamada_e'),
  Installer('佐々木 翼 (Sasaki Tsubasa)', 'sasaki_tsu'),
  Installer('松本 悟 (Matsumoto Satoru)', 'matsumoto_s'),
];

final List<Building> buildings = [
  Building(
    id: 'B1',
    name: '緑風苑',
    // 도쿄도 미나토구 시바우라 3-chome 1-30
    address: '東京都 港区 芝浦 3-1-30',
    totalUnit: units1.length,
    activeUnit: units1.where((unit) => unit.status != 'offline').length,
    criticalUnit: units1.where((unit) => unit.status == 'critical').length,
    warningUnit: units1.where((unit) => unit.status == 'warning').length,
    hasAlert: units1.any((unit) => unit.status == 'critical'),
    manager: '田中 浩 (Tanaka Hiroshi)',
    unitList: units1,
  ),
  Building(
    id: 'B2',
    name: '月島レジデンス',
    // 오사카부 오사카시 키타구 우메다 1-chome 12-12
    address: '大阪府 大阪市 北区 梅田 1-12-12',
    totalUnit: units2.length,
    activeUnit: units2.where((unit) => unit.status != 'offline').length,
    criticalUnit: units2.where((unit) => unit.status == 'critical').length,
    warningUnit: units2.where((unit) => unit.status == 'warning').length,
    hasAlert: units2.any((unit) => unit.status == 'critical'),
    manager: '佐藤 健 (Sato Ken)',
    unitList: units2,
  ),
  Building(
    id: 'B3',
    name: '桜上水アパートメント',
    // 아이치현 나고야시 나카구 사카에 4-chome 1-1
    address: '愛知県 名古屋市 中区 栄 4-1-1',
    totalUnit: units3.length,
    activeUnit: units3.where((unit) => unit.status != 'offline').length,
    criticalUnit: units3.where((unit) => unit.status == 'critical').length,
    warningUnit: units3.where((unit) => unit.status == 'warning').length,
    hasAlert: units3.any((unit) => unit.status == 'critical'),
    manager: '山田 花子 (Yamada Hanako)',
    unitList: units3,
  ),
  Building(
    id: 'B4',
    name: '代官山ハイツ',
    // 후쿠오카현 후쿠오카시 하카타구 하카타에키마에 2-chome 1-1
    address: '福岡県 福岡市 博多区 博多駅前 2-1-1',
    totalUnit: units4.length,
    activeUnit: units4.where((unit) => unit.status != 'offline').length,
    criticalUnit: units4.where((unit) => unit.status == 'critical').length,
    warningUnit: units4.where((unit) => unit.status == 'warning').length,
    hasAlert: units4.any((unit) => unit.status == 'critical'),
    manager: '木村 翼 (Kimura Tsubasa)',
    unitList: units4,
  ),
];

final List<Unit> allUnits = [...units1, ...units2, ...units3, ...units4];

final List<Unit> units1 = [
  Unit(
    id: 'B1-U01', // ID 추가
    number: '101',
    status: 'normal',
    lastMotion: 15, // 15분 전
    isAlert: false,
    resident: ResidentDetail(name: '佐藤 健太 (Sato Kenta)', born: 1955, gender: 'Male', phone: '090-1234-5678'),
    manager: ManagerDetail(name: '田中 浩 (Tanaka Hiroshi)', account: 'tanaka_mgr', contact: '080-9999-0001'),
    devices: [
      InstalledDevice(
        name: '玄関モーションセンサー',
        serialNumber: 'JP1923A0010QWEA',
        status: 'ONLINE',
        installer: 'Fixit Tokyo',
        installationDate: DateTime(2024, 5, 1, 10, 0),
      ),
    ],
  ),
  Unit(
    id: 'B1-U02', // ID 추가
    number: '102',
    status: 'warning',
    lastMotion: 240, // 4시간 전
    isAlert: false,
    resident: ResidentDetail(name: '高橋 優子 (Takahashi Yuko)', born: 1968, gender: 'Female', phone: '090-2345-6789'),
    manager: ManagerDetail(name: '田中 浩 (Tanaka Hiroshi)', account: 'tanaka_mgr', contact: '080-9999-0001'),
    devices: [
      InstalledDevice(
        name: 'リビング温度センサー',
        serialNumber: 'JP1923A002',
        status: 'ONLINE',
        installer: 'Fixit Tokyo',
        installationDate: DateTime(2024, 5, 1, 12, 0),
      ),
      InstalledDevice(
        name: 'ベッド離床センサー',
        serialNumber: 'JP1923A903',
        status: 'ONLINE',
        installer: 'Fixit Tokyo',
        installationDate: DateTime(2024, 5, 1, 12, 30),
      ),
    ],
  ),
  Unit(
    id: 'B1-U03', // ID 추가
    number: '201',
    status: 'critical',
    lastMotion: 1800, // 30시간 전
    isAlert: true,
    resident: ResidentDetail(name: '中村 治 (Nakamura Osamu)', born: 1940, gender: 'Male', phone: '090-3456-7890'),
    manager: ManagerDetail(name: '佐藤 健 (Sato Ken)', account: 'sato_mgr', contact: '080-9999-0002'),
    devices: [
      InstalledDevice(
        name: 'ベッド離床センサー',
        serialNumber: 'JP1923A003',
        status: 'ONLINE',
        installer: 'Life Care Co.',
        installationDate: DateTime(2024, 5, 5, 15, 30),
      ),
    ],
  ),
  Unit(
    id: 'B1-U04', // ID 추가
    number: '202',
    status: 'offline',
    lastMotion: 0,
    isConnected: false,
    isAlert: true,
    resident: ResidentDetail(name: '山本 和子 (Yamamoto Kazuko)', born: 1960, gender: 'Female', phone: '090-4567-8901'),
    manager: ManagerDetail(name: '佐藤 健 (Sato Ken)', account: 'sato_mgr', contact: '080-9999-0002'),
    devices: [
      InstalledDevice(
        name: 'ゲートウェイデバイス',
        serialNumber: 'JP1923A004',
        status: 'OFFLINE',
        installer: 'Life Care Co.',
        installationDate: DateTime(2024, 5, 5, 17, 0),
      ),
    ],
  ),
  Unit(
    id: 'B1-U05', // ID 추가
    number: '301',
    status: 'normal',
    lastMotion: 50,
    isAlert: false,
    resident: ResidentDetail(name: '渡辺 誠 (Watanabe Makoto)', born: 1958, gender: 'Male', phone: '090-5678-9012'),
    manager: ManagerDetail(name: '田中 浩 (Tanaka Hiroshi)', account: 'tanaka_mgr', contact: '080-9999-0001'),
    devices: [
      InstalledDevice(
        name: 'キッチン熱感知',
        serialNumber: 'JP1923A005',
        status: 'ONLINE',
        installer: 'Fire Safety',
        installationDate: DateTime(2024, 5, 10, 10, 0),
      ),
    ],
  ),
  Unit(
    id: 'B1-U06', // ID 추가
    number: '302',
    status: 'warning',
    lastMotion: 480, // 8시간 전
    isAlert: true,
    resident: ResidentDetail(name: '中村 雅美 (Nakamura Masami)', born: 1948, gender: 'Female', phone: '090-6789-0123'),
    manager: ManagerDetail(name: '佐藤 健 (Sato Ken)', account: 'sato_mgr', contact: '080-9999-0002'),
    devices: [
      InstalledDevice(
        name: 'トイレ緊急ボタン',
        serialNumber: 'JP1923A006',
        status: 'ONLINE',
        installer: 'Fire Safety',
        installationDate: DateTime(2024, 5, 10, 11, 30),
      ),
    ],
  ),
  Unit(
    id: 'B1-U07', // ID 추가
    number: '401',
    status: 'normal',
    lastMotion: 5,
    isAlert: false,
    resident: ResidentDetail(name: '小林 大輔 (Kobayashi Daisuke)', born: 1972, gender: 'Male', phone: '090-7890-1234'),
    manager: ManagerDetail(name: '田中 浩 (Tanaka Hiroshi)', account: 'tanaka_mgr', contact: '080-9999-0001'),
    devices: [
      InstalledDevice(
        name: '窓開閉センサー',
        serialNumber: 'JP1923A007',
        status: 'ONLINE',
        installer: 'Smart Home',
        installationDate: DateTime(2024, 5, 15, 8, 0),
      ),
    ],
  ),
  Unit(
    id: 'B1-U08', // ID 추가
    number: '402',
    status: 'critical',
    lastMotion: 2400, // 40시간 전
    isAlert: true,
    resident: ResidentDetail(name: '加藤 涼子 (Kato Ryoko)', born: 1935, gender: 'Female', phone: '090-8901-2345'),
    manager: ManagerDetail(name: '佐藤 健 (Sato Ken)', account: 'sato_mgr', contact: '080-9999-0002'),
    devices: [
      InstalledDevice(
        name: '活動量計',
        serialNumber: 'JP1923A008',
        status: 'ONLINE',
        installer: 'Smart Home',
        installationDate: DateTime(2024, 5, 15, 9, 30),
      ),
    ],
  ),
  Unit(
    id: 'B1-U09', // ID 추가
    number: '501',
    status: 'normal',
    lastMotion: 15,
    isAlert: false,
    resident: ResidentDetail(name: '吉田 悟 (Yoshida Satoru)', born: 1962, gender: 'Male', phone: '090-9012-3456'),
    manager: ManagerDetail(name: '田中 浩 (Tanaka Hiroshi)', account: 'tanaka_mgr', contact: '080-9999-0001'),
    devices: [
      InstalledDevice(
        name: '玄関ドアセンサー',
        serialNumber: 'JP1923A009',
        status: 'ONLINE',
        installer: 'Local Installer',
        installationDate: DateTime(2024, 5, 20, 12, 0),
      ),
    ],
  ),
  Unit(
    id: 'B1-U10', // ID 추가
    number: '502',
    status: 'warning',
    lastMotion: 540, // 9시간 전
    isAlert: false,
    resident: ResidentDetail(name: '松本 陽子 (Matsumoto Yoko)', born: 1950, gender: 'Female', phone: '090-0123-4567'),
    manager: ManagerDetail(name: '佐藤 健 (Sato Ken)', account: 'sato_mgr', contact: '080-9999-0002'),
    devices: [
      InstalledDevice(
        name: '居室モーションセンサー',
        serialNumber: 'JP1923A010',
        status: 'ONLINE',
        installer: 'Local Installer',
        installationDate: DateTime(2024, 5, 20, 14, 0),
      ),
    ],
  ),
  Unit(
    id: 'B1-U11', // ID 추가
    number: '601',
    status: 'offline',
    lastMotion: 0,
    isConnected: false,
    isAlert: true,
    resident: ResidentDetail(name: '井上 隆 (Inoue Takashi)', born: 1943, gender: 'Male', phone: '090-1234-5678'),
    manager: ManagerDetail(name: '田中 浩 (Tanaka Hiroshi)', account: 'tanaka_mgr', contact: '080-9999-0001'),
    devices: [
      InstalledDevice(
        name: 'Wifiルーター',
        serialNumber: 'JP1923A011',
        status: 'OFFLINE',
        installer: 'NetWorks Japan',
        installationDate: DateTime(2024, 5, 25, 17, 0),
      ),
    ],
  ),
  Unit(
    id: 'B1-U12', // ID 추가
    number: '602',
    status: 'normal',
    lastMotion: 30,
    isAlert: false,
    resident: ResidentDetail(name: '林 恵美 (Hayashi Emi)', born: 1975, gender: 'Female', phone: '090-2345-6789'),
    manager: ManagerDetail(name: '佐藤 健 (Sato Ken)', account: 'sato_mgr', contact: '080-9999-0002'),
    devices: [
      InstalledDevice(
        name: 'スマートロック',
        serialNumber: 'JP1923A012',
        status: 'ONLINE',
        installer: 'NetWorks Japan',
        installationDate: DateTime(2024, 5, 25, 18, 30),
      ),
    ],
  ),
  Unit(
    id: 'B1-U13', // ID 추가
    number: '701',
    status: 'normal',
    lastMotion: 2,
    isAlert: false,
    resident: ResidentDetail(name: '石田 遥 (Ishida Haruka)', born: 1968, gender: 'Male', phone: '090-3456-7890'),
    manager: ManagerDetail(name: '田中 浩 (Tanaka Hiroshi)', account: 'tanaka_mgr', contact: '080-9999-0001'),
    devices: [
      InstalledDevice(
        name: '湿度センサー',
        serialNumber: 'JP1923A013',
        status: 'ONLINE',
        installer: 'Air Quality Inc.',
        installationDate: DateTime(2024, 6, 1, 10, 0),
      ),
    ],
  ),
  Unit(
    id: 'B1-U14', // ID 추가
    number: '702',
    status: 'critical',
    lastMotion: 1800, // 30시간 전
    isAlert: true,
    resident: ResidentDetail(name: '佐々木 明美 (Sasaki Akemi)', born: 1930, gender: 'Female', phone: '090-4567-8901'),
    manager: ManagerDetail(name: '佐藤 健 (Sato Ken)', account: 'sato_mgr', contact: '080-9999-0002'),
    devices: [
      InstalledDevice(
        name: '緊急コールシステム',
        serialNumber: 'JP1923A014',
        status: 'ONLINE',
        installer: 'Air Quality Inc.',
        installationDate: DateTime(2024, 6, 1, 11, 0),
      ),
    ],
  ),
  Unit(
    id: 'B1-U15', // ID 추가
    number: '801',
    status: 'warning',
    lastMotion: 720, // 12시간 전
    isAlert: true,
    resident: ResidentDetail(name: '藤原 剛 (Fujiwara Tsuyoshi)', born: 1955, gender: 'Male', phone: '090-5678-9012'),
    manager: ManagerDetail(name: '田中 浩 (Tanaka Hiroshi)', account: 'tanaka_mgr', contact: '080-9999-0001'),
    devices: [
      InstalledDevice(
        name: 'ガスメーター監視',
        serialNumber: 'JP1923A015',
        status: 'ONLINE',
        installer: 'Gas Safety Japan',
        installationDate: DateTime(2024, 6, 5, 15, 0),
      ),
    ],
  ),
  Unit(
    id: 'B1-U16', // ID 추가
    number: '802',
    status: 'normal',
    lastMotion: 1,
    isAlert: false,
    resident: ResidentDetail(name: '野口 奈々 (Noguchi Nana)', born: 1980, gender: 'Female', phone: '090-6789-0123'),
    manager: ManagerDetail(name: '佐藤 健 (Sato Ken)', account: 'sato_mgr', contact: '080-9999-0002'),
    devices: [
      InstalledDevice(
        name: 'ドアロックセンサー',
        serialNumber: 'JP1923A016',
        status: 'ONLINE',
        installer: 'Gas Safety Japan',
        installationDate: DateTime(2024, 6, 5, 16, 30),
      ),
    ],
  ),
  Unit(
    id: 'B1-U17', // ID 추가
    number: '901',
    status: 'offline',
    lastMotion: 0,
    isConnected: false,
    isAlert: false,
    resident: ResidentDetail(name: '青山 茂 (Aoyama Shigeru)', born: 1945, gender: 'Male', phone: '090-7890-1234'),
    manager: ManagerDetail(name: '田中 浩 (Tanaka Hiroshi)', account: 'tanaka_mgr', contact: '080-9999-0001'),
    devices: [
      InstalledDevice(
        name: 'スマートプラグ',
        serialNumber: 'JP1923A017',
        status: 'OFFLINE',
        installer: 'Eco Power Co.',
        installationDate: DateTime(2024, 6, 10, 14, 0),
      ),
    ],
  ),
  Unit(
    id: 'B1-U18', // ID 추가
    number: '902',
    status: 'normal',
    lastMotion: 60, // 1시간 전
    isAlert: false,
    resident: ResidentDetail(name: '今井 翼 (Imai Tsubasa)', born: 1970, gender: 'Male', phone: '090-8901-2345'),
    manager: ManagerDetail(name: '佐藤 健 (Sato Ken)', account: 'sato_mgr', contact: '080-9999-0002'),
    devices: [
      InstalledDevice(
        name: 'TVモーションセンサー',
        serialNumber: 'JP1923A018',
        status: 'ONLINE',
        installer: 'Eco Power Co.',
        installationDate: DateTime(2024, 6, 10, 15, 30),
      ),
    ],
  ),
  Unit(
    id: 'B1-U19', // ID 추가
    number: '1001',
    status: 'warning',
    lastMotion: 180, // 3시간 전
    isAlert: false,
    resident: ResidentDetail(name: '斎藤 遥 (Saito Haruka)', born: 1965, gender: 'Female', phone: '090-9012-3456'),
    manager: ManagerDetail(name: '田中 浩 (Tanaka Hiroshi)', account: 'tanaka_mgr', contact: '080-9999-0001'),
    devices: [
      InstalledDevice(
        name: '침실 모션',
        serialNumber: 'JP1923A019',
        status: 'ONLINE',
        installer: 'Smart Security',
        installationDate: DateTime(2024, 6, 15, 9, 0),
      ),
    ],
  ),
  Unit(
    id: 'B1-U20', // ID 추가
    number: '1002',
    status: 'critical',
    lastMotion: 3600, // 60시간 전
    isAlert: true,
    resident: ResidentDetail(name: '野村 幸子 (Nomura Sachiko)', born: 1928, gender: 'Female', phone: '090-0123-4567'),
    manager: ManagerDetail(name: '佐藤 健 (Sato Ken)', account: 'sato_mgr', contact: '080-9999-0002'),
    devices: [
      InstalledDevice(
        name: '낙상 감지 센서',
        serialNumber: 'JP1923A020',
        status: 'ONLINE',
        installer: 'Smart Security',
        installationDate: DateTime(2024, 6, 15, 11, 0),
      ),
    ],
  ),
];

final List<Unit> units2 = [
  Unit(
    id: 'B2-U01', // IDを追加
    number: '1F-A01',
    status: 'warning',
    lastMotion: 300, // 5時間前
    isAlert: false,
    resident: ResidentDetail(name: '鈴木 陽菜 (Suzuki Haruna)', born: 1970, gender: 'Female', phone: '090-1111-3333'),
    manager: ManagerDetail(name: '山田 太郎 (Yamada Taro)', account: 'yamada_mgr', contact: '080-1000-0001'),
    devices: [
      InstalledDevice(
        name: '玄関モーションセンサー',
        serialNumber: 'JP2024A001',
        status: 'ONLINE',
        installer: 'Security Corp.',
        installationDate: DateTime(2024, 8, 1, 9, 0),
      ),
    ],
  ),
  Unit(
    id: 'B2-U02', // IDを追加
    number: '1F-A02',
    status: 'normal',
    lastMotion: 10, // 10分前
    isAlert: false,
    resident: ResidentDetail(name: '佐藤 健太 (Sato Kenta)', born: 1955, gender: 'Male', phone: '090-2222-4444'),
    manager: ManagerDetail(name: '山田 太郎 (Yamada Taro)', account: 'yamada_mgr', contact: '080-1000-0001'),
    devices: [
      InstalledDevice(
        name: 'リビング温度センサー',
        serialNumber: 'JP2024A002',
        status: 'ONLINE',
        installer: 'Security Corp.',
        installationDate: DateTime(2024, 8, 1, 11, 0),
      ),
    ],
  ),
  Unit(
    id: 'B2-U03', // IDを追加
    number: '2F-B01',
    status: 'critical',
    lastMotion: 1200, // 20時間前
    isAlert: true,
    resident: ResidentDetail(name: '田中 浩二 (Tanaka Koji)', born: 1940, gender: 'Male', phone: '090-3333-5555'),
    manager: ManagerDetail(name: '小川 美香 (Ogawa Mika)', account: 'ogawa_mgr', contact: '080-2000-0002'),
    devices: [
      InstalledDevice(
        name: 'ベッド離床センサー',
        serialNumber: 'JP2024B003',
        status: 'ONLINE',
        installer: 'Life Care Tech',
        installationDate: DateTime(2024, 8, 5, 14, 30),
      ),
    ],
  ),
  Unit(
    id: 'B2-U04', // IDを追加
    number: '2F-B02',
    status: 'offline',
    lastMotion: 0,
    isConnected: false,
    isAlert: true,
    resident: ResidentDetail(name: '山本 恵子 (Yamamoto Keiko)', born: 1965, gender: 'Female', phone: '090-4444-6666'),
    manager: ManagerDetail(name: '小川 美香 (Ogawa Mika)', account: 'ogawa_mgr', contact: '080-2000-0002'),
    devices: [
      InstalledDevice(
        name: 'ゲートウェイデバイス',
        serialNumber: 'JP2024B004',
        status: 'OFFLINE',
        installer: 'Life Care Tech',
        installationDate: DateTime(2024, 8, 5, 16, 0),
      ),
    ],
  ),
  Unit(
    id: 'B2-U05', // IDを追加
    number: '3F-C01',
    status: 'normal',
    lastMotion: 50,
    isAlert: false,
    resident: ResidentDetail(name: '渡辺 誠 (Watanabe Makoto)', born: 1958, gender: 'Male', phone: '090-5555-7777'),
    manager: ManagerDetail(name: '佐藤 翼 (Sato Tsubasa)', account: 'sato_mgr', contact: '080-3000-0003'),
    devices: [
      InstalledDevice(
        name: 'キッチン熱感知',
        serialNumber: 'JP2024C005',
        status: 'ONLINE',
        installer: 'Fire Safety Co.',
        installationDate: DateTime(2024, 8, 10, 10, 0),
      ),
    ],
  ),
  Unit(
    id: 'B2-U06', // IDを追加
    number: '3F-C02',
    status: 'warning',
    lastMotion: 480, // 8時間前
    isAlert: true,
    resident: ResidentDetail(name: '中村 雅美 (Nakamura Masami)', born: 1948, gender: 'Female', phone: '090-6666-8888'),
    manager: ManagerDetail(name: '佐藤 翼 (Sato Tsubasa)', account: 'sato_mgr', contact: '080-3000-0003'),
    devices: [
      InstalledDevice(
        name: 'トイレ緊急ボタン',
        serialNumber: 'JP2024C006',
        status: 'ONLINE',
        installer: 'Fire Safety Co.',
        installationDate: DateTime(2024, 8, 10, 11, 30),
      ),
    ],
  ),
  Unit(
    id: 'B2-U07', // IDを追加
    number: '4F-D01',
    status: 'normal',
    lastMotion: 5,
    isAlert: false,
    resident: ResidentDetail(name: '小林 大輔 (Kobayashi Daisuke)', born: 1972, gender: 'Male', phone: '090-7777-9999'),
    manager: ManagerDetail(name: '高橋 恵 (Takahashi Megumi)', account: 'takahashi_mgr', contact: '080-4000-0004'),
    devices: [
      InstalledDevice(
        name: '窓開閉センサー',
        serialNumber: 'JP2024D007',
        status: 'ONLINE',
        installer: 'Smart Home Inc.',
        installationDate: DateTime(2024, 8, 15, 8, 0),
      ),
    ],
  ),
  Unit(
    id: 'B2-U08', // IDを追加
    number: '4F-D02',
    status: 'critical',
    lastMotion: 2400, // 40時間前
    isAlert: true,
    resident: ResidentDetail(name: '加藤 涼子 (Kato Ryoko)', born: 1935, gender: 'Female', phone: '090-8888-0000'),
    manager: ManagerDetail(name: '高橋 恵 (Takahashi Megumi)', account: 'takahashi_mgr', contact: '080-4000-0004'),
    devices: [
      InstalledDevice(
        name: '活動量計',
        serialNumber: 'JP2024D008',
        status: 'ONLINE',
        installer: 'Smart Home Inc.',
        installationDate: DateTime(2024, 8, 15, 9, 30),
      ),
    ],
  ),
  Unit(
    id: 'B2-U09', // IDを追加
    number: '5F-E01',
    status: 'normal',
    lastMotion: 15,
    isAlert: false,
    resident: ResidentDetail(name: '吉田 悟 (Yoshida Satoru)', born: 1962, gender: 'Male', phone: '090-9999-1111'),
    manager: ManagerDetail(name: '田中 浩 (Tanaka Hiroshi)', account: 'tanaka_mgr', contact: '080-9999-0001'),
    devices: [
      InstalledDevice(
        name: '玄関ドアセンサー',
        serialNumber: 'JP2024E009',
        status: 'ONLINE',
        installer: 'Local Installer',
        installationDate: DateTime(2024, 8, 20, 12, 0),
      ),
    ],
  ),
  Unit(
    id: 'B2-U10', // IDを追加
    number: '5F-E02',
    status: 'warning',
    lastMotion: 540, // 9時間前
    isAlert: false,
    resident: ResidentDetail(name: '松本 陽子 (Matsumoto Yoko)', born: 1950, gender: 'Female', phone: '090-1234-5678'),
    manager: ManagerDetail(name: '田中 浩 (Tanaka Hiroshi)', account: 'tanaka_mgr', contact: '080-9999-0001'),
    devices: [
      InstalledDevice(
        name: '居室モーションセンサー',
        serialNumber: 'JP2024E010',
        status: 'ONLINE',
        installer: 'Local Installer',
        installationDate: DateTime(2024, 8, 20, 14, 0),
      ),
    ],
  ),
  Unit(
    id: 'B2-U11', // IDを追加
    number: '6F-F01',
    status: 'offline',
    lastMotion: 0,
    isConnected: false,
    isAlert: true,
    resident: ResidentDetail(name: '井上 隆 (Inoue Takashi)', born: 1943, gender: 'Male', phone: '090-2345-6789'),
    manager: ManagerDetail(name: '小川 美香 (Ogawa Mika)', account: 'ogawa_mgr', contact: '080-2000-0002'),
    devices: [
      InstalledDevice(
        name: 'Wifiルーター',
        serialNumber: 'JP2024F011',
        status: 'OFFLINE',
        installer: 'NetWorks Japan',
        installationDate: DateTime(2024, 8, 25, 17, 0),
      ),
    ],
  ),
  Unit(
    id: 'B2-U12', // IDを追加
    number: '6F-F02',
    status: 'normal',
    lastMotion: 30,
    isAlert: false,
    resident: ResidentDetail(name: '林 恵美 (Hayashi Emi)', born: 1975, gender: 'Female', phone: '090-3456-7890'),
    manager: ManagerDetail(name: '小川 美香 (Ogawa Mika)', account: 'ogawa_mgr', contact: '080-2000-0002'),
    devices: [
      InstalledDevice(
        name: 'スマートロック',
        serialNumber: 'JP2024F012',
        status: 'ONLINE',
        installer: 'NetWorks Japan',
        installationDate: DateTime(2024, 8, 25, 18, 30),
      ),
    ],
  ),
  Unit(
    id: 'B2-U13', // IDを追加
    number: '7F-G01',
    status: 'normal',
    lastMotion: 2,
    isAlert: false,
    resident: ResidentDetail(name: '石田 遥 (Ishida Haruka)', born: 1968, gender: 'Male', phone: '090-4567-8901'),
    manager: ManagerDetail(name: '佐藤 翼 (Sato Tsubasa)', account: 'sato_mgr', contact: '080-3000-0003'),
    devices: [
      InstalledDevice(
        name: '湿度センサー',
        serialNumber: 'JP2024G013',
        status: 'ONLINE',
        installer: 'Air Quality Inc.',
        installationDate: DateTime(2024, 9, 1, 10, 0),
      ),
    ],
  ),
  Unit(
    id: 'B2-U14', // IDを追加
    number: '7F-G02',
    status: 'critical',
    lastMotion: 1800, // 30時間前
    isAlert: true,
    resident: ResidentDetail(name: '佐々木 明美 (Sasaki Akemi)', born: 1930, gender: 'Female', phone: '090-5678-9012'),
    manager: ManagerDetail(name: '佐藤 翼 (Sato Tsubasa)', account: 'sato_mgr', contact: '080-3000-0003'),
    devices: [
      InstalledDevice(
        name: '緊急コールシステム',
        serialNumber: 'JP2024G014',
        status: 'ONLINE',
        installer: 'Air Quality Inc.',
        installationDate: DateTime(2024, 9, 1, 11, 0),
      ),
    ],
  ),
  Unit(
    id: 'B2-U15', // IDを追加
    number: '8F-H01',
    status: 'warning',
    lastMotion: 720, // 12時間前
    isAlert: true,
    resident: ResidentDetail(name: '藤原 剛 (Fujiwara Tsuyoshi)', born: 1955, gender: 'Male', phone: '090-6789-0123'),
    manager: ManagerDetail(name: '高橋 恵 (Takahashi Megumi)', account: 'takahashi_mgr', contact: '080-4000-0004'),
    devices: [
      InstalledDevice(
        name: 'ガスメーター監視',
        serialNumber: 'JP2024H015',
        status: 'ONLINE',
        installer: 'Gas Safety Japan',
        installationDate: DateTime(2024, 9, 5, 15, 0),
      ),
    ],
  ),
  Unit(
    id: 'B2-U16', // IDを追加
    number: '8F-H02',
    status: 'normal',
    lastMotion: 1,
    isAlert: false,
    resident: ResidentDetail(name: '野口 奈々 (Noguchi Nana)', born: 1980, gender: 'Female', phone: '090-7890-1234'),
    manager: ManagerDetail(name: '高橋 恵 (Takahashi Megumi)', account: 'takahashi_mgr', contact: '080-4000-0004'),
    devices: [
      InstalledDevice(
        name: 'ドアロックセンサー',
        serialNumber: 'JP2024H016',
        status: 'ONLINE',
        installer: 'Gas Safety Japan',
        installationDate: DateTime(2024, 9, 5, 16, 30),
      ),
    ],
  ),
  Unit(
    id: 'B2-U17', // IDを追加
    number: '9F-I01',
    status: 'offline',
    lastMotion: 0,
    isConnected: false,
    isAlert: false, // 장치 상태는 OFF이지만, 아직 경고로 분류하지 않음
    resident: ResidentDetail(name: '青山 茂 (Aoyama Shigeru)', born: 1945, gender: 'Male', phone: '090-8901-2345'),
    manager: ManagerDetail(name: '田中 浩 (Tanaka Hiroshi)', account: 'tanaka_mgr', contact: '080-9999-0001'),
    devices: [
      InstalledDevice(
        name: 'スマートプラグ',
        serialNumber: 'JP2024I017',
        status: 'OFFLINE',
        installer: 'Eco Power Co.',
        installationDate: DateTime(2024, 9, 10, 14, 0),
      ),
    ],
  ),
];

final List<Unit> units3 = [
  Unit(
    id: 'B3-U01', // IDを追加
    number: '1F-A03',
    status: 'normal',
    lastMotion: 5, // 5分前
    isAlert: false,
    resident: ResidentDetail(name: '森田 徹 (Morita Toru)', born: 1978, gender: 'Male', phone: '090-1230-0001'),
    manager: ManagerDetail(name: '田中 浩 (Tanaka Hiroshi)', account: 'tanaka_mgr', contact: '080-9999-0001'),
    devices: [
      // ... (devices, etc. 保持)
    ],
  ),
  Unit(
    id: 'B3-U02', // IDを追加
    number: '2F-B03',
    status: 'warning',
    lastMotion: 360, // 6時間前
    isAlert: false,
    resident: ResidentDetail(name: '橋本 麗子 (Hashimoto Reiko)', born: 1952, gender: 'Female', phone: '090-4560-0002'),
    manager: ManagerDetail(name: '山田 太郎 (Yamada Taro)', account: 'yamada_mgr', contact: '080-1000-0001'),
    devices: [
      // ... (devices, etc. 保持)
    ],
  ),
  Unit(
    id: 'B3-U03', // IDを追加
    number: '3F-C03',
    status: 'normal',
    lastMotion: 1500, // 25時間前
    isAlert: true,
    resident: ResidentDetail(name: '佐野 和男 (Sano Kazuo)', born: 1938, gender: 'Male', phone: '090-7890-0003'),
    manager: ManagerDetail(name: '小川 美香 (Ogawa Mika)', account: 'ogawa_mgr', contact: '080-2000-0002'),
    devices: [
      // ... (devices, etc. 保持)
    ],
  ),
  Unit(
    id: 'B3-U04', // IDを追加
    number: '4F-D03',
    status: 'offline',
    lastMotion: 0,
    isConnected: false,
    isAlert: true,
    resident: ResidentDetail(name: '西村 郁代 (Nishimura Ikuyo)', born: 1946, gender: 'Female', phone: '090-0120-0004'),
    manager: ManagerDetail(name: '小川 美香 (Ogawa Mika)', account: 'ogawa_mgr', contact: '080-2000-0002'),
    devices: [
      // ... (devices, etc. 保持)
    ],
  ),
  Unit(
    id: 'B3-U05', // IDを追加
    number: '5F-E03',
    status: 'normal',
    lastMotion: 15,
    isAlert: false,
    resident: ResidentDetail(name: '岡本 雅彦 (Okamoto Masahiko)', born: 1965, gender: 'Male', phone: '090-3450-0005'),
    manager: ManagerDetail(name: '佐藤 翼 (Sato Tsubasa)', account: 'sato_mgr', contact: '080-3000-0003'),
    devices: [
      // ... (devices, etc. 保持)
    ],
  ),
  Unit(
    id: 'B3-U06', // IDを追加
    number: '6F-F03',
    status: 'normal',
    lastMotion: 80,
    isAlert: false,
    resident: ResidentDetail(name: '宮崎 結衣 (Miyazaki Yui)', born: 1985, gender: 'Female', phone: '090-6780-0006'),
    manager: ManagerDetail(name: '佐藤 翼 (Sato Tsubasa)', account: 'sato_mgr', contact: '080-3000-0003'),
    devices: [
      // ... (devices, etc. 保持)
    ],
  ),
  Unit(
    id: 'B3-U07', // IDを追加
    number: '7F-G03',
    status: 'warning',
    lastMotion: 600, // 10時間前
    isAlert: true,
    resident: ResidentDetail(name: '久保田 健 (Kubota Ken)', born: 1940, gender: 'Male', phone: '090-9010-0007'),
    manager: ManagerDetail(name: '高橋 恵 (Takahashi Megumi)', account: 'takahashi_mgr', contact: '080-4000-0004'),
    devices: [
      // ... (devices, etc. 保持)
    ],
  ),
  Unit(
    id: 'B3-U08', // IDを追加
    number: '8F-H03',
    status: 'offline',
    lastMotion: 0,
    isConnected: false,
    isAlert: false,
    resident: ResidentDetail(name: '田村 亜矢 (Tamura Aya)', born: 1970, gender: 'Female', phone: '090-2340-0008'),
    manager: ManagerDetail(name: '高橋 恵 (Takahashi Megumi)', account: 'takahashi_mgr', contact: '080-4000-0004'),
    devices: [
      // ... (devices, etc. 保持)
    ],
  ),
];

final List<Unit> units4 = [
  // 1. Normal (Younger Resident)
  Unit(
    id: 'B4-U01', // IDを追加
    number: '101A',
    status: 'normal',
    lastMotion: 10, // 10分前
    isAlert: false,
    resident: ResidentDetail(name: '鈴木 健太 (Suzuki Kenta)', born: 1988, gender: 'Male', phone: '090-1111-0011'),
    manager: ManagerDetail(name: '吉田 明 (Yoshida Akira)', account: 'yoshida_mgr', contact: '080-5000-0001'),
    devices: [
      // ... (devices, etc. 保持)
    ],
  ),
  // 2. Warning (Elderly, Reduced Activity)
  Unit(
    id: 'B4-U02', // IDを追加
    number: '202B',
    status: 'normal',
    lastMotion: 480, // 8時間前
    isAlert: false,
    resident: ResidentDetail(name: '加藤 茂子 (Kato Shigeko)', born: 1945, gender: 'Female', phone: '090-2222-0022'),
    manager: ManagerDetail(name: '吉田 明 (Yoshida Akira)', account: 'yoshida_mgr', contact: '080-5000-0001'),
    devices: [
      // ... (devices, etc. 保持)
    ],
  ),
  // 3. Critical (Long Inactivity)
  Unit(
    id: 'B4-U03', // IDを追加
    number: '303C',
    status: 'normal',
    lastMotion: 2000, // 約 33時間前
    isAlert: true,
    resident: ResidentDetail(name: '伊藤 正夫 (Ito Masao)', born: 1935, gender: 'Male', phone: '090-3333-0033'),
    manager: ManagerDetail(name: '松本 梢 (Matsumoto Kozue)', account: 'matsumoto_mgr', contact: '080-6000-0002'),
    devices: [
      // ... (devices, etc. 保持)
    ],
  ),
  // 4. Offline (Disconnected)
  Unit(
    id: 'B4-U04', // IDを追加
    number: '404D',
    status: 'normal',
    lastMotion: 0,
    isConnected: false,
    isAlert: true,
    resident: ResidentDetail(name: '渡辺 恵美 (Watanabe Emi)', born: 1950, gender: 'Female', phone: '090-4444-0044'),
    manager: ManagerDetail(name: '松本 梢 (Matsumoto Kozue)', account: 'matsumoto_mgr', contact: '080-6000-0002'),
    devices: [
      // ... (devices, etc. 保持)
    ],
  ),
  // 5. Normal (Recent Activity)
  Unit(
    id: 'B4-U05', // IDを追加
    number: '505E',
    status: 'normal',
    lastMotion: 1, // 1分前
    isAlert: false,
    resident: ResidentDetail(name: '高橋 涼子 (Takahashi Ryoko)', born: 1972, gender: 'Female', phone: '090-5555-0055'),
    manager: ManagerDetail(name: '井上 徹 (Inoue Toru)', account: 'inoue_mgr', contact: '080-7000-0003'),
    devices: [
      // ... (devices, etc. 保持)
    ],
  ),
  // 6. Warning (Middle-aged, Sensor Malfunction Simulation)
  Unit(
    id: 'B4-U06', // IDを追加
    number: '606F',
    status: 'normal',
    lastMotion: 15, // 最近活動あり
    isAlert: true, // 活動はあるが、他のセンサーで警告発生仮定
    resident: ResidentDetail(name: '中野 豊 (Nakano Yutaka)', born: 1960, gender: 'Male', phone: '090-6666-0066'),
    manager: ManagerDetail(name: '井上 徹 (Inoue Toru)', account: 'inoue_mgr', contact: '080-7000-0003'),
    devices: [
      // ... (devices, etc. 保持)
    ],
  ),
  // 7. Normal (Elderly, Regular Activity)
  Unit(
    id: 'B4-U07', // IDを追加
    number: '707G',
    status: 'normal',
    lastMotion: 30, // 30分前
    isAlert: false,
    resident: ResidentDetail(name: '林 洋子 (Hayashi Yoko)', born: 1930, gender: 'Female', phone: '090-7777-0077'),
    manager: ManagerDetail(name: '吉田 明 (Yoshida Akira)', account: 'yoshida_mgr', contact: '080-5000-0001'),
    devices: [
      // ... (devices, etc. 保持)
    ],
  ),
];
String _getAlertMessage(Unit unit) {
  if (unit.status == 'critical') {
    return 'Unit ${unit.number}: Critical failure. No motion detected for ${unit.lastMotion ~/ 60} hours.';
  } else if (unit.status == 'warning') {
    return 'Unit ${unit.number}: Prolonged inactivity detected. Last motion was ${unit.lastMotion ~/ 60} hours ago.';
  } else if (unit.status == 'offline') {
    return 'Unit ${unit.number}: Device connection lost. The unit is currently offline.';
  }
  return 'Unit ${unit.number}: Status check completed.';
}

// Unit의 status에 맞는 AlertLevel을 반환하는 헬퍼 함수
AlertLevel _getAlertLevel(String status) {
  switch (status) {
    case 'critical':
      return AlertLevel.critical;
    case 'warning':
      return AlertLevel.warning;
    case 'offline':
      // 오프라인도 Warning 레벨로 처리 (경고/점검 필요)
      return AlertLevel.warning;
    default:
      return AlertLevel.normal;
  }
}

// 유닛 번호를 기반으로 해당 유닛이 속한 Building의 이름을 찾는 헬퍼 함수
String _getLocationByUnitNumber(String unitNumber) {
  for (final building in buildings) {
    if (building.unitList.any((unit) => unit.number == unitNumber)) {
      return building.name;
    }
  }
  // 매칭되는 건물이 없을 경우 기본값 반환 (이 경우에는 발생하지 않아야 함)
  return 'Unknown Location';
}

final Random _random = Random();

final List<AlertData> alertList =
    allUnits
        .where((unit) => unit.status != 'normal') // normal 상태는 경고 목록에서 제외
        .map((unit) {
          final level = _getAlertLevel(unit.status);
          final location = _getLocationByUnitNumber(unit.number);

          return AlertData(
            level: level,
            title: level == AlertLevel.critical ? 'Critical Alert' : (level == AlertLevel.warning ? 'Warning Alert' : 'Alert'),
            // 현재 시간을 경고 발생 시간으로 가정
            time: DateTime.now().toString().substring(0, 16),
            message: _getAlertMessage(unit),
            location: location,
            unit: 'Unit ${unit.number}',
            isNew: _random.nextDouble() < 0.1,
          );
        })
        .toList()
      // 정렬 로직 수정: bool.compareTo 대신 int로 변환하여 정렬
      ..sort((a, b) {
        // 1. a.isNew를 정수(int)로 변환합니다. (true -> 1, false -> 0)
        final int aValue = a.isNew ? 1 : 0;
        // 2. b.isNew를 정수(int)로 변환합니다. (true -> 1, false -> 0)
        final int bValue = b.isNew ? 1 : 0;

        // 3. 내림차순 정렬 (true=1이 앞으로 와야 하므로 bValue와 aValue를 비교)
        // bValue가 크면 (b가 true, a가 false이면) 양수(1)를 반환하여 b가 a보다 앞으로 옵니다.
        return bValue.compareTo(aValue);
      });

class CriticalUnit {
  final String id;
  final String region; // Building의 주소에서 지역 추출
  final Building building; // Building name
  final String unit; // Unit ID
  final String lastMotionTime;
  final String status;

  CriticalUnit({
    required this.id,
    required this.region,
    required this.building,
    required this.unit,
    required this.lastMotionTime,
    required this.status,
  });
}

class UnitModel {
  final String unitId;
  final String status;
  final String lastMotionTime;
  final String buildingName;

  UnitModel({required this.unitId, required this.status, required this.lastMotionTime, required this.buildingName});
}

String extractRegion(String address) {
  final parts = address.split(' ');
  if (parts.length >= 3) {
    return '${parts[1]} ${parts[2]}';
  }
  return parts.length > 1 ? parts[1] : address;
}

final List<CriticalUnit> dummyCriticalUnits =
    buildings
        .expand(
          (building) => building.unitList.where((unit) => unit.status == 'critical').map((unit) {
            final region = extractRegion(building.address);
            return CriticalUnit(
              id: unit.id,
              region: region,
              building: building,
              unit: unit.number,
              lastMotionTime: formatMinutesToTimeAgo(unit.lastMotion),
              status: unit.status,
            );
          }),
        )
        .toList();

final List<CriticalUnit> dummyWarningUnits =
    buildings
        .expand(
          (building) => building.unitList.where((unit) => unit.status == 'warning').map((unit) {
            final region = extractRegion(building.address);
            return CriticalUnit(
              id: unit.id,
              region: region,
              building: building,
              unit: unit.number,
              lastMotionTime: formatMinutesToTimeAgo(unit.lastMotion),
              status: unit.status,
            );
          }),
        )
        .toList();

Unit? findMatchingUnitClassic(CriticalUnit criticalData) {
  for (final building in buildings) {
    if (building.name == criticalData.building) {
      // 명시적인 내부 루프를 사용하여 Unit을 찾습니다.
      for (final unit in building.unitList) {
        if (unit.number == criticalData.unit) {
          return unit; // 찾으면 즉시 반환
        }
      }
      // 해당 building에서 Unit을 찾지 못했다면 다음 building으로 넘어갑니다.
    }
  }
  return null; // 모든 building에서 찾지 못하면 null 반환
}

final List<Device> allGlobalDevicesList = buildings
// 1차 expand: Building 리스트를 Unit 리스트로 변환
    .expand((building) {
  // 각 Building의 정보를 devices 리스트에 전달하기 위해 map/expand를 중첩합니다.
  return building.unitList.expand((unit) {
    // 2차 expand/map: Unit 리스트를 InstalledDevice 리스트로 변환
    return unit.devices.map((device) {
      // 최종적으로 EnrichedDevice 객체 생성
      return Device(
        buildingName: building.name, // Building 정보 (외부 루프에서 가져옴)
        unitNumber: unit.number,       // Unit 정보 (중간 루프에서 가져옴)
        residentName: unit.resident.name, // <--- Unit에서 거주자 이름 추출
        // InstalledDevice 의 정보 복사
        name: device.name,
        serialNumber: device.serialNumber,
        status: device.status,
        installer: device.installer,
        installationDate: device.installationDate,
      );
    });
  });
})
    .toList(); // 최종 리스트로 변환


final List<ManagerDetail> allManagersWithDuplicates = allUnits
    .map((unit) => unit.manager)
    .toList();

// 2. toSet()을 사용하여 중복 제거 (수정된 operator ==와 hashCode 사용)
// 이제 name, account, contact가 같으면 하나만 남깁니다.
final Set<ManagerDetail> uniqueManagersSet = allManagersWithDuplicates.toSet();

// 3. 다시 List로 변환
final List<ManagerDetail> uniqueManagersList = uniqueManagersSet.toList();

// uniqueManagersList: [ManagerDetail(김철수), ManagerDetail(이영희)]