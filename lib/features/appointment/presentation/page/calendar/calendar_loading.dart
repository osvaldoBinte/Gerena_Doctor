import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:google_fonts/google_fonts.dart';

class CalendarLoading extends StatefulWidget {
  const CalendarLoading({Key? key}) : super(key: key);
  
  @override
  State<CalendarLoading> createState() => _CalendarLoadingState();
}

class _CalendarLoadingState extends State<CalendarLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmerAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: false);
    
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GerenaColors.backgroundColorFondo,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: GerenaColors.backgroundColorFondo,
          elevation: 4,
          shadowColor: GerenaColors.shadowColor,
        ),
      ),
      body: AnimatedBuilder(
        animation: _shimmerAnimation,
        builder: (context, child) {
          return _buildCalendarSkeleton();
        },
      ),
    );
  }
  
  Widget _buildShimmerBox({required Widget child}) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, _) {
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                GerenaColors.textSecondaryColor.withOpacity(0.1),
                GerenaColors.textSecondaryColor.withOpacity(0.3),
                GerenaColors.textSecondaryColor.withOpacity(0.1),
              ],
              stops: [
                _shimmerAnimation.value - 1,
                _shimmerAnimation.value,
                _shimmerAnimation.value + 1,
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }

  Widget _buildCalendarSkeleton() {
    return Column(
      children: [
        _buildCalendarHeaderSkeleton(),
        
        Padding(
          padding: EdgeInsets.symmetric(horizontal: GerenaColors.paddingMedium),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildShimmerBox(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: GerenaColors.textSecondaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          flex: 5,
          child: _buildMonthViewSkeleton(),
        ),
        
        Expanded(
          flex: 3,
          child: _buildDayAppointmentsSkeleton(),
        ),
      ],
    );
  }

  Widget _buildCalendarHeaderSkeleton() {
    return Padding(
      padding: EdgeInsets.all(GerenaColors.paddingMedium),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildShimmerBox(
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: GerenaColors.textSecondaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    _buildShimmerBox(
                      child: Container(
                        height: 20,
                        width: 140,
                        decoration: BoxDecoration(
                          color: GerenaColors.textSecondaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    _buildShimmerBox(
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: GerenaColors.textSecondaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildShimmerBox(
                child: Container(
                  height: 16,
                  width: 80,
                  decoration: BoxDecoration(
                    color: GerenaColors.textSecondaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: GerenaColors.paddingSmall),
        ],
      ),
    );
  }

  Widget _buildMonthViewSkeleton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: GerenaColors.paddingMedium),
      child: Column(
        children: [
          _buildWeekDaysHeaderSkeleton(),
          SizedBox(height: 8),
          Container(
            height: 1,
            color: GerenaColors.textSecondaryColor.withOpacity(0.1),
          ),
          SizedBox(height: 8),
          Expanded(
            child: _buildMonthDaysSkeleton(),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDaysHeaderSkeleton() {
    final weekDays = ['D', 'L', 'M', 'M', 'J', 'V', 'S'];
    
    return Row(
      children: weekDays.map((day) {
        return Expanded(
          child: Container(
            height: 40,
            alignment: Alignment.center,
            child: _buildShimmerBox(
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: GerenaColors.textSecondaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMonthDaysSkeleton() {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
      ),
      itemCount: 35,
      itemBuilder: (context, index) {
        final weekRow = index ~/ 7;
        final isEvenRow = weekRow % 2 == 0;
        
        return Container(
          decoration: BoxDecoration(
            color: isEvenRow 
                ? GerenaColors.backgroundColorFondo
                : GerenaColors.rowColorCalendar.withOpacity(0.4),
            border: Border.all(
              color: GerenaColors.textSecondaryColor.withOpacity(0.05),
              width: 0.5,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 4,
                left: 6,
                child: _buildShimmerBox(
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: GerenaColors.textSecondaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              
              if (index % 4 == 0 || index % 7 == 0) ...[
                Positioned(
                  top: 28,
                  left: 2,
                  right: 2,
                  child: _buildShimmerBox(
                    child: Container(
                      height: 14,
                      decoration: BoxDecoration(
                        color: GerenaColors.textSecondaryColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                
                if (index % 7 == 0)
                  Positioned(
                    bottom: 4,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (i) => 
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 1),
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: GerenaColors.primaryColor.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildDayAppointmentsSkeleton() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            color: Colors.grey.withOpacity(0.3),
            thickness: 1,
            height: 16,
          ),
          
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: _buildShimmerBox(
              child: Container(
                height: 24,
                width: 60,
                decoration: BoxDecoration(
                  color: GerenaColors.textSecondaryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 2,
              padding: EdgeInsets.symmetric(horizontal: GerenaColors.paddingMedium),
              itemBuilder: (context, index) {
                return _buildAppointmentCardSkeleton();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCardSkeleton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColor,
        borderRadius: GerenaColors.mediumBorderRadius,
        boxShadow: [GerenaColors.lightShadow],
        border: Border.all(
          color: GerenaColors.textSecondaryColor.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(GerenaColors.paddingMedium),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildShimmerBox(
                        child: Container(
                          width: 36,
                          height: 36,
                          margin: EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: GerenaColors.textSecondaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildShimmerBox(
                              child: Container(
                                height: 18,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: GerenaColors.textSecondaryColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 4),
                            _buildShimmerBox(
                              child: Container(
                                height: 16,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: GerenaColors.textSecondaryColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 4),
                            _buildShimmerBox(
                              child: Container(
                                height: 12,
                                width: 180,
                                decoration: BoxDecoration(
                                  color: GerenaColors.textSecondaryColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 12),
                  
               
                  Row(
                    children: [
                      _buildShimmerBox(
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: GerenaColors.textSecondaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                   
                      _buildShimmerBox(
                        child: Container(
                          height: 14,
                          width: 80,
                          decoration: BoxDecoration(
                            color: GerenaColors.textSecondaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 8),
                  
                  Row(
                    children: [
                   
                      _buildShimmerBox(
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: GerenaColors.textSecondaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                  
                      _buildShimmerBox(
                        child: Container(
                          height: 14,
                          width: 60,
                          decoration: BoxDecoration(
                            color: GerenaColors.textSecondaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                  
                      _buildShimmerBox(
                        child: Container(
                          height: 18,
                          width: 70,
                          decoration: BoxDecoration(
                            color: GerenaColors.textSecondaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      Spacer(),
                  
                      _buildShimmerBox(
                        child: Container(
                          height: 28,
                          width: 70,
                          decoration: BoxDecoration(
                            color: GerenaColors.textSecondaryColor,
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget buildContentOnly() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return _buildCalendarSkeleton();
      },
    );
  }
}