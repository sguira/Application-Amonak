import 'package:application_amonak/bloc/Publication/PublicationEvent.dart';
import 'package:application_amonak/bloc/Publication/PublicationState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PublicationBloc extends Bloc<PublicationEvent, PublicationState> {
  PublicationBloc() : super(PublicationInitial());

  @override
  Stream<PublicationState> mapEventToState(PublicationEvent event) async* {
    // if (event is PublicationLoadEvent) {
    //   // yield PublicationLoading();
    //   // try {
    //   //   final publications = await PublicationService.getPublications();
    //   //   yield PublicationLoaded(publications);
    //   // } catch (e) {
    //   //   yield PublicationError("Failed to load publications");
    //   // }
    // }
  }
}
