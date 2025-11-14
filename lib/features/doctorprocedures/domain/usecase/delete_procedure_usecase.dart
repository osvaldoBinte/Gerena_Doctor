import 'package:gerena/features/doctorprocedures/domain/repositories/procedures_repository.dart';

class DeleteProcedureUsecase {
   final ProceduresRepository proceduresRepository;
    DeleteProcedureUsecase({required this.proceduresRepository});
    Future<void> execute(int id) async {
      return await proceduresRepository.deleteprocedure(id);
    }
}