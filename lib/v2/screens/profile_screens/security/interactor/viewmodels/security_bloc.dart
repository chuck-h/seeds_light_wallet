import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:seeds/providers/services/firebase/firebase_database_service.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/profile_screens/security/interactor/usecases/guardians_notification_use_case.dart';
import 'package:seeds/v2/screens/profile_screens/security/interactor/viewmodels/bloc.dart';

/// --- BLOC
class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  StreamSubscription<bool> _hasGuardianNotificationPending;

  SecurityBloc() : super(SecurityState.initial()) {
    _hasGuardianNotificationPending = GuardiansNotificationUseCase()
        .hasGuardianNotificationPending
        .listen((value) => add(ShowNotificationBadge(value: value)));
  }

  @override
  Stream<SecurityState> mapEventToState(SecurityEvent event) async* {
    if (event is SetUpInitialValues) {
      yield state.copyWith(
        pageState: PageState.success,
        isSecurePasscode: settingsStorage.passcodeActive,
        isSecureBiometric: true,
        hasNotification: false,
      );
    }
    if (event is ShowNotificationBadge) {
      yield state.copyWith(hasNotification: event.value);
    }
    if (event is OnGuardiansCardTapped) {
      yield state.copyWith(navigateToGuardians: null); //reset
      if (state.hasNotification) {
        await FirebaseDatabaseService().removeGuardianNotification(settingsStorage.accountName);
      }
      yield state.copyWith(navigateToGuardians: true);
    }
    if (event is OnPinChanged) {
      if (state.isSecurePasscode) {
        yield state.copyWith(isSecurePasscode: false);
        settingsStorage.passcode = null;
        settingsStorage.passcodeActive = false;
      } else {
        yield state.copyWith(isSecurePasscode: true);
        settingsStorage.passcodeActive = true;
      }
    }
    if (event is OnBiometricsChanged) {
      yield state.copyWith(isSecureBiometric: !state.isSecureBiometric);
    }
  }

  @override
  Future<void> close() {
    _hasGuardianNotificationPending?.cancel();
    return super.close();
  }
}
