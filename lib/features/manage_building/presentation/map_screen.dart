import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:moni_pod_web/config/style.dart';

const String googleApiKey = 'AIzaSyBUc2bj_VUyH-kmgsFJxDgT4OXBUQBp2O0';

class GoogleMapSearchScreen extends StatefulWidget {
  const GoogleMapSearchScreen({super.key});

  @override
  State<GoogleMapSearchScreen> createState() => _GoogleMapSearchScreenState();
}

class _GoogleMapSearchScreenState extends State<GoogleMapSearchScreen> {
  // 지도 컨트롤러
  final Completer<GoogleMapController> _controller = Completer();

  // 지도 초기 위치 (서울 시청)
  static const CameraPosition _kInitialPosition = CameraPosition(target: LatLng(37.5665, 126.9780), zoom: 14.4746);

  // 마커 관리
  Set<Marker> _markers = {};

  // 검색 관련 상태
  final TextEditingController _searchController = TextEditingController();
  List<PlacePrediction> _placePredictions = [];
  Timer? _debounce;
  bool _isLoading = false;

  // -------------------------------------------------------------------------
  // [로직 1] 주소 검색 (Auto Complete)
  // 사용자가 입력할 때마다 Google Places API를 호출합니다.
  // -------------------------------------------------------------------------
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // API 호출 낭비를 막기 위해 0.5초 대기 후 호출 (Debounce)
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        setState(() => _placePredictions = []);
        return;
      }

      setState(() => _isLoading = true);

      try {
        // Web에서는 CORS 문제로 인해 이 직접 호출이 실패할 수 있습니다.
        // 실제 프로덕션에서는 백엔드 서버를 통해 호출하는 것을 권장합니다.
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
            // 에러 메시지 표시 (CORS 등)
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
  // [로직 2] 장소 선택 및 이동 (Place Details)
  // 목록에서 선택한 장소의 place_id로 위도/경도를 조회합니다.
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
          // 웹에서는 지도 이동 시 부드러운 애니메이션 효과를 위해 animateCamera를 사용합니다.
          controller.animateCamera(CameraUpdate.newLatLngZoom(targetLatLng, 17));

          // 2. 마커 찍기
          setState(() {
            _markers = {
              Marker(markerId: const MarkerId('selected_place'), position: targetLatLng, infoWindow: InfoWindow(title: place.description)),
            };
          });
        }
      }
    } catch (e) {
      print('Details API Error: $e');
    }
  }

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
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          // 웹 제스처 대응 (줌, 팬 등)
          // webGestureHandling은 웹 전용 설정으로, 지도의 제스처 방식을 지정합니다.
          // cooperative는 지도와 웹페이지 스크롤이 협력하도록 설정합니다.
          webGestureHandling: WebGestureHandling.cooperative,
        ),

        // 2. 검색창 (상단 플로팅)
        Positioned(
          top: 40,
          // 웹의 넓은 화면을 고려하여 최대 너비를 제한할 수 있습니다.
          // 여기서는 중앙 정렬을 위해 좌우 여백을 주었습니다.
          left: 20,
          right: 20,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600), // 최대 너비 600px 제한 (웹 친화적)
              child: Column(children: [_buildSearchBar(), if (_placePredictions.isNotEmpty) _buildPredictionList()]),
            ),
          ),
        ),
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
        // 웹 사용자를 위해 마우스 커서를 텍스트 입력 커서로 변경
        mouseCursor: SystemMouseCursors.text,
        style: TextStyle(color: commonBlack),
        decoration: InputDecoration(
          hintText: '주소를 검색하세요',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon:
              _isLoading
                  ? const SizedBox(width: 20, height: 20, child: Center(child: CircularProgressIndicator(strokeWidth: 2)))
                  : IconButton(
                    icon: const Icon(Icons.clear, color: commonBlack),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _placePredictions = []);
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
      // 리스트 길이 제한 (웹 화면 가림 방지)
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
            // 마우스 호버 효과를 위해 InkWell 사용 (웹 친화적)
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
