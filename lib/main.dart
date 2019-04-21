import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import 'package:http/io_client.dart';
import 'dart:io';
void main() => runApp( MaterialApp( home:SplashPage() ) );

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      backgroundColor: Colors.black,
      title: Text("Quran Player", style:TextStyle(color: Colors.white)),
      seconds:3,
      navigateAfterSeconds: MainPage(),
    );
  }
}
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> {

  bool isPLaying = false;
  bool isLoaded= false;
  bool isLoading = false;
  var list;
  AudioPlayer audioPlayer;
  var currentPlaying;

  @override
  void initState() {
    super.initState();
    audioPlayer = new AudioPlayer();
    request();
  }
  Widget controls (){
    return Container(
      height: 50.0,
      padding: EdgeInsets.all(2.0),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: !isPLaying ? Icon(Icons.play_circle_outline): Icon(Icons.pause_circle_outline),
            onPressed: () => playpause(),
          ),
          Container(width: 100.0,),
          Text(currentPlaying["Sora"])

        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Quran Reader"),
      ),
      body: !isLoading ? Center(child: CircularProgressIndicator()): ListView.builder(
        itemCount: !isLoading?0:list.length,
        itemBuilder: (context, i){
          return Container(
            margin: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.greenAccent[200],
              borderRadius: BorderRadius.all(Radius.elliptical(20, 40))
            ),
            child: ListTile(
              title: Text(list[i]["Sora"], textAlign: TextAlign.end,),
              onTap: () => load(i)
            ),
          );
        },
      ),
      bottomNavigationBar: !isLoaded ? null: controls(),
    );
  }
  void load(i) async{
    setState(() {
      currentPlaying = list[i];
    });
    await audioPlayer.play(list[i]["link"]);
    setState(() {
      isLoaded = true; 
      isPLaying = true;
    });
  }
  void playpause()async{
    if(isPLaying){
      await audioPlayer.pause();
      setState(() {
        isPLaying = false; 
      });
    } else {
      await audioPlayer.resume();
      setState(() {
        isPLaying = true; 
      });
    }
  }
  @override
  void dispose() {
    super.dispose();
    audioPlayer.stop();
    setState(() {
      isPLaying = false;
    });
    
  }
  void request () async {
    var c = HttpClient()
    ..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    var i = IOClient(c);
    var a = await i.post("https://mostafagad9090.000webhostapp.com/QuranService/GetQuran.php",body: {"reader_id":"2"});
    var b = jsonDecode(a.body);
    print(b);
    list = b;
    setState(() {
      isLoading=true; 
    });
  }

}