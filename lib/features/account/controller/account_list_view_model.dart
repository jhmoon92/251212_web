import 'package:moni_pod_web/features/auth/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/provider/sensing/account_resp.dart';


part 'account_list_view_model.g.dart';

@riverpod
class AccountListViewModel extends _$AccountListViewModel {
  @override
  Future<UserListResponse> build() async {
    return _fetchData();
  }

  Future<UserListResponse> _fetchData() async {
    try {
      UserListResponse data = await ref.watch(authRepositoryProvider).getAccountList();
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchData() async {
    state = const AsyncValue.loading();
    try {
      final res = await _fetchData();
      state = AsyncData(res);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }

}
