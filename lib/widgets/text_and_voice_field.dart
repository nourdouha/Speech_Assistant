import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../models/chat_model.dart';
import '../providers/chats_provider.dart';
import '../services/ai_handler.dart';
import '../services/voice_handler.dart';
import 'toggle_button.dart';
import '../services/queries.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/user_chats.dart';

enum InputMode {
  text,
  voice,
}

class TextAndVoiceField extends ConsumerStatefulWidget {
  const TextAndVoiceField({super.key});

  @override
  ConsumerState<TextAndVoiceField> createState() => _TextAndVoiceFieldState();
}

class _TextAndVoiceFieldState extends ConsumerState<TextAndVoiceField> {
  UserFiles userFiles = UserFiles();
  String userId = 'nour';
  InputMode _inputMode = InputMode.voice;
  var _messageController = TextEditingController();
  //final _Palm = Palm;
  final VoiceHandler voiceHandler = VoiceHandler();
  var _isReplying = false;
  var _isListening = false;
  late SpeechToText _speech;

  @override
  void initState() {
    voiceHandler.initSpeech();
    _speech = SpeechToText();
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    //_Palm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            onChanged: (value) {
              value.isNotEmpty
                  ? setInputMode(InputMode.text)
                  : setInputMode(InputMode.voice);
            },
            cursorColor: Theme.of(context).colorScheme.onPrimary,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                borderRadius: BorderRadius.circular(
                  12,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 06,
        ),
        ToggleButton(
          isListening: _isListening,
          isReplying: _isReplying,
          inputMode: _inputMode,
          sendTextMessage: () {
            final message = _messageController.text;
            _messageController.clear();
            sendTextMessage(message);
          },
          sendVoiceMessage: sendVoiceMessage,
        )
      ],
    );
  }

  void setInputMode(InputMode inputMode) {
    setState(() {
      _inputMode = inputMode;
    });
  }

  void sendVoiceMessage() async {
    if (!voiceHandler.isEnabled) {
      print('Not supported');
      return;
    }
    if (voiceHandler.speechToText.isListening) {
      await voiceHandler.stopListening();
      setListeningState(false);
    } else {
      setListeningState(true);
      bool available = await _speech.initialize(
          onStatus: (val) => print('onStatus:$val'),
          onError: (val) => print('onError:$val'));

      if (available) {
        setState(() => setListeningState(true));
        _speech.listen(
          onResult: (val) => setState(() {
            _messageController.text = val.recognizedWords;
          }),
        );
      }
      setListeningState(false);
      //sendTextMessage(result);
    }
    setInputMode(InputMode.text);
  }

  void sendTextMessage(String message) async {
    setReplyingState(true);
    addToChatList(message, true, DateTime.now().toString());
    addToChatList('Typing...', false, 'typing');
    setInputMode(InputMode.voice);

    final aiResponse =
        await getResponse(message); // Use the getResponse function here
    removeTyping();
    addToChatList(aiResponse, false, DateTime.now().toString());

    var command = message.toLowerCase();
    RegExp exp1 = RegExp(r'send (.*?) to (\d+)');
    RegExpMatch? match1 = exp1.firstMatch(command);

    RegExp exp2 = RegExp(r'call (\d+)');
    RegExpMatch? match2 = exp2.firstMatch(command);

    RegExp exp3 = RegExp(r'make note (\d+)');
    RegExpMatch? match3 = exp3.firstMatch(command);

//make a call

    if (match2 != null) {
      await Future.delayed(Duration(seconds: 2), () async {
        String? number = match2.group(1);
        if (number != null) {
          await makePhoneCall(number);
          removeTyping();
          setReplyingState(false);
        } else {
          print('No number found');
        }
      });
      return;
    } else {
      if (command.contains('open music')) {
        await Future.delayed(Duration(seconds: 2), () async {
          openMusicApp();
          removeTyping();
          setReplyingState(false);
        });
        return;
      } else {
        if (command.contains('open weather')) {
          await Future.delayed(Duration(seconds: 2), () async {
            openWeatherApp();
            removeTyping();
            setReplyingState(false);
          });
          return;
        } else {
          if (command.contains('open news')) {
            await Future.delayed(Duration(seconds: 2), () async {
              await openNewsApp();
              removeTyping();
              setReplyingState(false);
            });
            return;
          } else {
            //var command = message.toLowerCase();
            if (match1 != null) {
              await Future.delayed(Duration(seconds: 2), () async {
                String? message = match1.group(1);
                String? number = match1.group(2);
                if (message != null && number != null) {
                  await composeSMS(number, message);
                  removeTyping();
                  setReplyingState(false);
                } else {
                  print('No message or number found');
                }
              });
              return;
            } else {
              //var command = message.toLowerCase();
              if (match3 != null) {
                await Future.delayed(Duration(seconds: 2), () async {
                  String? note = match3.group(1);
                  if (note != null) {
                    await openNoteTakingApp(note);
                    removeTyping();
                    setReplyingState(false);
                  } else {
                    print('No message or number found');
                  }
                });
                return;
              }
            }
          }
        }
      }
    }
    setReplyingState(false);
  }

  //open music openMusicApp()

  void setReplyingState(bool isReplying) {
    setState(() {
      _isReplying = isReplying;
    });
  }

  void setListeningState(bool isListening) {
    setState(() {
      _isListening = isListening;
    });
  }

  void removeTyping() {
    final chats = ref.read(chatsProvider.notifier);
    chats.removeTyping();
  }

  void addToChatList(String message, bool isMe, String id) async {
    // Add the message to Firestore
    await userFiles.addMessageToUserChat(userId, message, true);

    // Add the message to the local chat list
    final chats = ref.read(chatsProvider.notifier);
    chats.add(ChatModel(
      id: id,
      message: message,
      isMe: isMe,
    ));

    // Get the updated stream of chat messages
    Stream<QuerySnapshot> chatsStream = userFiles.getUserChats(userId);
  }
}
