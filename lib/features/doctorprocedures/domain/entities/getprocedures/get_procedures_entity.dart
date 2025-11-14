
class GetProceduresEntity {
  final int id ;
  final String titulo;
  final String description;
  final String creationdate;
  final List<ImagenesEntity > img;
  GetProceduresEntity({
   required this.id,
   required this.titulo,
   required this.creationdate,
   required this.description,
   required this.img
  });

}
class ImagenesEntity {
   final int id;
   final String urlImagen;
   ImagenesEntity({
    required this.id,
    required this.urlImagen
   });
}