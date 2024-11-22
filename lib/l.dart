import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late AudioPlayer player;

  // Game state variables
  double balance = 100.0;
  double betAmount = 10.0;
  int mineCount = 3;
  int gridSize = 25; // 5x5 grid
  double cashOutMultiplier = 1.0;
  bool isAutoMode = false;
  Timer? autoRevealTimer;

  // Dictionary for multipliers based on the number of mines
  Map<int, List<double>> multipliersAllMines = {};

  // Initialize fields with empty lists to avoid late initialization errors
  List<bool> minePositions = List.generate(25, (_) => false);
  List<bool> revealedTiles = List.generate(25, (_) => false);
  bool gameStarted = false;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeGame();
    });
    _generateMultipliers();
  }

  @override
  void dispose() {
    autoRevealTimer?.cancel();
    super.dispose();
  }

  // Generate multipliers based on mine count
  void _generateMultipliers() {
    List<double> baseMultipliers = [
      1.09,
      1.25,
      1.43,
      1.66,
      1.94,
      2.28,
      2.71,
      3.25,
      3.95,
      4.85,
      6.07,
      7.72,
      7.72,
      10,
      13.38,
      18.4,
      26.29,
      39.43,
      63.10,
      110.4,
      220.8,
      552,
      2208
    ];
    int totalBoxes = gridSize;

    for (int mineCount = 3; mineCount <= 24; mineCount++) {
      int safeBoxes = totalBoxes - mineCount;
      double scalingFactor = (totalBoxes - 3) / safeBoxes;
      List<double> multipliersCurrent = baseMultipliers
          .map((multiplier) =>
              double.parse((multiplier * scalingFactor).toStringAsFixed(2)))
          .toList();
      multipliersAllMines[mineCount] = multipliersCurrent;
    }
  }

  void _initializeGame() {
    setState(() {
      minePositions = List.generate(gridSize, (_) => false);
      revealedTiles = List.generate(gridSize, (_) => false);
      cashOutMultiplier = 1.0;
      _placeMines();
    });
  }

  void _placeMines() {
    Random random = Random();
    int minesPlaced = 0;
    while (minesPlaced < mineCount) {
      int position = random.nextInt(gridSize);
      if (!minePositions[position]) {
        minePositions[position] = true;
        minesPlaced++;
      }
    }
  }

  void _startGame() {
    if (balance < betAmount) {
      _showLowBalanceAlert();
    } else {
      setState(() {
        gameStarted = true;
        balance -= betAmount;
        _initializeGame();
      });
      if (isAutoMode) {
        _startAutoReveal();
      }
    }
  }

  void _startAutoReveal() {
    autoRevealTimer?.cancel();
    autoRevealTimer = Timer.periodic(Duration(seconds: 1), (_) {
      int randomIndex = Random().nextInt(gridSize);
      if (!revealedTiles[randomIndex]) {
        _revealTile(randomIndex);
      }
    });
  }

// Future<void> playAudioFromAssets() async {
//     try {
//       // Load the audio file from assets
//       final bytes = await rootBundle.load('Assets/win.mp3');
//       final audioBytes = bytes.buffer.asUint8List();

//       // Load and play the audio from buffer
//       await player.setAudioSource(ConcatenatingAudioSource(
//         children: [
//           AudioSource.uri(Uri.parse('data:Assets/win.mp3;base64,${base64Encode(audioBytes)}'))
//         ],
//       ),initialPosition: Duration(seconds: 4));
//       // await player.setLoopMode(LoopMode.one);
//       player.play();
//     } catch (e) {
//       print("Error loading or playing audio: $e");
//     }
//   }
  Future<void> playAudioFromAssets(String assetPath) async {
    try {
      await player
          .setAsset(assetPath); // Set the audio source from assets directly
      player.play(); // Play the audio
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  void _revealTile(int index) {
    if (!gameStarted || revealedTiles[index]) return;

    setState(() {
      revealedTiles[index] = true;
      int revealedCount = revealedTiles.where((tile) => tile).length;

      // Select the correct multiplier list based on the current mine count
      List<double> selectedMultipliers = multipliersAllMines[mineCount] ?? [];

      if (revealedCount <= selectedMultipliers.length) {
        cashOutMultiplier = selectedMultipliers[revealedCount - 1];
      } else {
        cashOutMultiplier = selectedMultipliers.last;
      }

      if (minePositions[index]) {
        _revealMineInstantly(index);
        Future.delayed(Duration(seconds: 1), _revealAllMines);
        _endGame(false);
        playAudioFromAssets(
            'assets/loose.mp3'); // Play lose sound on mine click
      } else {
        playAudioFromAssets(
            'assets/winsound.mp3'); // Play win sound on safe box open
      }
    });
  }

  void _cashOut() {
    if (gameStarted) {
      setState(() {
        double cashoutAmount = betAmount * cashOutMultiplier;
        balance += cashoutAmount;
        gameStarted = false;
        _showCashoutAlert(cashoutAmount);
      });
      autoRevealTimer?.cancel();
      _revealAllMines(); // Reveal all mines instantly when cashing out
      _clearBoardAfterDelay();
    }
  }

  void _endGame(bool win) {
    setState(() {
      gameStarted = false;
      if (win) {
        balance += betAmount * 2;
      }
    });
    autoRevealTimer?.cancel();
    _clearBoardAfterDelay();
  }

  void _clearBoardAfterDelay() {
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        revealedTiles = List.generate(gridSize, (_) => false);
      });
    });
  }

  void _showLowBalanceAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Insufficient Balance'),
        content: Text('Your balance is too low to place this bet.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

void _showCashoutAlert(double cashoutAmount) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Center(
      child: Container(
        width: 100,
        height: 100,
       decoration: BoxDecoration(
              shape: BoxShape.circle, // Circular shape
                          
                       
          image: DecorationImage(
            image: AssetImage("assets/con.jpg"), // Image location
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              const Color.fromARGB(255, 244, 209, 54)
                  .withOpacity(0.9), // Color overlay with opacity
              BlendMode.dstATop, // Blending mode
            ), // Fills the screen
          ),
        ),
        padding: EdgeInsets.all(10),
        child: Text(
          '₹${cashoutAmount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
   color:  Colors.black,        ),
        ),
      ),
    ),
  );

  // Insert the overlay entry
  overlay.insert(overlayEntry);

  // Remove the overlay entry after 2 seconds
  Future.delayed(Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}



  void _updateBetAmount(double change) {
    setState(() {
      betAmount = (betAmount + change).clamp(5.0, balance);
    });
  }

  void _addFunds(double amount) {
    setState(() {
      balance += amount;
    });
  }

  void _withdrawFunds(double amount) {
    if (balance >= amount) {
      setState(() {
        balance -= amount;
      });
    } else {
      _showLowBalanceAlert();
    }
  }

  void _increaseMineCount() {
    setState(() {
      if (mineCount < gridSize) mineCount++;
    });
  }

  void _decreaseMineCount() {
    setState(() {
      if (mineCount > 2) mineCount--; // Ensure minimum is 2
    });
  }

  void _revealMineInstantly(int index) {
    setState(() {
      revealedTiles[index] = true; // Reveal the clicked mine instantly
    });
  }

  void _revealAllMines() {
    setState(() {
      for (int i = 0; i < gridSize; i++) {
        if (minePositions[i]) {
          revealedTiles[i] = true; // Reveal all mines
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate potential next cashout based on the next multiplier in the list, if available
    List<double> selectedMultipliers = multipliersAllMines[mineCount] ?? [];
    int revealedCount = revealedTiles.where((tile) => tile).length;
    double nextMultiplier = (revealedCount < selectedMultipliers.length)
        ? selectedMultipliers[revealedCount]
        : cashOutMultiplier; // Use current multiplier if no further increments

    double potentialCashout = betAmount * nextMultiplier;

    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          Text('Mines Game'),
          Text('        Balance: ₹${balance.toStringAsFixed(2)}'),
        ],
      )),
      body: Container(
        decoration: BoxDecoration(
          
          image: DecorationImage(
            image: AssetImage("assets/back.avif"), // Image location
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              const Color.fromARGB(255, 244, 209, 54)
                  .withOpacity(0.8), // Color overlay with opacity
              BlendMode.dstATop, // Blending mode
            ), // Fills the screen
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 234, 119, 18),
                  // borderRadius: BorderRadius.circular(11),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26, // Shadow color
                      blurRadius: 10.0, // Softness of the shadow
                      offset: Offset(4, 4), // Position of the shadow (x, y)
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 234, 119, 18),
                          // borderRadius: BorderRadius.circular(11),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26, // Shadow color
                              blurRadius: 10.0, // Softness of the shadow
                              offset:
                                  Offset(4, 4), // Position of the shadow (x, y)
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                Text('Mines: '),
                                Text(
                                  '$mineCount ',
                                  style: TextStyle(fontSize: 20),
                                )
                              ],
                            ),
                            IconButton(
                              icon: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white, // Background color
                                  shape: BoxShape.circle, // Circular shape
                                ),
                                padding: EdgeInsets.all(
                                    2), // Space around the icon inside the circle
                                child: Icon(
                                  Icons.add,
                                  color: Colors.black, // Icon color
                                ),
                              ),
                              onPressed:
                                  gameStarted ? null : _increaseMineCount,
                            ),
                            IconButton(
                              icon: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white, // Background color
                                  shape: BoxShape.circle, // Circular shape
                                ),
                                padding: EdgeInsets.all(
                                    2), // Space around the icon inside the circle
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.black, // Icon color
                                ),
                              ),
                              onPressed:
                                  gameStarted ? null : _decreaseMineCount,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text('  Bet Amount:'),
                          Text(
                            '₹${betAmount.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                      IconButton(
                        icon: Container(
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color
                            shape: BoxShape.circle, // Circular shape
                          ),
                          padding: EdgeInsets.all(
                              2), // Space around the icon inside the circle
                          child: Icon(
                            Icons.add,
                            color: Colors.black, // Icon color
                          ),
                        ),
                        onPressed:
                            gameStarted ? null : () => _updateBetAmount(1.0),
                      ),
                      IconButton(
                        icon: Container(
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color
                            shape: BoxShape.circle, // Circular shape
                          ),
                          padding: EdgeInsets.all(
                              2), // Space around the icon inside the circle
                          child: Icon(
                            Icons.remove,
                            color: Colors.black, // Icon color
                          ),
                        ),
                        onPressed:
                            gameStarted ? null : () => _updateBetAmount(-1.0),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemCount: gridSize,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _revealTile(index),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: revealedTiles[index]
                                ? (minePositions[index]
                                    ? Colors.red
                                    : Color.fromARGB(255, 144, 215, 63))
                                : const Color.fromARGB(255, 239, 212, 140),
                            borderRadius: BorderRadius.circular(11),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26, // Shadow color
                                blurRadius: 10.0, // Softness of the shadow
                                offset: Offset(
                                    4, 4), // Position of the shadow (x, y)
                              ),
                            ],
                          ),
                          child: Center(
                            child: revealedTiles[index]
                                ? (minePositions[index]
                                    ? Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(0)),
                                        child: Image.asset(
                                          'assets/bomb.png',
                                          fit: BoxFit.contain,
                                        )) // Show bomb if it's a mine
                                    : Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/diamond.png')),
                                          borderRadius: BorderRadius.circular(
                                              12), // Apply border radius
                                          // border: Border.all(color: Colors.white, width: 2), // Optional border for better visibility
                                        ),

                                        // child: Image.asset('Images/diamond.jpg', fit: BoxFit.cover)
                                      )) // Show diamond if it's not a mine
                                : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (gameStarted)
                Card(
                  color:      Color.fromARGB(255, 234, 119, 18), // Background color,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 69, 223, 23), // Background color
                      ),
                          onPressed: _cashOut,
                          child: Text(
                              'Cashout (x${cashOutMultiplier.toStringAsFixed(2)}) - ₹${(betAmount * cashOutMultiplier).toStringAsFixed(2)}'),
                        ),
                        Text(
                            '  Potential Next Cashout: ₹${potentialCashout.toStringAsFixed(2)}  '),
                      ],
                    ),
                  ),
                ),
              Container(
                decoration: BoxDecoration(
                  // color: const Color.fromARGB(255, 193, 204, 212),
                  // borderRadius: BorderRadius.circular(11),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                          66, 255, 255, 255), // Shadow color
                      blurRadius: 20.0, // Softness of the shadow
                      offset: Offset(4, 4), // Position of the shadow (x, y)
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Switch(
                        value: isAutoMode,
                        onChanged: (value) {
                          setState(() {
                            isAutoMode = value;
                          });
                        },
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.grey,
                      ),
                      Text(isAutoMode ? 'Auto' : 'Manual'),
                      SizedBox(
                        width: 10,
                      ),
                  ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: gameStarted 
        ? Color.fromARGB(255, 69, 223, 23) // Cashout button color
        : Color.fromARGB(255, 234, 119, 18), // Start Game button color
  ),
  onPressed: gameStarted ? _cashOut : _startGame,
  child: Text(
    gameStarted 
      ? 'Cashout (x${cashOutMultiplier.toStringAsFixed(2)}) - ₹${(betAmount * cashOutMultiplier).toStringAsFixed(2)}'
      : 'Start Game'
  ),
),


                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}