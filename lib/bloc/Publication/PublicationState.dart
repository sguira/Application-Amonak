import 'package:application_amonak/models/publication.dart';

abstract class PublicationState {}

class PublicationInitial extends PublicationState {}

class PublicationLoader extends PublicationState {
  List<Publication> publications;
  final bool isLoading;
  PublicationLoader(this.publications, this.isLoading);
}

class PublicationError {
  String message;
  PublicationError(this.message);
}
