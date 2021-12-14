import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/settings_storage.dart';

class TokenModel extends Equatable {
  static final Map<String, TokenModel> allTokens = { };

  static const List<TokenModel> defaultTokens = [
    seedsToken, telosToken,
    husdToken, hyphaToken, localScaleToken, starsToken
  ];

  final String chainName;
  final String contract;
  final String symbol;
  final String name;
  final String backgroundImage;
  final String logo;
  final String balanceSubTitle;
  final int precision;

  String get id => "$contract#$symbol";

  static Future<void> initialize() async {
    if(settingsStorage.allTokensList.isEmpty) {
      for (final tm in defaultTokens) {
        allTokens[tm.id] = tm;
      }
      settingsStorage.allTokensList = allTokens.values.toList();
    }
  }

  const TokenModel({
    required this.chainName,
    required this.contract,
    required this.symbol,
    required this.name,
    required this.backgroundImage,
    required this.logo,
    required this.balanceSubTitle,
    this.precision = 4,
  });


  factory TokenModel.fromSymbol(String symbol) {
    return allTokens.values.firstWhere((e) => e.symbol == symbol);
  }

  static const Map<String,dynamic> presetToken = {
    'backgroundImage': 'assets/images/wallet/currency_info_cards/default/background.jpg',
    'logo': 'assets/images/wallet/currency_info_cards/default/logo.jpg',
    'balanceSubTitle': 'Wallet Balance'
  };

  factory TokenModel.fromJson(Map<String, dynamic> parsedJson) {
    final String chainName = parsedJson['chainName'] ??
        { throw Exception('token JSON: $parsedJson -> "chainName" is missing') };
    final String contract = parsedJson['contract'] ??
        { throw Exception('token JSON: $parsedJson -> "contract" is missing') };
    final String symbol = parsedJson['symbol'] ??
        { throw Exception('token JSON: $parsedJson -> "symbol" is missing') };
    final String name = parsedJson['name'] ?? symbol;
    final String backgroundImage = parsedJson['backgroundImage'] ?? presetToken['backgroundImage'];
    final String logo = parsedJson['logo'] ?? presetToken['logo'];
    final String balanceSubTitle = parsedJson['balanceSubTitle'] ?? presetToken['balanceSubTitle'];
    final rv = TokenModel(chainName: chainName, contract: contract, symbol: symbol,
        name: name, backgroundImage: backgroundImage, logo: logo, balanceSubTitle: balanceSubTitle);
    allTokens[rv.id] = rv;
    return rv;
  }

  Map<String, dynamic> toJson() => {
    'chainName': chainName,
    'contract': contract,
    'symbol': symbol,
    'name': name,
    'backgroundImage': backgroundImage,
    'logo': logo,
    'balanceSubTitle': balanceSubTitle,
    'precision': precision
  };
    
  static TokenModel? fromSymbolOrNull(String symbol) {
    return allTokens.values.firstWhereOrNull((e) => e.symbol == symbol);
  }

  @override
  List<Object?> get props => [chainName, contract, symbol];

  String getAssetString(double quantity) {
    return "${quantity.toStringAsFixed(precision)} $symbol";
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
