import 'package:async/async.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/proposals_repository.dart';

class VoteProposalUseCase {
  Future<Result> run({required int id, required int amount}) {
    return ProposalsRepository().voteProposal(id: id, amount: amount, accountName: settingsStorage.accountName);
  }
}
