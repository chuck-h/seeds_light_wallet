import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/api/tokenmodels_repository.dart';

class TokenModel extends Equatable {
  static List<TokenModel> allTokens = [seedsToken];

  final String chainName;
  final String contract;
  final String symbol;
  final String name;
  final String backgroundImage;
  final String logo;
  final String balanceSubTitle;
  final int precision;
  final String? jsonData;

  String get id => "$contract#$symbol";

  const TokenModel({
    required this.chainName,
    required this.contract,
    required this.symbol,
    required this.name,
    required this.backgroundImage,
    required this.logo,
    required this.balanceSubTitle,
    this.precision = 4,
    this.jsonData = "",
  });

  static TokenModel? fromJson(Map<String,dynamic> data) {
    if(data["approved"] != 0) {
      final Map<String,dynamic> parsedJson = json.decode(data["json"]);
      return TokenModel(
          chainName: data["chainName"],
          contract: data["contract"],
          symbol: data["symbolcode"],
          name: parsedJson["name"]!,
          backgroundImage: parsedJson["backgdimage"]!,
          logo: parsedJson["logo"]!,
          balanceSubTitle: parsedJson["balancesubt"]!,
          precision: parsedJson["precision"]!,
          jsonData: data["json"]
      );
    }
  }

  factory TokenModel.fromSymbol(String symbol) {
    return allTokens.firstWhere((e) => e.symbol == symbol);
  }

  static TokenModel? fromSymbolOrNull(String symbol) {
    return allTokens.firstWhereOrNull((e) => e.symbol == symbol);
  }

  @override
  List<Object?> get props => [chainName, contract, symbol];

  String getAssetString(double quantity) {
    return "${quantity.toStringAsFixed(precision)} $symbol";
  }

  static Future<void> updateModels(String tokenModelUseCase) async {
    await TokenModelsRepository().getTokenModels(tokenModelUseCase).then((models){
      if(models.isValue) {
        allTokens.addAll(models.asValue!.value);
      } else if(models.isError) {
        print('Error updating Token Models from chain');
      }
    });
  }
}

const seedsToken = TokenModel(
  chainName: "Telos",
  contract: "token.seeds",
  symbol: "SEEDS",
  name: "Seeds",
  backgroundImage: 'assets/images/wallet/currency_info_cards/seeds/background.jpg',
  logo: 'assets/images/wallet/currency_info_cards/seeds/logo.jpg',
  balanceSubTitle: 'Wallet Balance',
);

const husdToken = TokenModel(
  chainName: "Telos",
  contract: "husd.hypha",
  symbol: "HUSD",
  name: "HUSD",
  backgroundImage: 'assets/images/wallet/currency_info_cards/husd/background.jpg',
  logo: 'assets/images/wallet/currency_info_cards/husd/logo.jpg',
  balanceSubTitle: 'Wallet Balance',
  precision: 2,
);

const hyphaToken = TokenModel(
  chainName: "Telos",
  contract: "token.hypha",
  symbol: "HYPHA",
  name: "Hypha",
  backgroundImage: 'assets/images/wallet/currency_info_cards/hypha/background.jpg',
  logo: 'assets/images/wallet/currency_info_cards/hypha/logo.jpg',
  balanceSubTitle: 'Wallet Balance',
  precision: 2,
);

const localScaleToken = TokenModel(
  chainName: "Telos",
  contract: "token.local",
  symbol: "LSCL",
  name: "LocalScale",
  backgroundImage: 'assets/images/wallet/currency_info_cards/lscl/background.jpg',
  logo: 'assets/images/wallet/currency_info_cards/lscl/logo.png',
  balanceSubTitle: 'Wallet Balance',
);

const starsToken = TokenModel(
  chainName: "Telos",
  contract: "star.seeds",
  symbol: "STARS",
  name: "Stars",
  backgroundImage: 'assets/images/wallet/currency_info_cards/stars/background.jpg',
  logo: 'assets/images/wallet/currency_info_cards/stars/logo.jpg',
  balanceSubTitle: 'Wallet Balance',
);

const telosToken = TokenModel(
  chainName: "Telos",
  contract: "eosio.token",
  symbol: "TLOS",
  name: "Telos",
  backgroundImage: 'assets/images/wallet/currency_info_cards/tlos/background.png',
  logo: 'assets/images/wallet/currency_info_cards/tlos/logo.png',
  balanceSubTitle: 'Wallet Balance',
);
