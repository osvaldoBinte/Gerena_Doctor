import 'package:gerena/features/doctorprocedures/domain/entities/getprocedures/get_procedures_entity.dart';
import 'package:gerena/features/doctorprocedures/domain/repositories/procedures_repository.dart';

class GetProceduresByDoctorUsecase {
    final ProceduresRepository proceduresRepository;
    GetProceduresByDoctorUsecase({required this.proceduresRepository});
    Future<List< GetProceduresEntity>> execute(int id) async {
      return await proceduresRepository.getProceduresbyidDoctor(id);
    }

}