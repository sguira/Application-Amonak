abstract class PublicationEvent {}

class FetchPublicationId extends PublicationEvent {
  final String id;

  FetchPublicationId(this.id);
}
