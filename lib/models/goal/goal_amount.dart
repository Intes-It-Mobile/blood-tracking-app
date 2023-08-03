class GoalAmount {
  double? amount;
  bool? isMol;

  GoalAmount({this.amount, this.isMol});

  GoalAmount.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    isMol = json['is_mol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['is_mol'] = this.isMol;
    return data;
  }
    GoalAmount.fromGoalAmount(GoalAmount goalAmount) {
    this.amount = goalAmount.amount;
    this.isMol = goalAmount.isMol;
  }
}