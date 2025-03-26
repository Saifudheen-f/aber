import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:espoir_marketing/core/const.dart';
import 'package:espoir_marketing/core/decoration.dart';
import 'package:espoir_marketing/presentation/screens/Task_management/widgets/small_loading.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class AudioPlayerAndUploder extends StatefulWidget {
  final Function(String?) onVoiceUpdated;
  final String? initialVoice;
  final double containerWidth;
  final bool showRemoveButton;

  const AudioPlayerAndUploder({
    Key? key,
    required this.onVoiceUpdated,
    this.initialVoice,
    this.containerWidth = 200,
    this.showRemoveButton = true,
  }) : super(key: key);

  @override
  _AudioPlayerAndUploderState createState() => _AudioPlayerAndUploderState();
}

class _AudioPlayerAndUploderState extends State<AudioPlayerAndUploder> {
  String? voicePath;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isUploading = false;
  bool isLoadingInitialAudio = false;

  @override
  void initState() {
    super.initState();
    voicePath = widget.initialVoice;
    if (voicePath != null) {
      _loadInitialAudio();
    }
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
      });
    });
  }

  Future<void> _loadInitialAudio() async {
    setState(() {
      isLoadingInitialAudio = true;
    });

    // Simulate loading initial audio file (e.g., download from a URL)
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      isLoadingInitialAudio = false;
    });
  }

  Future<void> _pickVoice() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null && result.files.single.path != null) {
      setState(() {
        voicePath = result.files.single.path!;
      });

      // Upload the file to Firebase Storage
      _uploadVoice();
    }
  }

  Future<void> _uploadVoice() async {
    setState(() {
      isUploading = true;
    });

    String fileName = basename(voicePath!);
    Reference storageRef =
        FirebaseStorage.instance.ref().child('voices/$fileName');

    UploadTask uploadTask = storageRef.putFile(File(voicePath!));
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    widget.onVoiceUpdated(downloadURL);

    setState(() {
      isUploading = false;
    });
  }

  void _removeVoice() {
    setState(() {
      voicePath = null;
      isPlaying = false;
    });
    _audioPlayer.stop();
    widget.onVoiceUpdated(null);
  }

  Future<void> _playVoice() async {
    if (voicePath == null) return;

    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(DeviceFileSource(voicePath!));
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (voicePath != null)
          Row(
            children: [
              Expanded(
                child: isUploading || isLoadingInitialAudio
                    ? Padding(
                      padding: const EdgeInsets.only(top: 20,bottom: 20),
                      child: SmallLoading(),
                    )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              "Audio",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: icontheme,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromARGB(255, 230, 225, 222),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text('   Recorded file'),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                      isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: icontheme),
                                  onPressed: _playVoice,
                                ),
                                if (widget.showRemoveButton)
                                  IconButton(
                                    icon: Icon(Icons.close,
                                        color: const Color.fromARGB(
                                            255, 4, 20, 113)),
                                    onPressed: _removeVoice,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        SizedBox(height: 10),
        if (voicePath == null && !isUploading)
          GestureDetector(
            onTap: _pickVoice,
            child: Center(
              child: Container(
                width: widget.containerWidth,
                decoration: BoxDecoration(
                  gradient: gradient,
                  border: Border.all(color: icontheme),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.mic,
                          color: icontheme,
                        ),
                        Text(
                          "select voice",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
