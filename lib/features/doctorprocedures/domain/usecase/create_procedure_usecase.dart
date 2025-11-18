
import 'package:gerena/features/doctorprocedures/domain/entities/createprocedures/create_procedures_entity.dart';
import 'package:gerena/features/doctorprocedures/domain/repositories/procedures_repository.dart';

class CreateProcedureUsecase {
  final ProceduresRepository proceduresRepository;
  CreateProcedureUsecase({required this.proceduresRepository});
  Future<void> execute(ProceduresEntity entity) async {
    return await proceduresRepository.createprocedure(entity);
  }

}