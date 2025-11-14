import 'package:gerena/features/doctorprocedures/domain/repositories/procedures_repository.dart';

class DeleteImgUsecase {
   final ProceduresRepository proceduresRepository;
    DeleteImgUsecase({required this.proceduresRepository});
    Future<void> execute(int id) async {
      return await proceduresRepository.deleteimg(id);
    }
}