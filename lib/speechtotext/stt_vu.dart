import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:stacked/stacked.dart';
import 'package:voice_recognition/speechtotext/stt_vm.dart';

class SpeechToTextScreen extends ViewModelBuilderWidget<SpeechToTextViewModel> {
  const SpeechToTextScreen({super.key});

  @override
  Widget builder(
      BuildContext context, SpeechToTextViewModel viewModel, Widget? child) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Speech to Text Example'),
        ),
        body: Column(children: [
          Container(
            child: Column(
              children: <Widget>[
                InitSpeechWidget(
                    viewModel.hasSpeech, viewModel.initSpeechState),
                SpeechControlWidget(
                    viewModel.hasSpeech,
                    viewModel.speech.isListening,
                    viewModel.startListening,
                    viewModel.stopListening,
                    viewModel.cancelListening),
                SessionOptionsWidget(
                  viewModel.currentLocaleId,
                  viewModel.switchLang,
                  viewModel.localeNames,
                  viewModel.logEvents,
                  viewModel.switchLogging,
                  viewModel.pauseForController,
                  viewModel.listenForController,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: RecognitionResultsWidget(
                lastWords: viewModel.lastWords, level: viewModel.level),
          ),
          SpeechStatusWidget(speech: viewModel.speech),
        ]),
      ),
    );
  }

  @override
  SpeechToTextViewModel viewModelBuilder(BuildContext context) {
    return SpeechToTextViewModel();
  }
}

class RecognitionResultsWidget extends StatelessWidget {
  const RecognitionResultsWidget({
    Key? key,
    required this.lastWords,
    required this.level,
  }) : super(key: key);

  final String lastWords;
  final double level;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: Text(
            'Recognized Words',
            style: TextStyle(fontSize: 22.0),
          ),
        ),
        Expanded(
          child: Stack(
            children: <Widget>[
              Container(
                color: Theme.of(context).selectedRowColor,
                child: Center(
                  child: Text(
                    lastWords,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Positioned.fill(
                bottom: 10,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: .26,
                            spreadRadius: level * 1.5,
                            color: Colors.black.withOpacity(.05))
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.mic),
                      onPressed: () => null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SpeechControlWidget extends StatelessWidget {
  const SpeechControlWidget(this.hasSpeech, this.isListening,
      this.startListening, this.stopListening, this.cancelListening,
      {Key? key})
      : super(key: key);

  final bool hasSpeech;
  final bool isListening;
  final void Function() startListening;
  final void Function() stopListening;
  final void Function() cancelListening;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        TextButton(
          onPressed: !hasSpeech || isListening ? null : startListening,
          child: Text('Start'),
        ),
        TextButton(
          onPressed: isListening ? stopListening : null,
          child: Text('Stop'),
        ),
        TextButton(
          onPressed: isListening ? cancelListening : null,
          child: Text('Cancel'),
        )
      ],
    );
  }
}

class SessionOptionsWidget extends StatelessWidget {
  const SessionOptionsWidget(
      this.currentLocaleId,
      this.switchLang,
      this.localeNames,
      this.logEvents,
      this.switchLogging,
      this.pauseForController,
      this.listenForController,
      {Key? key})
      : super(key: key);

  final String currentLocaleId;
  final void Function(String?) switchLang;
  final void Function(bool?) switchLogging;
  final TextEditingController pauseForController;
  final TextEditingController listenForController;
  final List<LocaleName> localeNames;
  final bool logEvents;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Row(
          //   children: [
          // Text('Language: '),
          // DropdownButton<String>(
          //   onChanged: (selectedVal) => switchLang(selectedVal),
          //   value: currentLocaleId,
          //   items: localeNames
          //       .map(
          //         (localeName) => DropdownMenuItem(
          //           value: localeName.localeId,
          //           child: Text(localeName.name),
          //         ),
          //       )
          //       .toList(),
          // ),
          //   ],
          // ),
          // Row(
          //   children: [
          //     Text('pauseFor: '),
          //     Container(
          //         padding: EdgeInsets.only(left: 8),
          //         width: 80,
          //         child: TextFormField(
          //           controller: pauseForController,
          //         )),
          //     Container(
          //         padding: EdgeInsets.only(left: 16),
          //         child: Text('listenFor: ')),
          //     Container(
          //         padding: EdgeInsets.only(left: 8),
          //         width: 80,
          //         child: TextFormField(
          //           controller: listenForController,
          //         )),
          //   ],
          // ),
          // Row(
          //   children: [
          //     Text('Log events: '),
          //     Checkbox(
          //       value: logEvents,
          //       onChanged: switchLogging,
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}

class InitSpeechWidget extends StatelessWidget {
  const InitSpeechWidget(this.hasSpeech, this.initSpeechState, {Key? key})
      : super(key: key);

  final bool hasSpeech;
  final Future<void> Function() initSpeechState;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        TextButton(
          onPressed: hasSpeech ? null : initSpeechState,
          child: Text('Initialize'),
        ),
      ],
    );
  }
}

/// Display the current status of the listener
class SpeechStatusWidget extends StatelessWidget {
  const SpeechStatusWidget({
    Key? key,
    required this.speech,
  }) : super(key: key);

  final SpeechToText speech;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      color: Theme.of(context).backgroundColor,
      child: Center(
        child: speech.isListening
            ? Text(
                "I'm listening...",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            : Text(
                'Not listening',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
