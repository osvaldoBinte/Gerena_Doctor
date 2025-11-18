import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/home/dashboard/widget/estatusdepedido/estatus_de_pedido.dart';
import 'package:gerena/features/home/dashboard/widget/estatusdepedido/widgets_status_pedido.dart';
import 'package:get/get.dart';
 class StatusCardModal extends StatelessWidget {
  const StatusCardModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Material(
        color: Colors.black54,
        child: Align(
          alignment: Alignment.topLeft,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: MediaQuery.of(context).size.width < 800 
                  ? MediaQuery.of(context).size.width * 0.9  
                  : MediaQuery.of(context).size.width * 0.4,  
              height: MediaQuery.of(context).size.height * 0.7, 
              margin: EdgeInsets.only(
                top: 130,
                left: MediaQuery.of(context).size.width < 800 ? 16 : 16,
                right: MediaQuery.of(context).size.width < 800 ? 16 : 0,
              ),
              child: TweenAnimationBuilder<Offset>(
                tween: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                builder: (context, offset, child) {
                  return Transform.translate(
                    offset: Offset(0, offset.dy * MediaQuery.of(context).size.height),
                    child: Transform.scale(
                      scale: MediaQuery.of(context).size.width < 800 ? 0.9 : 0.8,
                      child: child,
                    ),
                  );
                },
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: double.infinity,
                      minHeight: 200,
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.topLeft,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width < 800 
                              ? MediaQuery.of(context).size.width * 0.85
                              : 400, 
                        ),
                       // child: StatusCardWidget(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}