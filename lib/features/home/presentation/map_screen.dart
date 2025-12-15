import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
// import 'package:moni_pod_web/config/style.dart'; // 프로젝트에 따라 주석 처리 또는 유지

// ⭐ Google Maps API 키 (index.html 및 코드 내에 사용됨)
const String googleApiKey = 'AIzaSyBUc2bj_VUyH-kmgsFJxDgT4OXBUQBp2O0';

// ---------------------------------------------------------------------------
// 지도 스타일 JSON (길, POI, 지역명 숨기기)
// 이 코드를 통해 지도 위에 불필요한 길이나 지역명 라벨이 사라집니다.
const String _mapStyleJson = '''
[
  {
    "featureType": "road",
    "stylers": [
      {"visibility": "off"}
    ]
  },
  {
    "featureType": "poi",
    "stylers": [
      {"visibility": "off"}
    ]
  },
  {
    "featureType": "administrative",
    "stylers": [
      {"visibility": "off"}
    ]
  },
  {
    "featureType": "transit.line", 
    "stylers": [
      {"visibility": "off"}
    ]
  }
]
''';
// ---------------------------------------------------------------------------


class GoogleMapSearchScreen extends StatefulWidget {
  const GoogleMapSearchScreen({super.key});

  @override
  State<GoogleMapSearchScreen> createState() => _GoogleMapSearchScreenState();
}

class _GoogleMapSearchScreenState extends State<GoogleMapSearchScreen> {
  // 지도 컨트롤러
  final Completer<GoogleMapController> _controller = Completer();

  // 1. 고정 위치 정의 (3개 위치)
  // 일본 법인 VORT Bldg Ⅲ (타이토구 야나기바시)
  static const LatLng _vortBuilding = LatLng(35.69617387432273, 139.78578119923532);
  // 도쿄 타워 (미나토구 시바코엔)
  static const LatLng _tokyoTower = LatLng(35.658581, 139.745433);
  // 아자부다이힐스 모리 JP 타워 (미나토구 아자부다이)
  static const LatLng _azabudaiHills = LatLng(35.660922, 139.740776);
  // 고정 마커 위치 리스트 (Bounds 계산용)
  final List<LatLng> _fixedMarkerPositions = const [
    _vortBuilding,
    _tokyoTower,
    _azabudaiHills,
  ];

  // 지도 초기 위치 (도쿄 중심)
  static const CameraPosition _kInitialPosition = CameraPosition(target: LatLng(35.67, 139.75), zoom: 12.0);

  // 마커 관리 (고정 마커와 검색 마커를 모두 포함)
  Set<Marker> _markers = {};

  // 검색 관련 상태
  final TextEditingController _searchController = TextEditingController();
  List<PlacePrediction> _placePredictions = [];
  Timer? _debounce;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 고정 마커 초기화
    _markers = _createFixedMarkers();

    // 지도가 렌더링 된 후 경계를 계산하여 카메라 이동
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fitFixedBounds();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  // -------------------------------------------------------------------------
  // [C. 마커 생성 및 경계 설정]
  // -------------------------------------------------------------------------

  // 고정 마커 세트 생성 함수
  Set<Marker> _createFixedMarkers() {
    return {
      Marker(
        markerId: const MarkerId('vort_building'),
        position: _vortBuilding,
        infoWindow: const InfoWindow(title: 'VORT Building'),
      ),
      Marker(
        markerId: const MarkerId('tokyo_tower'),
        position: _tokyoTower,
        infoWindow: const InfoWindow(title: 'Tokyo Tower'),
      ),
      Marker(
        markerId: const MarkerId('azabudai_hills'),
        position: _azabudaiHills,
        infoWindow: const InfoWindow(title: 'Azabudai Hills Mori JP Tower'),
      ),
    };
  }

  // 세 마커의 경계에 맞춰 카메라를 이동시키는 함수
  Future<void> _fitFixedBounds() async {
    final GoogleMapController controller = await _controller.future;

    if (_fixedMarkerPositions.length < 2) return;

    double minLat = _fixedMarkerPositions[0].latitude;
    double maxLat = _fixedMarkerPositions[0].latitude;
    double minLng = _fixedMarkerPositions[0].longitude;
    double maxLng = _fixedMarkerPositions[0].longitude;

    // 3개 지점의 경계 계산
    for (var pos in _fixedMarkerPositions) {
      minLat = pos.latitude < minLat ? pos.latitude : minLat;
      maxLat = pos.latitude > maxLat ? pos.latitude : maxLat;
      minLng = pos.longitude < minLng ? pos.longitude : minLng;
      maxLng = pos.longitude > maxLng ? pos.longitude : maxLng;
    }

    final LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    // 카메라를 계산된 경계에 맞게 애니메이션 처리합니다. (50은 경계 패딩 값)
    await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  // -------------------------------------------------------------------------
  // [로직 1] 주소 검색 (Auto Complete) - 기존 로직 유지
  // -------------------------------------------------------------------------
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        setState(() => _placePredictions = []);
        return;
      }

      setState(() => _isLoading = true);

      try {
        final String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$googleApiKey&language=ko';
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['status'] == 'OK') {
            setState(() {
              _placePredictions = (data['predictions'] as List).map((item) => PlacePrediction.fromJson(item)).toList();
            });
          } else {
            print('Places API Error: ${data['status']}');
            if (data['error_message'] != null) print(data['error_message']);
          }
        }
      } catch (e) {
        print('Network Error: $e');
      } finally {
        setState(() => _isLoading = false);
      }
    });
  }

  // -------------------------------------------------------------------------
  // [로직 2] 장소 선택 및 이동 (Place Details) - 고정 마커 유지 로직 추가
  // -------------------------------------------------------------------------
  Future<void> _onSuggestionTap(PlacePrediction place) async {
    setState(() {
      _searchController.text = place.description;
      _placePredictions = []; // 리스트 닫기
    });

    final String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=${place.placeId}&key=$googleApiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final location = data['result']['geometry']['location'];
          final lat = location['lat'];
          final lng = location['lng'];

          final targetLatLng = LatLng(lat, lng);

          // 1. 지도 이동
          final GoogleMapController controller = await _controller.future;
          controller.animateCamera(CameraUpdate.newLatLngZoom(targetLatLng, 17));

          // 2. 마커 찍기: 고정 마커 유지 + 검색 마커 추가
          setState(() {
            _markers = _createFixedMarkers(); // 고정 마커를 다시 로드
            _markers.add(
              Marker(
                  markerId: const MarkerId('selected_place'),
                  position: targetLatLng,
                  infoWindow: InfoWindow(title: place.description)
              ),
            );
          });
        }
      }
    } catch (e) {
      print('Details API Error: $e');
    }
  }

  // -------------------------------------------------------------------------
  // [D. build Widget]
  // -------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    // 웹에서는 Column이나 Row 안에 Map을 넣을 때 크기 제약이 중요합니다.
    return Stack(
      children: [
        // 1. 구글 지도 (배경)
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kInitialPosition,
          markers: _markers,
          style: _mapStyleJson,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          // 웹 제스처 대응 (줌, 팬 등)
          webGestureHandling: WebGestureHandling.cooperative,
        ),

        // // 2. 검색창 (상단 플로팅)
        // Positioned(
        //   top: 40,
        //   left: 20,
        //   right: 20,
        //   child: Center(
        //     child: ConstrainedBox(
        //       constraints: const BoxConstraints(maxWidth: 600), // 최대 너비 600px 제한
        //       child: Column(children: [_buildSearchBar(), if (_placePredictions.isNotEmpty) _buildPredictionList()]),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 2))],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        mouseCursor: SystemMouseCursors.text,
        // style: TextStyle(color: commonBlack),
        decoration: InputDecoration(
          hintText: '주소를 검색하세요',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon:
          _isLoading
              ? const SizedBox(width: 20, height: 20, child: Center(child: CircularProgressIndicator(strokeWidth: 2)))
              : IconButton(
            icon: const Icon(Icons.clear, color: Colors.black),
            onPressed: () {
              _searchController.clear();
              setState(() {
                _placePredictions = [];
                _markers = _createFixedMarkers(); // 검색창 클리어 시 고정 마커만 남김
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPredictionList() {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      constraints: const BoxConstraints(maxHeight: 300),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: _placePredictions.length,
        separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.grey),
        itemBuilder: (context, index) {
          final place = _placePredictions[index];
          return ListTile(
            leading: const Icon(Icons.location_on, color: Colors.blueGrey),
            title: Text(place.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14)),
            onTap: () => _onSuggestionTap(place),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// [모델] Place API 응답 파싱용 클래스
// ---------------------------------------------------------------------------
class PlacePrediction {
  final String description;
  final String placeId;

  PlacePrediction({required this.description, required this.placeId});

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    return PlacePrediction(description: json['description'] ?? '', placeId: json['place_id'] ?? '');
  }
}