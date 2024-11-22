import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

class Demo extends StatefulWidget {
  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  late AudioPlayer player;

  // Game state variables
  double balance = 100;
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
    // balance=ballance?.get('ballance');
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

  Future<void> playAudioFromAssets(String assetPath) async {
    try {
      await player
          .setAsset(assetPath); // Set the audio source from Assets directly
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
            'Assets/loose.mp3'); // Play lose sound on mine click
      } else {
        playAudioFromAssets(
            'Assets/winsound.mp3'); // Play win sound on safe box open
      }
    });
  }

  Future<void> _cashOut() async {
    // double cashoutAmount = betAmount * cashOutMultiplier;

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
        // backgroundColor: Colors.white10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: Row(
          children: [
            Icon(
              Icons.wallet_outlined,
              color: const Color.fromARGB(255, 234, 119, 18),
            ),
            SizedBox(width: 10),
            Text('Low Balance', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Please add funds to Play.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 234, 119, 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              Navigator.pushNamed(
                  context, '/addFunds'); // Redirect to Add Funds page
              setState(() {
                _updateBetAmount(balance);
              });
            },
            child: Text('Add Funds', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () {
              Navigator.pop(context); // Just close the dialog
              setState(() {
                _updateBetAmount(balance);
              });
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );

    setState(() {
      _updateBetAmount(balance);
    });
  }

  void _showCashoutAlert(double cashoutAmount) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '🎊Win ₹${cashoutAmount.toStringAsFixed(2)}🎊🎉',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
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
    // Calculate next multiplier based on revealed tiles
    List<double> selectedMultipliers = multipliersAllMines[mineCount] ?? [];
    int revealedCount = revealedTiles.where((tile) => tile).length;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Balance: ₹${balance.toStringAsFixed(2)}'),
      // ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("Assets/back.avif"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              const Color.fromARGB(255, 207, 126, 44).withOpacity(0.9),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Card(
                        color: Color.fromARGB(255, 235, 161, 0),
                        // Space around the icon inside the circle
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Balance:  ₹${balance.toStringAsFixed(1)} ',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    onPressed: gameStarted ? null : _increaseMineCount,
                  ),
                  IconButton(
                      icon: Card(
                          color: Color.fromARGB(255, 235, 161, 0),
                          // Space around the icon inside the circle
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Go Back ',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                      onPressed: () => Navigator.pop(context)),
                ],
              ),
              // Horizontal scrollable multiplier display
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: selectedMultipliers.asMap().entries.map((entry) {
                    int index = entry.key;
                    double multiplier = entry.value;
                    bool isNext =
                        index == revealedCount; // Highlight next multiplier

                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 17),
                      decoration: BoxDecoration(
                        color: isNext ? Colors.orange : Colors.black,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange, width: 1.5),
                      ),
                      child: Text(
                        'x${multiplier.toStringAsFixed(2)} \n ₹${(multiplier * betAmount).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: isNext ? Colors.black : Colors.orange,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              // SizedBox(height: 5), // Space between multipliers and grid
              Expanded(
                // flex: 3,
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
                                : const Color.fromARGB(255, 225, 208, 161),
                            borderRadius: BorderRadius.circular(11),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10.0,
                                offset: Offset(10, 100),
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
                                          'Assets/bomb.png',
                                          fit: BoxFit.contain,
                                        ))
                                    : Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'Assets/diamond.png')),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ))
                                : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // SizedBox(height: 100,),
              Container(
                // padding: EdgeInsets.only(top: 10),
                // width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
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
                  padding: const EdgeInsets.all(6),
                  child: Row(
                    children: [
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
                      Column(
                        children: [
                          Text('Bet Amount:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            '₹${betAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              '10',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        onPressed:
                            gameStarted ? null : () => _updateBetAmount(10.0),
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
                        onPressed: gameStarted ? null : _decreaseMineCount,
                      ),
                      Column(
                        children: [
                          Text('Mines: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            '$mineCount ',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                        onPressed: gameStarted ? null : _increaseMineCount,
                      ),

                      //  SizedBox(
                      //    width: 5,
                      //  ),
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
                child: Row(
                  children: [
                    Column(
                      children: [
                        Switch(
                          value: isAutoMode,
                          onChanged: (value) {
                            setState(() {
                              isAutoMode = value;
                            });
                          },
                          activeColor: Color.fromARGB(255, 234, 119, 18),
                          inactiveThumbColor: Colors.grey,
                        ),
                        Text(
                          isAutoMode ? 'Auto' : 'Manual',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 290,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: gameStarted
                              ? Color.fromARGB(
                                  255, 3, 0, 184) // Cashout button color
                              : Color.fromARGB(
                                  255, 234, 119, 18), // Start Game button color
                        ),
                        onPressed: gameStarted ? _cashOut : _startGame,
                        child: Text(
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                          gameStarted
                              ? 'CashOut   ₹${(betAmount * cashOutMultiplier).toStringAsFixed(2)}'
                              : 'Start Game',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
