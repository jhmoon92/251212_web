import '../../../features/setting/data/app_config_repository.dart';
import '../provider_base.dart';
import 'account_resp.dart';
import 'auth_client.dart';

class SensingApi {
  final Map _apis = {};

  Map get apis => _apis;
  BaseApi client = BaseApi(AppConfigRepository.instance.serverUrl);
  // BaseApi client = BaseApi(AppConfigRepository.instance.configServerUrl);

  static final SensingApi instance = SensingApi();

  void setApi(ApiType type, ClientProvider api) => _apis[type.index] = api;

  SensingApi() {
    BaseApi tmp = BaseApi(AppConfigRepository.instance.serverUrl);
    // setApi(ApiType.cloudConfig, ConfigClient(tmp));
    // setApi(ApiType.cloudServerSetting, ServerConfigClient(tmp));
    // first auth
    //tmp = BaseApi(AppConfigRepository.instance.serverUrl);
    setApi(ApiType.cloudAuth, AuthClient(tmp));
  }

  void setServerApi([String? url]) {
    BaseApi tmp = BaseApi(url ?? AppConfigRepository.instance.serverUrl);
    setApi(ApiType.cloudAuth, AuthClient(tmp));
  }

  // void setServerConfigApi([String? url]) {
  //   BaseApi tmp = BaseApi(url ?? AppConfigRepository.instance.serverUrl);
  //   setApi(ApiType.cloudServerSetting, ServerConfigClient(tmp));
  // }

  /// if token is null -> set previous token
  void setToken({String? token, String? tokenType,String? accountId}) {
    //print("sensingapi setToken ${token} peopleToken ${peopleToken}");
    String? newToken = token ?? (stringError(client.token) ? client.token : null);
    String? newTokenType = tokenType ?? "Bearer";
    // client = BaseApi(SettingRepository.instance.serverUrl,
    client = BaseApi(AppConfigRepository.instance.serverUrl, token: newToken, tokenType: newTokenType);
    setApi(ApiType.cloudAuth, AuthClient(client));

    /// TODO : ADD another clients.
  }

  /// reset token , if token is not null , reset , null, set previous token
  void reSetToken({bool token = false, bool peopleToken = false, bool deviceId = false}) {
    String? newToken = (token == true) ? null : (stringError(client.token) ? client.token : null);
    String? newTokenType = (newToken == null) ? null : ((token == true) ? null : "Bearer");
    // client = BaseApi(SettingRepository.instance.serverUrl,
    client = BaseApi(AppConfigRepository.instance.serverUrl, token: newToken, tokenType: newTokenType);
    setApi(ApiType.cloudAuth, AuthClient(client));
  }

  Future<UserLogin?> accountLogin(String username, String password) async {
    AuthClient api = _apis[ApiType.cloudAuth.index] as AuthClient;
    return await api.userLogin(username, password);
  }

  Future<UserListResponse?> getAccountList() async {
    AuthClient api = _apis[ApiType.cloudAuth.index] as AuthClient;
    return await api.getAccountList();
  }
}
