import 'package:gerena/features/doctorprocedures/domain/entities/getprocedures/get_procedures_entity.dart';
import 'package:gerena/features/doctorprocedures/domain/repositories/procedures_repository.dart';

class GetProceduresUsecase {
    final ProceduresRepository proceduresRepository;
    GetProceduresUsecase({required this.proceduresRepository});
    Future<List< GetProceduresEntity>> execute() async {
      return await proceduresRepository.getProcedures();
    }

}