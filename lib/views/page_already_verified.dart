part of 'pages.dart';

class AlreadyVerifiedPage extends StatefulWidget {
  const AlreadyVerifiedPage({Key? key}) : super(key: key);
  static const String routeName = "/alreadyVerified";

  @override
  State<AlreadyVerifiedPage> createState() => _AlreadyVerifiedPageState();
}

class _AlreadyVerifiedPageState extends State<AlreadyVerifiedPage> {
  bool isPlaying = false;
  final confettiController = ConfettiController();

  @override
  void initState() {
    super.initState();
    confettiController.play();
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Congratulations Page'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(24),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network('https://media.giphy.com/media/KeBfPKVHJ3guo1PZOw/giphy.gif', width: 150,),
                  Text("Your email already verified! 🎉", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       isPlaying
                  //           ? confettiController.stop()
                  //           : confettiController.play();
                  //     },
                  //     child: Text(isPlaying ? 'Stop 🥳' : 'Celebrate 🥳')),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: confettiController,
                shouldLoop: true,

                // Set confetti direction
                // blastDirection: pi/2, // down
                blastDirectionality: BlastDirectionality.explosive, //all

                // Set emission count
                emissionFrequency: 0.00,
                numberOfParticles: 75,

                // Set intensity
                minBlastForce: 10,
                maxBlastForce: 100,

                // Set speed
                gravity: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
