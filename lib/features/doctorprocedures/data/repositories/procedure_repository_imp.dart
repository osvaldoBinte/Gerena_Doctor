import 'package:gerena/common/services/auth_service.dart';
import 'package:gerena/features/doctorprocedures/data/datasources/procedures_data_sources_imp.dart';
import 'package:gerena/features/doctorprocedures/domain/entities/createprocedures/create_procedures_entity.dart';
import 'package:gerena/features/doctorprocedures/domain/entities/getprocedures/get_procedures_entity.dart';
import 'package:gerena/features/doctorprocedures/domain/repositories/procedures_repository.dart';

class ProcedureRepositoryImp implements ProceduresRepository {
  final ProceduresDataSourcesImp proceduresDataSourcesImp;
    final AuthService authService = AuthService();

  ProcedureRepositoryImp({required this.proceduresDataSourcesImp});
  @override
  Future<void> addimagenes(ProceduresEntity entity,int procedimientoId) async {
    final token = await authService.getToken()?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return await proceduresDataSourcesImp.addimagenes(entity, procedimientoId, token);
  }

  @override
  Future<void> createprocedure(ProceduresEntity entity) async {
        final token = await authService.getToken()?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return await proceduresDataSourcesImp.createprocedure(entity, token);

  }

  @override
  Future<List< GetProceduresEntity>>getProcedures() async {
        final token = await authService.getToken()?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return await proceduresDataSourcesImp.getProcedures(token);
  }

  @override
  Future<void> updateprocedure(ProceduresEntity entity,int id) async {
            final token = await authService.getToken()?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
     return await proceduresDataSourcesImp.updateprocedure(entity, id, token);
  }
  
  @override
  Future<void> deleteimg(int id) async {
                final token = await authService.getToken()?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));

    return await proceduresDataSourcesImp.deleteimg(id, token);
  }
  
  @override
  Future<void> deleteprocedure(int id) async {
               final token = await authService.getToken()?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));

    return await proceduresDataSourcesImp.deleteprocedure(id, token);
  }

}