import 'package:gerena/features/doctorprocedures/domain/entities/createprocedures/create_procedures_entity.dart';
import 'package:gerena/features/doctorprocedures/domain/repositories/procedures_repository.dart';

class UpdateProcedureUsecase {
  ProceduresRepository proceduresRepository;
  UpdateProcedureUsecase({required this.proceduresRepository});
    Future<void> execute(ProceduresEntity entity,int id) async {
      return await proceduresRepository.updateprocedure(entity, id);
    }

}