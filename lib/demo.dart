import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

import 'package:just_audio/just_audio.dart';

class Demo extends StatefulWidget {
  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  late AudioPlayer player;

  double balance = 100;
  double betAmount = 10.0;
  int mineCount = 3;
  int gridSize = 25; // 5x5 grid
  double cashOutMultiplier = 1.0;
  bool isAutoMode = false;
  Timer? autoRevealTimer;

  Map<int, List<double>> multipliersAllMines = {};

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
      10.0,
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
    });
  }

  void _placeMines(int safeTileCount) {
    Random random = Random();
    int minesPlaced = 0;

    List<int> safeTiles = revealedTiles
        .asMap()
        .entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (safeTiles.length < safeTileCount) return;

    while (minesPlaced < mineCount) {
      int position = random.nextInt(gridSize);
      if (!minePositions[position] && !safeTiles.contains(position)) {
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
      await player.setAsset(assetPath);
      player.play();
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  void _revealTile(int index) {
    if (!gameStarted || revealedTiles[index]) return;

    setState(() {
      revealedTiles[index] = true;
      int revealedCount = revealedTiles.where((tile) => tile).length;

      if (!minePositions.contains(true) && revealedCount >= 5) {
        _placeMines(5);
      }

      if (minePositions[index]) {
        _revealMineInstantly(index);
        Future.delayed(Duration(seconds: 1), _revealAllMines);
        _endGame(false);
        playAudioFromAssets('Assets/loose.mp3');
      } else {
        List<double> selectedMultipliers = multipliersAllMines[mineCount] ?? [];
        if (revealedCount <= selectedMultipliers.length) {
          cashOutMultiplier = selectedMultipliers[revealedCount - 1];
        } else {
          cashOutMultiplier = selectedMultipliers.last;
        }
        playAudioFromAssets('Assets/winsound.mp3');
      }
    });
  }

  Future<void> _cashOut() async {
    if (gameStarted) {
      setState(() {
        if (!minePositions.contains(true)) {
          _placeMines(5);
        }
        double cashoutAmount = betAmount * cashOutMultiplier;
        balance += cashoutAmount;
        gameStarted = false;
        _showCashoutAlert(cashoutAmount);
      });
      autoRevealTimer?.cancel();
      _revealAllMines();
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        title: Row(
          children: [
            Icon(Icons.wallet_outlined, color: Colors.orange),
            SizedBox(width: 10),
            Text('Low Balance', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content:
            Text('Please add funds to Play.', style: TextStyle(fontSize: 16)),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/addFunds');
            },
            child: Text('Add Funds', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showCashoutAlert(double cashoutAmount) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: Card(
          color: Colors.green,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '🎊Win ₹${cashoutAmount.toStringAsFixed(2)}',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

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

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 234, 119, 18),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Card(
                    color: Color.fromARGB(255, 0, 0, 0),
                    // Space around the icon inside the circle
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Balance:  ₹${balance.toStringAsFixed(1)} ',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                onPressed: gameStarted ? null : _increaseMineCount,
              ),
              IconButton(
                  icon: Card(
                      color: Color.fromARGB(255, 0, 0, 0),
                      // Space around the icon inside the circle
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          ' Demo 🟢',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                  onPressed: () => null),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("Assets/back.avif"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                BlendMode.screen,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
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
                SizedBox(
                  height: 15,
                ),

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
                IconButton(
              
                  icon: Card(
                      color:gameStarted
                                  ? Color.fromARGB(255, 0, 0, 0) // Cashout button color
                                  : Color.fromARGB(255, 234, 119,
                                      18), 
                      // Space around the icon inside the circle
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                        child: Text(
                          gameStarted
                              ? '✅ Cash Out    ₹${(betAmount * cashOutMultiplier).toStringAsFixed(2)} '
                              : 'Start Game',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                  onPressed: gameStarted ? _cashOut : _startGame,
                ),
                //  SizedBox(
                //           width: 290,
                //           height: 45,
                //           child: IconButton(
                //             style: IconButton.styleFrom(
                //               backgroundColor: gameStarted
                //                   ? Color.fromARGB(
                //                       255, 3, 0, 184) // Cashout button color
                //                   : Color.fromARGB(255, 234, 119,
                //                       18), // Start Game button color
                //             ),
                //             onPressed: gameStarted ? _cashOut : _startGame,
                //             icon: Text(
                //               style: TextStyle(
                //                 fontSize: 20,
                //                 fontWeight: FontWeight.bold,
                //                 color: Color.fromARGB(255, 255, 255, 255),
                //               ),
                //               gameStarted
                //                   ? 'Cash Out   ₹${(betAmount * cashOutMultiplier).toStringAsFixed(2)}'
                //                   : 'Start Game',
                //             ),
                //           ),
                //         ),
                SizedBox(
                  height: 10,
                ),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
