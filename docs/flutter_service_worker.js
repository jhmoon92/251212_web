'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "e6539926e065a6970adde97451b3c0ee",
"assets/AssetManifest.bin.json": "45a23fa9aa79f65776147dd56e55a803",
"assets/AssetManifest.json": "c50b1bea1a7667d8f17deadd18dcd001",
"assets/assets/development.config.json": "490308f74cb99650f69fab0a8fcc5401",
"assets/assets/images/ic_16_attach.svg": "d7dd510621127b131ba59669e796bbf2",
"assets/assets/images/ic_16_delete.svg": "4953e35dc6d430d76dc698adb19700b8",
"assets/assets/images/ic_16_download.svg": "376a59a5d7dffe3f2d20fca86174a498",
"assets/assets/images/ic_16_edit.svg": "65650cf7e2f39dbd2874bc436b4af09b",
"assets/assets/images/ic_16_search.svg": "74d70b916ec91e300e3104a21041c933",
"assets/assets/images/ic_24_3dots.svg": "48ae3aa1ef3709f5a71e22dc99e9efc0",
"assets/assets/images/ic_24_add.svg": "d3aff679a4fdfed322eddcf30a454e7c",
"assets/assets/images/ic_24_alert.svg": "61a0fdbb968e1d2410fe0cefaf2ef37d",
"assets/assets/images/ic_24_call.svg": "3d082ef87e484aedece08dbc843a8731",
"assets/assets/images/ic_24_cancel.svg": "fa29039c00e5742886162192f832d128",
"assets/assets/images/ic_24_check.svg": "06beece71761d876df250a6619cf8283",
"assets/assets/images/ic_24_download.svg": "b6a63da4a78ce689fe75ace026cfc65e",
"assets/assets/images/ic_24_edit.svg": "47975e2a044b01dbf3f10fe4541cb7bf",
"assets/assets/images/ic_24_home.svg": "27d058651b7b0704e9af640d8c02b4a1",
"assets/assets/images/ic_24_info.svg": "7acb2a1437d49e6c367386e4c0b3d432",
"assets/assets/images/ic_24_location.svg": "7b5b1d68698e23a4b651d83e29e0f9c8",
"assets/assets/images/ic_24_log.svg": "c8068480615c41df4de85f01e1b23fcd",
"assets/assets/images/ic_24_logout.svg": "d34052cec5976c7bd1fed0859aeacdd0",
"assets/assets/images/ic_24_mail.svg": "d3293957274492e9d0117d4670db7e0d",
"assets/assets/images/ic_24_motion.svg": "d61d0d07cd0faf7ff8296eddf4b366d1",
"assets/assets/images/ic_24_office.svg": "d43d88ec741d507bb772753acfef0e45",
"assets/assets/images/ic_24_people.svg": "a954932875080809e1b2a757f20996bd",
"assets/assets/images/ic_24_person.svg": "6b46fc9817c10d9a58e86e59ba2d39f3",
"assets/assets/images/ic_24_pod.svg": "1461940f931b10f90e36e5849f7f2793",
"assets/assets/images/ic_24_previous.svg": "9cf768ea140cf8ffddd42216d68512da",
"assets/assets/images/ic_24_radio_off.svg": "f8ddb25d49390b543e9aa03f5a28333a",
"assets/assets/images/ic_24_radio_on.svg": "9e7c9a969d814084719d3dd7447530c6",
"assets/assets/images/ic_24_reload.svg": "2b7017d4f0748d2b15c0f0ddbf20f8dd",
"assets/assets/images/ic_24_time.svg": "5737c4146bddbf043ef5fbcb7803fceb",
"assets/assets/images/ic_24_unit.svg": "0c43136fd4d597121368162971a2f51c",
"assets/assets/images/ic_24_upload.svg": "4ddac8000bd667eb7f2a33b2f4821e3b",
"assets/assets/images/ic_32_call.svg": "231be24f0085be62ea9061fd09a97fd1",
"assets/assets/images/ic_32_circle_cancel.svg": "1bb5792484840aa036f66d18564d492d",
"assets/assets/images/ic_32_circle_check_checked.svg": "eb0d82c10c19170b263b34217a5be81f",
"assets/assets/images/ic_32_critical.svg": "3bdd4c7907c641579d9ed49daca12db2",
"assets/assets/images/ic_32_eye.svg": "bf725673f11baa173798315a7205e0c6",
"assets/assets/images/ic_32_eye_off.svg": "fe648908639242009c3a68660f19f499",
"assets/assets/images/ic_32_warning.svg": "9f86e6e10efbdfe7926ee27b14a98554",
"assets/assets/images/ic_48_wi-fi.svg": "48b8f73841a2949059f9b85d249cadb4",
"assets/assets/images/ic_48_wi-fi_error.svg": "9ce20eea1ddd1e074bdf0e13224a8f80",
"assets/assets/images/img_80_building.svg": "8afd741c302ee6af6edbf6e462a37d0e",
"assets/assets/images/img_bg_building.jpg": "3569bbd39b8d1a6f76cd25aadf0b2150",
"assets/assets/images/img_bg_building.PNG": "3e742cce55308a96e4fdb7a205e9bff2",
"assets/assets/images/img_bg_building2.JPG": "89aca5e75acc39787f4411899e838733",
"assets/assets/images/img_default_building.png": "8b7f5091722d461f64a830162c06d89e",
"assets/assets/images/img_logo_moni_resipass.svg": "4780b04ec2a61aec4e7cfa72748d92c3",
"assets/assets/images/img_logo_s_moni_resipass.svg": "7349cc0f3d0340f26335224c59f1e064",
"assets/assets/images/Moni_logo_signiture.svg": "694192f30ec4ff316e5608ab756a8d58",
"assets/assets/images/Moni_top_logo_signiture.svg": "4b5497a497322f8b39c956f19ebfbbe4",
"assets/assets/lotti/add_place_not_found.json": "93c7d3d934f4c80e58a46e17d7eac83d",
"assets/assets/lotti/connecting_monipod.json": "b92ea2ba4ab4ddf36864a9b4a4ecbe2d",
"assets/assets/lotti/find_moni_pod.json": "f0db87ddd120b2e39559d0970b277d86",
"assets/assets/lotti/graphical_loading.json": "30ba27b0f99ffe8e773f1b46fc145769",
"assets/assets/lotti/loading.json": "1e576825017148e2b47e06d7634dbb5a",
"assets/assets/lotti/loading_dots.json": "5b4e248161d9f1903fefab69ebaf7d97",
"assets/assets/lotti/Moni_2.5_Home_Day.json": "b3d8e39df615bc75b11be9619595369d",
"assets/assets/lotti/Moni_2.5_Home_Night.json": "bf9eed46a50b48f96e6711854a3d72a4",
"assets/assets/lotti/moni_link_icon.json": "5c6f0c5c399667ef89e5d667761f214e",
"assets/assets/lotti/moni_place_introduce_illust_1.json": "5c6f0c5c399667ef89e5d667761f214e",
"assets/assets/lotti/moni_place_introduce_illust_2.json": "4353080af7817100c02c157517a159fa",
"assets/assets/lotti/moni_place_introduce_illust_3.json": "795c130ba025948fd091654febb9c934",
"assets/assets/lotti/Moni_Pod_Color_LED_Blue.json": "ed6ac225a7193be90505e2ca52a26bdf",
"assets/assets/lotti/Moni_Pod_Color_LED_RED.json": "ac458ef02dc1b6a22e99f76514ae62a7",
"assets/assets/lotti/Moni_Pod_LED_Blue_MAX.json": "7286b7833caf3a8d4fed6897cff55df3",
"assets/assets/lotti/Moni_Pod_LED_Red_MAX.json": "409b27cce03e7426df0f6b74b51b29f1",
"assets/assets/lotti/Moni_Pod_LED_White_High.json": "d2bc4a1d103cdf437c99fc8d91439aad",
"assets/assets/lotti/Moni_Pod_LED_White_Low.json": "ae30e2a7b57a92626d90771b4b44187a",
"assets/assets/lotti/Moni_Pod_LED_White_Mid.json": "e1a7ce9706efd4992291238eadb116e5",
"assets/assets/lotti/Moni_Pod_Network_Scanning.json": "27cba0ad1ca197173a6886bb94896b2b",
"assets/assets/lotti/moni_pod_wps_button.json": "325a6855551f93b08f537c42d83bf250",
"assets/assets/lotti/moni_router_wps_button.json": "1293e180b4839687d635c18fadde1264",
"assets/assets/lotti/moni_wps_button.json": "1293e180b4839687d635c18fadde1264",
"assets/assets/lotti/moni_wps_button_2.json": "a48d1e3cfbbed2dfd22c05f98c012cbb",
"assets/assets/lotti/motion_detected.json": "00e8338dc9bdb63451b894ffacdf0270",
"assets/assets/lotti/near_by_router.json": "90ec561b123bf4655bd1258bc73bbcb6",
"assets/assets/lotti/pairing_monipod.json": "97c1164df28c9a71c6eba169dfe9f924",
"assets/assets/lotti/pod_connecting_sucess_or_fail.json": "82fe4959d6cf8f15034f65e9d4facd8e",
"assets/assets/lotti/qr_code_scan.json": "c6736b9a965fb5f6d4c18ea3f5dca4a7",
"assets/assets/lotti/refresh_icon.json": "2314fdea0de097967ffec22b3ad64264",
"assets/assets/lotti/report_read.json": "5a682bab8bb0b1513fbd152dc093b45b",
"assets/assets/lotti/router_connecting.json": "192b5589982f041e67d08bb257dbee72",
"assets/assets/lotti/searching_for_network.json": "d8806e7f2bd0d3a084e8b4b89cae1bc8",
"assets/assets/lotti/searching_monipod.json": "074469c89acfeb0f14d355102837933b",
"assets/assets/lotti/sensing_bottom.json": "7336d035f335df370197e7e746654d7b",
"assets/assets/lotti/Sensitivity_Customed_Yellow.json": "81068b4cad8e4f9f549385c30eadd2e3",
"assets/assets/lotti/Sensitivity_High_Seat_Black.json": "49ed12de062687e815886e33871f44e0",
"assets/assets/lotti/Sensitivity_High_Seat_Yellow.json": "6257260822ff4f0c429306008c207cd6",
"assets/assets/lotti/Sensitivity_Low_Dance_Black.json": "2d2fb216aeb0a6cab37f008e2c67a4d7",
"assets/assets/lotti/Sensitivity_Low_Dance_Yellow.json": "15139416a54efab67388914cc83ab0dc",
"assets/assets/lotti/Sensitivity_Middle_Walk_Black.json": "fac408a31f96daa77ce6385009d3db71",
"assets/assets/lotti/Sensitivity_Middle_Walk_Yellow.json": "251d1f2596c9779ea0a8aa414865ebb8",
"assets/assets/prod.config.json": "3ccdc22d9fa4d3225b960f851bc35fe5",
"assets/assets/strings/en.json": "43cbdd01efc71f56ce42c1e3225cafbf",
"assets/assets/strings/ja.json": "b2ca02db583375d82646c43b4058b14a",
"assets/assets/strings/ko.json": "5d25965c549b3cc739971891d6fb90fc",
"assets/assets/strings/th.json": "757f0526cab569ff454c092d647d9320",
"assets/assets/strings/timezone_en.json": "8ce4da3016e20d466ffafe92ca1d7023",
"assets/assets/strings/timezone_ko.json": "707653cc258d11f5850b03bacad8d76f",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "907b3a9d4acf861cf2590d56d68bad85",
"assets/NOTICES": "ca70a49bf275e23284b69d37244cbc2c",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "8c473bc4cfba2d211ec02e5a9a14b10e",
"flutter_config.yaml": "cff56e77686a5edda9f7dd78eb3a468a",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "8da8a3705a44a937ec8648840c4d13de",
"/": "8da8a3705a44a937ec8648840c4d13de",
"main.dart.js": "31c3f640824dc5e952fbd485a77db403",
"manifest.json": "f603182fd52752c8a3e8db7ab7c277e0",
"version.json": "1b1bee02854ff6db9f6ec436f71682d9"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
