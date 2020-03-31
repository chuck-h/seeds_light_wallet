import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teloswallet/constants/app_colors.dart';
import 'package:teloswallet/models/models.dart';
import 'package:teloswallet/providers/notifiers/settings_notifier.dart';
import 'package:teloswallet/providers/notifiers/telos_balance_notifier.dart';
import 'package:teloswallet/providers/notifiers/transactions_notifier.dart';
import 'package:teloswallet/providers/services/navigation_service.dart';
import 'package:teloswallet/utils/string_extension.dart';
import 'package:teloswallet/widgets/empty_button.dart';
import 'package:teloswallet/widgets/main_card.dart';
import 'package:teloswallet/widgets/transaction_avatar.dart';
import 'package:teloswallet/widgets/transaction_dialog.dart';
import 'package:shimmer/shimmer.dart';

enum TransactionType { income, outcome }

class Wallet extends StatefulWidget {
  Wallet();

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(17),
            child: Column(
              children: <Widget>[
                buildHeader(),
                buildTransactions(),
              ],
            )),
      ),
      onRefresh: refreshData,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    refreshData();
  }

  Future<void> refreshData() async {
    await Future.wait(<Future<dynamic>>[
      TransactionsNotifier.of(context).fetchTransactionsCache(),
      TransactionsNotifier.of(context).refreshTransactions(),
      TelosBalanceNotifier.of(context).fetchBalance(),
    ]);
  }

  void onTransfer() {
    NavigationService.of(context).navigateTo(Routes.transferForm);
  }

  Widget buildHeader() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: height * 0.2,
      child: MainCard(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: AppColors.gradient,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Available balance',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w300),
              ),
              Consumer<TelosBalanceNotifier>(builder: (context, model, child) {
                return (model != null && model.balance != null)
                    ? Text(
                        '${model.balance?.quantity?.quantityFormatted} TLOS',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w700),
                      )
                    : Shimmer.fromColors(
                        baseColor: Colors.green[300],
                        highlightColor: Colors.blue[300],
                        child: Container(
                          width: 200.0,
                          height: 26,
                          color: Colors.white,
                        ),
                      );
              }),
              EmptyButton(
                width: width * 0.5,
                title: 'Transfer',
                color: Colors.white,
                onPressed: onTransfer,
              )
            ],
          ),
        ),
      ),
    );
  }

  void onTransaction({
    TransactionModel transaction,
    String account,
    TransactionType type,
  }) {
    showModalBottomSheet(
        context: context,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        builder: (BuildContext context) {
          return TransactionDialog(
            transaction: transaction,
            account: account,
            transactionType: type,
          );
        });
  }

  Widget buildTransaction(TransactionModel model) {
    String userAccount = SettingsNotifier.of(context).accountName;

    TransactionType type = model.to == userAccount
        ? TransactionType.income
        : TransactionType.outcome;

    String participantAccountName =
        type == TransactionType.income ? model.from : model.to;

    return InkWell(
      onTap: () => onTransaction(
        transaction: model,
        account: participantAccountName,
        type: type,
      ),
      child: Column(
        children: [
          Divider(height: 22),
          Container(
            child: Row(
              children: <Widget>[
                Flexible(
                    child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 10),
                      child: Icon(
                        type == TransactionType.income
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: type == TransactionType.income
                            ? AppColors.green
                            : AppColors.red,
                      ),
                    ),
                    TransactionAvatar(
                      size: 40,
                      account: participantAccountName,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.blue,
                      ),
                    ),
                    Flexible(
                        child: Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      participantAccountName,
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: AppColors.grey, fontSize: 13),
                                    ),
                                  ),
                                ])))
                  ],
                )),
                Container(
                    margin: EdgeInsets.only(left: 10, right: 15),
                    child: Row(
                      children: <Widget>[
                        Text(
                          type == TransactionType.income ? '+ ' : '-',
                          style: TextStyle(
                              color: type == TransactionType.income
                                  ? AppColors.green
                                  : AppColors.red,
                              fontSize: 16),
                        ),
                        Text(
                          model.quantity,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTransactions() {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      margin: EdgeInsets.only(bottom: 7, top: 15),
      child: MainCard(
        padding: EdgeInsets.only(top: 15, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(bottom: 3, left: 15, right: 15),
                child: Text(
                  'Latest transactions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                )),
            Consumer<TransactionsNotifier>(
              builder: (context, model, child) =>
                  model != null && model.transactions != null
                      ? Column(
                          children: <Widget>[
                            ...model.transactions.map((trx) {
                              return buildTransaction(trx);
                            }).toList()
                          ],
                        )
                      : Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                height: 16,
                                width: 320,
                                color: Colors.white,
                                margin: EdgeInsets.only(left: 10, right: 10),
                              ),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
