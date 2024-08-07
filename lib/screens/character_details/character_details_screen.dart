
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:indieflow/models/episode.dart';
import 'package:indieflow/models/list_item.dart';
import 'package:indieflow/services/indie_repository.dart';
import 'package:indieflow/services/remote_service.dart';
import 'package:indieflow/utils/extensions.dart';
import 'package:indieflow/utils/shared_prefs_wrapper.dart';
import 'package:indieflow/widgets/character/list_item_widget.dart';

class CharacterDetailsScreen extends StatefulWidget {

  final ListItem listItem;
  const CharacterDetailsScreen({super.key, required this.listItem});

  @override
  State<StatefulWidget> createState() => _CharacterDetailsScreenState();
}

class _CharacterDetailsScreenState extends State<CharacterDetailsScreen>  {
  
  final IndieRepository _repository = IndieRepository(remoteService: RemoteService(SharedPrefsWrapper()), sharedPrefs: SharedPrefsWrapper());
  late Future<Result<List<Episode>, NetworkException>> _episodesFuture;

  @override
  void initState() {
    super.initState();
    _episodesFuture = _repository.getMultipleEpisodes(ids: widget.listItem.character.episodeIds());
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listItem.character.name),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Card(
              margin: const EdgeInsets.all(12.0),
              color: Colors.white,
              elevation: 10.0,
              shadowColor: Colors.black,
              child: Container(
                margin: const EdgeInsets.all(1.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [
                      0.01,
                      0.29,
                      0.48,
                      0.67,
                      0.98
                    ],
                    colors: widget.listItem.colorScheme.gradientColors
                  )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
              child: SingleChildScrollView(
              // padding: const EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: 20.0),
                child: Column(
                  children: [
                    Hero(
                      tag: widget.listItem.identifier,
                      child: ListItemWidget(
                        listItem: widget.listItem, 
                        cardRadius: const BorderRadius.only(topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0)), 
                        cardMargin: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
                        showGradient: false,
                        shadowColor: const Color.fromARGB(68, 0, 0, 0),
                      ),
                    ),
                    const Text(
                      'Appearances',
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 3.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                      )
                    ),
                    FutureBuilder(
                      future: _episodesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          switch (snapshot.data!) {   

                            case Success(value: final episodes):
                              return GridView.builder(
                                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0, bottom: 12.0),
                                itemCount: episodes.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 8.0,
                                  mainAxisSpacing: 8.0,
                                  crossAxisCount: 3,
                                  childAspectRatio: 3 / 3,
                                ),
                                itemBuilder: (context, index) {
                                  return AnimationConfiguration.staggeredGrid(
                                    position: index,
                                    duration: const Duration(milliseconds: 375),
                                    columnCount: 3,
                                    child: ScaleAnimation(
                                      child: FadeInAnimation(
                                        child: Card(
                                          margin: const EdgeInsets.all(4.0),
                                          color: Colors.white.withAlpha(166),
                                          elevation: 10.0,
                                          shadowColor: Colors.black,
                                          child: Container(
                                            margin: const EdgeInsets.all(12.0),
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  episodes[index].episode,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                    shadows: [
                                                      Shadow(
                                                        offset: Offset(2.0, 2.0),
                                                        blurRadius: 3.0,
                                                        color: Color.fromARGB(255, 240, 240, 240),
                                                      ),
                                                    ],
                                                  )
                                                ),
                                                Text(
                                                  episodes[index].airDate,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w300,
                                                    shadows: [
                                                      Shadow(
                                                        offset: Offset(2.0, 2.0),
                                                        blurRadius: 3.0,
                                                        color: Color.fromARGB(255, 240, 240, 240),
                                                      ),
                                                    ],
                                                  )
                                                ),
                                              ],
                                            ),
                                          )
                                        )
                                      ),
                                    ),
                                  );
                                }
                              );
                              
                            case Failure():
                              return _messageWidget();
                          }

                        } else if (snapshot.hasError) {
                          return _messageWidget();
                        }

                        return const Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );

                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
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