import 'package:cuaca/provider/cuaca_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  Intl.defaultLocale = 'id_ID';
  initializeDateFormatting().then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cuaca App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mendapatkan tanggal dan hari terkini
    DateTime currentDate = DateTime.now();
    String dayOfWeek = _getDayOfWeek(currentDate.weekday);

    return Scaffold(
      appBar: AppBar(
        title: Text("LUTHFI NURHAIKAL"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'data:image/jpeg;base64,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'),
            fit: BoxFit.cover,
          ),
        ),
        child: Consumer<CuacaProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        dayOfWeek,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${currentDate.day} ${_getMonthName(currentDate.month)} ${currentDate.year}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: provider.cityNameText,
                    decoration: InputDecoration(
                      hintText: "Input Nama Kota",
                      labelText: "Nama Kota",
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      provider.showWeatherData();
                    },
                    child: Text("Tampilkan Cuaca"),
                  ),
                  SizedBox(height: 20),
                  Text(
                    provider?.cuacaModel?.name ?? "Waiting Data",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    provider.cuacaModel.weather?.first?.main ?? "Waiting data",
                  ),
                  SizedBox(height: 10),
                  Text("Suhu: ${provider.cuacaModel.main?.temp?.toStringAsFixed(0) ?? ''} \u2103"),

                ],
              ),
            );
          },
        ),
      ),
    );
  }

              String _getDayOfWeek(int day) {
                switch (day) {
                  case 1:
                    return "Senin";
                  case 2:
                    return "Selasa";
                  case 3:
                    return "Rabu";
                  case 4:
                    return "Kamis";
                  case 5:
                    return "Jumat";
                  case 6:
                    return "Sabtu";
                  case 7:
                    return "Minggu";
                  default:
                    return "";
                }
              }

              String _getMonthName
            (int month) {
            switch (month) {
            case 1:
            return "Januari";
            case 2:
            return "Februari";
            case 3:
            return "Maret";
            case 4:
            return "April";
            case 5:
            return "Mei";
            case 6:
            return "Juni";
            case 7:
            return "Juli";
            case 8:
            return "Agustus";
            case 9:
            return "September";
            case 10:
            return "Oktober";
            case 11:
            return "November";
            case 12:
            return "Desember";
            default:
            return "";
        }
    }
 }

