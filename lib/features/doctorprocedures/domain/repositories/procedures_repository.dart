import 'package:gerena/features/doctorprocedures/domain/entities/createprocedures/create_procedures_entity.dart';
import 'package:gerena/features/doctorprocedures/domain/entities/getprocedures/get_procedures_entity.dart';

abstract class ProceduresRepository {
  Future<void> createprocedure(ProceduresEntity entity);
  Future<List< GetProceduresEntity>> getProcedures();
  Future<void> updateprocedure(ProceduresEntity entity,int id);
  Future <void> addimagenes(ProceduresEntity entity,int procedimientoId);
  Future<void> deleteprocedure(int id);
 Future<void> deleteimg(int id);
}