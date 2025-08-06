import 'dart:async';
import 'dart:io';

String convertMessageException({required dynamic error}) {
  switch (error) {
    case SocketException:
      return 'Servicio no disponible intente mas tarde';
    case TimeoutException:
      return 'La peticion tardo mas  de lo usual, intente de nuevo';
    default:
      return error.toString();
  }
}


String formatTextWithLineBreaks(String text) {
    String processedText = text
        .replaceAll('Dr. ', 'TEMP_DR_PLACEHOLDER ')
        .replaceAll('Dra. ', 'TEMP_DRA_PLACEHOLDER ');
    processedText = processedText
        .replaceAll('. ', '.\n\n')
        .replaceAll('.', '.\n')
        .replaceAll('\n\n', '\n');
    processedText = processedText
        .replaceAll('TEMP_DR_PLACEHOLDER ', 'Dr. ')
        .replaceAll('TEMP_DRA_PLACEHOLDER ', 'Dra. ')
        .trim();
    return processedText;
  }