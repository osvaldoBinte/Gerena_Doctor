import 'package:gerena/features/doctorprocedures/domain/entities/createprocedures/create_procedures_entity.dart';
import 'package:gerena/features/doctorprocedures/domain/repositories/procedures_repository.dart';

class AddImagenesUsecase {
  final ProceduresRepository proceduresRepository;
  AddImagenesUsecase({required this.proceduresRepository});
  Future<void> execute(ProceduresEntity entity,int procedimientoId) async {
    return await proceduresRepository.addimagenes(entity, procedimientoId);

  }
}