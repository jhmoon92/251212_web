import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  // 1. 주요 위치 정의 (휴맥스 빌리지, 63빌딩)
  // 휴맥스 빌리지 (경기도 성남시 분당구 수내동) 근사 좌표
  static const LatLng _humaxVillage = LatLng(37.3784792, 127.1127908);
  // 63 빌딩 (서울 영등포구 여의도동) 좌표
  static const LatLng _sixtyThreeBuilding = LatLng(37.5196568, 126.9399392);
// 마커 위치 리스트
  final List<LatLng> _markerPositions = [
    _humaxVillage,
    _sixtyThreeBuilding,
  ];

  // 2. 마커 세트 생성 (build 시점에 _markerPositions를 사용하여 생성)
  Set<Marker> _createMarkers() {
    return {
      Marker(
        markerId: const MarkerId('humax_village'),
        position: _humaxVillage,
        infoWindow: const InfoWindow(title: '휴맥스 빌리지'),
      ),
      Marker(
        markerId: const MarkerId('sixty_three_building'),
        position: _sixtyThreeBuilding,
        infoWindow: const InfoWindow(title: '63 빌딩'),
      ),
    };
  }

  // 3. 모든 마커를 포함하도록 카메라를 조정하는 함수 (핵심 로직)
  Future<void> _fitBounds() async {
    if (_markerPositions.isEmpty) return;

    // GoogleMapController 객체를 가져옵니다.
    final GoogleMapController controller = await _controller.future;

    // LatLngBounds 계산: 모든 좌표를 포함하는 경계 찾기
    double minLat = _markerPositions[0].latitude;
    double maxLat = _markerPositions[0].latitude;
    double minLng = _markerPositions[0].longitude;
    double maxLng = _markerPositions[0].longitude;

    for (var pos in _markerPositions) {
      minLat = pos.latitude < minLat ? pos.latitude : minLat;
      maxLat = pos.latitude > maxLat ? pos.latitude : maxLat;
      minLng = pos.longitude < minLng ? pos.longitude : minLng;
      maxLng = pos.longitude > maxLng ? pos.longitude : maxLng;
    }

    // 계산된 경계를 LatLngBounds 객체로 만듭니다.
    final LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng), // 좌측 하단 (최소 위도, 최소 경도)
      northeast: LatLng(maxLat, maxLng), // 우측 상단 (최대 위도, 최대 경도)
    );

    // 카메라를 계산된 경계에 맞게 애니메이션 처리합니다.
    await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50)); // 50은 경계 패딩 값
  }

  // 4. 초기 카메라 위치 (지도가 로드될 때까지의 임시 위치)
  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(37.5665, 126.9780), // 서울 시청 (초기 로딩 시의 임시 중심점)
    zoom: 10.0,
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kInitialPosition, // 임시 초기 위치 사용
        markers: _createMarkers(), // 마커 세트 사용
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          // 🚩 지도가 생성된 후, 즉시 모든 마커를 포함하도록 카메라를 조정합니다.
          _fitBounds();
        },
      ),
    );
  }
}