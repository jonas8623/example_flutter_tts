import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

// Verificar o estado do Tts
enum TtsState { playng, stopped, paused, continued }

class _HomePageState extends State<HomePage> {

  FlutterTts flutterTts = FlutterTts();
  TtsState? ttsState;
  double volume = 0.5;
  
  Widget _rowField() {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Digite aqui o que você quer reproduzir',
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(),
          ),
          textAlign: TextAlign.center,
          onSubmitted: (text) => _speak(text),
        ),
    );
  }

  Widget _rowVolume() {
    return Slider(
        value: volume,
        label: 'Volume $volume',
        min: 0.0,
        max: 1.0,
        onChanged: (plus) {
          setState(() {
            volume = plus;
            plus++;
          });
        },
    );
  }

  // Iniciar estado (parado)
  @override
  void initState() {
    super.initState();
    ttsState = TtsState.stopped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exemplo TTS'), backgroundColor: Colors.blue,),
      body: Column(
        children: [
          _rowField(),
          _rowVolume(),
          TextButton(
              onPressed: () => _speak('Parabéns Pedro muitos anos de vida'),
              child: const Text('Falar')
          ),
          TextButton(
              onPressed: () => _stop(),
              child: const Text('Parar de falar')
          ),
        ],
      ),
    );
  }

  // dispose() - Para sair da tela
  @override
  void dispose() {
    super.dispose();
    ttsState = TtsState.stopped;
  }

  Future _speak(String message) async {
    await flutterTts.setVolume(volume); // Alterando o volume
    var result = await flutterTts.speak(message); //  reproduzindo mesnagem
    if(result == 1 ) setState(() => ttsState = TtsState.playng);
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if(result == 1 ) setState(() => ttsState = TtsState.stopped);
  }

}
