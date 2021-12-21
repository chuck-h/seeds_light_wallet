import 'package:async/async.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_scopes.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/main.dart';

class TokenModelsRepository extends HttpRepository {
  Future<Result<List<TokenModel>>> getTokenModels(String usecase) async {
    print("[http] update token models");
    final String request = '''
    {
      "code":"${SeedsCode.accountTokenModels.value}",
      "table":"tokens",
      "scope":"$usecase",
      "json":true
    }
    ''';

    final v1ChainUrl = Uri.parse(
        isInDebugMode ? 'http://api.telosfoundation.io/v1/chain/get_table_rows'
                      : 'https://api.telosfoundation.io/v1/chain/get_table_rows' );
    return http
        .post(v1ChainUrl, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<List<TokenModel>>(response, (dynamic body) {
              final List<dynamic> tokens = body['rows'].toList();
              return List<TokenModel?>.of(tokens.map((token) =>
                  TokenModel.fromJson(token as Map<String,dynamic>))).whereNotNull().toList();
            }))
        .catchError((dynamic error) => mapHttpError(error));
  }
}
