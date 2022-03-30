import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/components/regions_map/interactor/view_models/place.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/regions_screens/join_region/interactor/mappers/set_regions_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/join_region/interactor/mappers/update_regions_results_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/join_region/interactor/usecases/get_firebase_regions_use_case.dart';
import 'package:seeds/screens/explore_screens/regions_screens/join_region/interactor/usecases/get_region_use_case.dart';
import 'package:seeds/screens/explore_screens/regions_screens/join_region/interactor/usecases/get_regions_use_case.dart';

part 'join_region_event.dart';
part 'join_region_state.dart';

class JoinRegionBloc extends Bloc<JoinRegionEvent, JoinRegionState> {
  JoinRegionBloc() : super(JoinRegionState.initial()) {
    on<OnLoadRegions>(_onLoadRegions);
    on<OnUpdateMapLocation>(_onUpdateMapLocations);
  }

  Future<void> _onLoadRegions(OnLoadRegions event, Emitter<JoinRegionState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    // Check if user has joined a Region
    final result = await GetRegionUseCase().run(settingsStorage.accountName);
    if (result.isError) {
      emit(state.copyWith(pageState: PageState.failure));
    } else {
      if (result.asValue!.value == null) {
        // User has not joined a Region
        final result = await GetRegionsUseCase().run();
        emit(SetRegionsStateMapper().mapResultToState(state, result));
      } else {
        // User has joined a Region
        emit(state.copyWith(pageCommand: NavigateToRoute(Routes.region)));
      }
    }
  }

  Future<void> _onUpdateMapLocations(OnUpdateMapLocation event, Emitter<JoinRegionState> emit) async {
    final result = await GetFirebaseRegionsUseCase()
        .run(GetFirebaseRegionsUseCase.input(lat: event.place.lat, lng: event.place.lng, radius: 1000));
    emit(UpdateRegionsResultsStateMapper().mapResultToState(state, result, event.place));
  }
}
