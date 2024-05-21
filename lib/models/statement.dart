class Statement {
  Statement({
    required this.data,
  });

  final Data? data;

  factory Statement.fromJson(Map<String, dynamic> json){
    return Statement(
      data: json["Data"] == null ? null : Data.fromJson(json["Data"]),
    );
  }

}

class Data {
  Data({
    required this.monthlyNetInflows,
    required this.monthlyNetCashFlow,
    required this.ecsNachReturnTransactionsCount,
    required this.averageBalance,
    required this.averageNetInflows,
  });

  final List<MonthlyNetInflow> monthlyNetInflows;
  final List<MonthlyNetCashFlow> monthlyNetCashFlow;
  final int? ecsNachReturnTransactionsCount;
  final double? averageBalance;
  final double? averageNetInflows;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      monthlyNetInflows: json["monthly_netInflows"] == null ? [] : List<MonthlyNetInflow>.from(json["monthly_netInflows"]!.map((x) => MonthlyNetInflow.fromJson(x))),
      monthlyNetCashFlow: json["monthly_netCashFlow"] == null ? [] : List<MonthlyNetCashFlow>.from(json["monthly_netCashFlow"]!.map((x) => MonthlyNetCashFlow.fromJson(x))),
      ecsNachReturnTransactionsCount: json["ECS/NACH return transactions count"],
      averageBalance: json["average_balance"],
      averageNetInflows: json["average_netInflows"],
    );
  }

}

class MonthlyNetCashFlow {
  MonthlyNetCashFlow({
    required this.monthYear,
    required this.netCashflows,
  });

  final String? monthYear;
  final double? netCashflows;

  factory MonthlyNetCashFlow.fromJson(Map<String, dynamic> json){
    return MonthlyNetCashFlow(
      monthYear: json["monthYear"],
      netCashflows: json["netCashflows"],
    );
  }

}

class MonthlyNetInflow {
  MonthlyNetInflow({
    required this.monthYear,
    required this.netInflows,
  });

  final String? monthYear;
  final double? netInflows;

  factory MonthlyNetInflow.fromJson(Map<String, dynamic> json){
    return MonthlyNetInflow(
      monthYear: json["monthYear"],
      netInflows: json["netInflows"],
    );
  }

}
