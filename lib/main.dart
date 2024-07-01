import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:optimo/models/statement.dart';
import 'package:optimo/service/server_request.dart';
import 'package:optimo/constants/api_constant.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePageScreen(),
      builder: EasyLoading.init(),
    );
  }
}

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  String? fileName;
  List<int>? fileBytes;

  Statement? statement;

  Future<void> _uploadJson() async {
    if (fileName != null && fileBytes != null) {
      http.MultipartFile file = http.MultipartFile.fromBytes(
        "json_file",
        fileBytes!,
        filename: fileName,
      );
      var response = await ServerRequest.formData(
        method: "POST",
        path: ApiConstant.uploadStatement,
        headers: ServerRequest.basicHeader,
        fileFields: [file],
      );
      if (response != null) {
        setState(() {
          statement = Statement.fromJson(response);
        });
      }
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result != null) {
      setState(() {
        fileBytes = result.files.single.bytes;
        fileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          "Optimo",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.2,
            vertical: 32,
          ),
          decoration: BoxDecoration(border: Border.all(color: Colors.black26)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "Bank Statement Analysis",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(height: 40),
                statement != null
                    ? _monthlyNetInflows("Monthly NetInflows",
                        statement!.data!.monthlyNetInflows)
                    : _feature("Monthly NetInflows", "Null"),
                statement != null ? SizedBox(height: 15) : SizedBox(height: 30),
                statement != null
                    ? _monthlyNetCashFlow("Monthly NetCashflows",
                        statement!.data!.monthlyNetCashFlow)
                    : _feature("Monthly NetCashflows", "Null"),
                statement != null ? SizedBox(height: 15) : SizedBox(height: 30),
                _feature(
                    "Average NetInflow",
                    statement != null
                        ? statement!.data!.averageNetInflows
                        : "Null"),
                SizedBox(height: 30),
                _feature(
                    "ECS/NACH return transactions count",
                    statement != null
                        ? statement!.data!.ecsNachReturnTransactionsCount
                        : "Null"),
                SizedBox(height: 30),
                _feature(
                    "Average Balance",
                    statement != null
                        ? statement!.data!.averageBalance
                        : "Null"),
                Divider(height: 40),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.greenAccent.shade700),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    onPressed: () {
                      _uploadJson();
                    },
                    child: const Text(
                      "Upload",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      _pickFile();
                    },
                    child: Text(fileName == null ? "select json file" : fileName!),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _monthlyNetInflows(
      String title, List<MonthlyNetInflow> monthlyNetInflows) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 19,
            color: Colors.blue.shade400,
          ),
        ),
        children: monthlyNetInflows
            .map(
              (e) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${e.monthYear}",
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    "${e.netInflows}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _monthlyNetCashFlow(
      String title, List<MonthlyNetCashFlow> monthlyNetCashFlow) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 19,
            color: Colors.blue.shade400,
          ),
        ),
        children: monthlyNetCashFlow
            .map(
              (e) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${e.monthYear}",
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    "${e.netCashflows}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _feature(String title, dynamic value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 19,
            color: Colors.blue.shade400,
          ),
        ),
        Text(
          '$value',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
