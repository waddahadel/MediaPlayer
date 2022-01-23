import 'dart:core';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'homepage.dart';


class RecititionPlayer extends StatefulWidget {

  late String rec_name,rec_reader,pic_url,song_url;




  RecititionPlayer({
    required this.rec_name,required this.rec_reader,required this.pic_url,required this.song_url
});




  @override
  _RecititionPlayerState createState() {
    return _RecititionPlayerState();
  }
}

class _RecititionPlayerState extends State<RecititionPlayer> {
  late AudioPlayer _audio;
  late StreamSubscription<void> _playerSub;

  bool _isPlaying = false;
  bool _isPaused = false;
  Duration ? duration;
  Duration ? position;

  @override
  void initState() {
    super.initState();
    _audio = AudioPlayer(playerId: widget.rec_name);
    _playerSub = _audio.onPlayerCompletion.listen((event) {
      _clearPlayer();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _playerSub.cancel();
    _audio.dispose();
  }

  void _clearPlayer() {
    setState(() {
      _isPlaying = false;
      _isPaused = false;
    });
  }

  Future play() async {
    int result = await _audio.play(widget.song_url);
    if (result == 1) {
      setState(() {
        _isPlaying = true;
      });
    }
  }

  Future pause() async {
    int result = await _audio.pause();
    if (result == 1) {
      setState(() {
        _isPlaying = false;
      });
    }
  }

  Future resume() async {
    int result = await _audio.resume();
    if (result == 1) {
      setState(() {
        _isPlaying = true;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back), onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
            _audio.pause();
            },
            color: Colors.brown,
          ),
        ),
        body: Center(
                    child: Column(
                        children: [
                          SizedBox(height: 40,),
                          Text(widget.rec_name + ' - ' + widget.rec_reader,
                            style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                           ),
                          ),
                          SizedBox(height: 5,),
                          Container(
                              margin: EdgeInsets.only(top: 50),
                              width: 330,
                              height: 330,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                      image: NetworkImage(widget.pic_url),
                                      fit: BoxFit.cover,
                         ),
                        ),
                      ),
                          SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ProgressBar(
                              progressBarColor: Colors.brown,
                              thumbColor: Colors.brown,
                              baseBarColor: Colors.grey,
                              bufferedBarColor: Colors.blueGrey,
                              progress: position ??Duration(milliseconds: 1000),
                              buffered: Duration(milliseconds: 2000),
                              total:    duration ?? Duration(milliseconds: 0),
                              onSeek: (duration) {
                                print('User selected a new time: $duration');
                                _audio.seek(duration);
                              },
                            ),
                          ),

                    IconButton(
                      icon: (_isPlaying)
                          ? Icon(Icons.pause, size: 50,)
                          : Icon(Icons.play_arrow,size: 50,),
                      iconSize: 40,
                      onPressed: () {_isPlaying ? pause() : _isPaused ? resume() : play();
                      _audio.onDurationChanged.listen((Duration d) {
                        print('Max duration: $d');
                        setState(() => duration = d);
                      });
                      _audio.onAudioPositionChanged.listen((Duration  p)  {
                      print('Current position: $p');
                          setState(() => position = p);
                      });
                      },
                    ),

                        ],
                    ),
                  ),),
    );
  }
}
