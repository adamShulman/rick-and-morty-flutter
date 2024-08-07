
import 'package:flutter/material.dart';
import 'package:indieflow/models/character.dart';
import 'package:indieflow/services/indie_repository.dart';
import 'package:indieflow/services/remote_service.dart';
import 'package:indieflow/utils/data_utils.dart';
import 'package:indieflow/utils/shared_prefs_wrapper.dart';
import 'package:indieflow/widgets/charts/bar_chart.dart';
import 'package:indieflow/widgets/charts/line_chart.dart';
import 'package:indieflow/widgets/charts/pie_chart.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {

  final IndieRepository _repository = IndieRepository(remoteService: RemoteService(SharedPrefsWrapper()), sharedPrefs: SharedPrefsWrapper());
  late Future<Result<List<Character>, NetworkException>> _characters;
  
  @override
  void initState() {
    super.initState();
    _characters = _repository.getCharacters();
    
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: _characters,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data!) {   

                  case Success(value: final characters):

                    return Column(
                      children: [
                        BarStyleChartWidget(chartItems: DataUtils.barChartSpeciesData(characters)),
                        PieStyleChartWidget(chartItems: DataUtils.pieChartStatusData(characters)),
                        const LineStyleChartWidget()
                      ],
                    );
                  case Failure():
                    return _messageWidget();
                }

              } else if (snapshot.hasError) {
                  return _messageWidget();
              }

              return const CircularProgressIndicator(
                  color: Colors.white,
                );

            },
          ),
        ),
      ),
    );
  }

  Widget _messageWidget() {
    return const Text(
      'No data.',
      maxLines: 1,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.w300,
        shadows: [
          Shadow(
            offset: Offset(2.0, 2.0),
            blurRadius: 3.0,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ],
      ),
    );
  }
}