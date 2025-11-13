class MySubscriptionEntity {
  final int id;
  final int userid;
  final String username;
  final int subscriptionplanId;
  final String planname;
  final double planprice;
  final String state;
  final String startdate;
  final String currentPeriodEnddate;
  final bool cancelledAtPeriodEnd;
   String ?cancellationdate;
  MySubscriptionEntity({
    required this.id,
    required this.userid,
    required this.username,
    required this.subscriptionplanId,
    required this.planname,
    required this.planprice,
    required this.state,
    required this.startdate,
    required this.currentPeriodEnddate,
    required this.cancelledAtPeriodEnd,
     this.cancellationdate,
  });
}