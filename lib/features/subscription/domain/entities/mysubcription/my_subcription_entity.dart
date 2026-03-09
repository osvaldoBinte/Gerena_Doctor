class MySubscriptionEntity {
  final int? id;
  final int? userid;
  final String? username;
  final int? subscriptionplanId;
  final String? planname;
  final double? planprice;
  final String? state;
  final String? startdate;
  final String? currentPeriodEnddate;
  final bool? cancelledAtPeriodEnd;
   String? cancellationdate;
  MySubscriptionEntity({
     this.id,
     this.userid,
     this.username,
     this.subscriptionplanId,
     this.planname,
     this.planprice,
     this.state,
     this.startdate,
     this.currentPeriodEnddate,
     this.cancelledAtPeriodEnd,
     this.cancellationdate,
  });
}