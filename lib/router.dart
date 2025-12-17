// lib/router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moni_pod_web/features/alert/presentation/alert_screen.dart';
import 'package:moni_pod_web/features/manage_building/presentation/manage_building_screen.dart';

import 'features/admin_member/presentation/admin_members_screen.dart';
import 'features/auth/presentation/signin_screen.dart';
import 'features/home/presentation/base_screen.dart';
// import 'features/home/presentation/home_screen.dart';
import 'features/home/presentation/home_screen_column.dart';
import 'features/manage_building/domain/unit_model.dart';
import 'features/manage_building/presentation/building_detail_screen.dart';
import 'features/manage_building/presentation/unit_detail_screen.dart';
import 'features/pod_assets/presentation/moni_pod_assets_screen.dart';

enum AppRoute { signIn, home, alerts, manageBuilding, buildingDetail, unitDetail, assets, members }

extension AppRouteExtension on AppRoute {
  String get path {
    switch (this) {
      case AppRoute.signIn:
        return "/signIn";
      case AppRoute.home:
        return "/home";
      case AppRoute.alerts:
        return '/alerts';
      case AppRoute.manageBuilding:
        return '/manageBuilding';
      case AppRoute.buildingDetail:
        return ':buildingId';
      case AppRoute.unitDetail:
        return 'unitDetail/:unitId';
      case AppRoute.assets:
        return '/assets';
      case AppRoute.members:
        return '/members';
    }
  }
}

Building? findBuildingById(String id) {
  try {
    return buildings.firstWhere((b) => b.id == id);
  } catch (e) {
    return null;
  }
}

Unit? findUnitById(String buildingId, String unitId) {
  final building = findBuildingById(buildingId);
  if (building == null) return null;
  try {
    return building.unitList.firstWhere((u) => u.id == unitId);
  } catch (e) {
    return null;
  }
}

final GoRouter router = GoRouter(
  initialLocation: "/signIn",
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) => AppRoute.signIn.path,
    ),
    GoRoute(
      path: AppRoute.signIn.path,
      name: AppRoute.signIn.name,
      pageBuilder: (context, state) {
        return NoTransitionPage(key: state.pageKey, name: AppRoute.signIn.name, child: SignInScreen(apiBaseUrl: ''));
      },
    ),
    ShellRoute(
      builder: (context, state, child) {
        return BaseScreen(child: child);
      },
      routes: [
        GoRoute(
          path: AppRoute.home.path,
          name: AppRoute.home.name,
          pageBuilder: (context, state) {
            return NoTransitionPage(key: state.pageKey, name: AppRoute.home.name, child: HomeScreen());
          },
        ),
        GoRoute(
          path: AppRoute.alerts.path,
          name: AppRoute.alerts.name,
          pageBuilder: (context, state) {
            return NoTransitionPage(key: state.pageKey, name: AppRoute.alerts.name, child: AlertScreen());
          },
        ),
        GoRoute(
          path: AppRoute.manageBuilding.path,
          name: AppRoute.manageBuilding.name,
          pageBuilder: (context, state) {
            return NoTransitionPage(key: state.pageKey, name: AppRoute.manageBuilding.name, child: ManageBuildingScreen());
          },
          routes: [
            GoRoute(
              path: AppRoute.buildingDetail.path,
              name: AppRoute.buildingDetail.name,
              pageBuilder: (context, state) {
                // ID를 이용해 Building 객체 조회
                final buildingId = state.pathParameters['buildingId']!;
                final building = findBuildingById(buildingId);

                if (building == null) {
                  return NoTransitionPage(key: state.pageKey, child: const Center(child: Text('Building not found')));
                }

                return NoTransitionPage(
                  key: state.pageKey,
                  name: AppRoute.buildingDetail.name,
                  child: BuildingDetailScreen(building: building), // Building 객체 전달
                );
              },
              routes: [
                GoRoute(
                  path: AppRoute.unitDetail.path,
                  name: AppRoute.unitDetail.name,
                  pageBuilder: (context, state) {
                    // Building ID와 Unit ID를 이용해 Unit 객체 조회
                    final buildingId = state.pathParameters['buildingId']!;
                    final unitId = state.pathParameters['unitId']!;
                    final unit = findUnitById(buildingId, unitId);
                    final building = findBuildingById(buildingId);


                    if (unit == null) {
                      return NoTransitionPage(key: state.pageKey, child: const Center(child: Text('Unit not found')));
                    }

                    if (building == null) {
                      return NoTransitionPage(key: state.pageKey, child: const Center(child: Text('Building not found')));
                    }

                    return NoTransitionPage(
                      key: state.pageKey,
                      name: AppRoute.unitDetail.name,
                      child: UnitDetailScreen(unitInfo: unit, building: building), // Unit 객체 전달
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: AppRoute.assets.path,
          name: AppRoute.assets.name,
          pageBuilder: (context, state) {
            return NoTransitionPage(key: state.pageKey, name: AppRoute.assets.name, child: MoniPodAssetsScreen());
          },
        ),
        GoRoute(
          path: AppRoute.members.path,
          name: AppRoute.members.name,
          pageBuilder: (context, state) {
            return NoTransitionPage(key: state.pageKey, name: AppRoute.members.name, child: AdminMembersScreen());
          },
        ),
      ],
    ),
  ],
);
