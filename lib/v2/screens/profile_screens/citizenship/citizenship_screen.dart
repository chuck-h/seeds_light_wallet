import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/screens/profile_screens/citizenship/components/resident_view.dart';
import 'package:seeds/v2/screens/profile_screens/citizenship/components/visitor_view.dart';
import 'package:seeds/v2/screens/profile_screens/citizenship/interactor/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/profile_screens/profile/interactor/viewmodels/profileValuesArguments.dart';

/// CITIZENSHIP SCREEN
class CitizenshipScreen extends StatelessWidget {
  const CitizenshipScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ProfileValuesArguments args = ModalRoute.of(context)!.settings.arguments! as ProfileValuesArguments;
    return BlocProvider(
      create: (context) => CitizenshipBloc()..add(SetValues(profile: args.profile, score: args.scores)),
      child: Scaffold(
        appBar: AppBar(),
        body: args.profile.status == 'visitor' ? const VisitorView() : const ResidentView(),
      ),
    );
  }
}
