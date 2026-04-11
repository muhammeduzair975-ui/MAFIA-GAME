import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mafia Game',
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

// ==================== HOME SCREEN ====================
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'MAFIA GAME',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'A Social Deduction Game',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlayerSetupScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(200, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'START GAME',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== PLAYER SETUP SCREEN ====================
class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> players = [];

  void addPlayer() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        players.add(_controller.text);
        _controller.clear();
      });
    }
  }

 void startGame() {
  if (players.length < 4) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Need at least 4 players!')),
    );
    return;
  }

  // Go to Character Selection Screen
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CharacterSelectionScreen(
        players: players,
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Players')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Enter player name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: addPlayer,
              child: const Text('Add Player'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(players[index]),
                      leading: const Icon(Icons.person),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('START GAME', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== CHARACTER SELECTION SCREEN ====================
class CharacterSelectionScreen extends StatefulWidget {
  final List<String> players;

  const CharacterSelectionScreen({super.key, required this.players});

  @override
  State<CharacterSelectionScreen> createState() => _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  bool includeGodfather = false;
  bool includeGrandma = false;
  bool includeJester = false;
int jesterCount = 1;
  bool includeBodyguard = false;
  bool includeGamechanger = false;

  void _startGame() {
    int totalPlayers = widget.players.length;
  if (totalPlayers < 4) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Need at least 4 players!")),
    );
    return;
  }
    
    int killerCount = (totalPlayers * 0.3).floor();  // 👈 Use floor() instead of ceil()
if (killerCount < 1) killerCount = 1;
    
    List<String> roles = [];
    
    if (includeGodfather) {
      roles.add("Godfather");
      for (int i = 0; i < killerCount - 1; i++) {
        roles.add("Killer");
      }
    } else {
      for (int i = 0; i < killerCount; i++) {
        roles.add("Killer");
      }
    }
    
    roles.add("Doctor");
    roles.add("Detective");
    
    if (includeGrandma) roles.add("Grandma");
   
    if (includeBodyguard) roles.add("Bodyguard");
    if (includeGamechanger) roles.add("Gamechanger");
    if (includeJester) {
  for (int i = 0; i < jesterCount; i++) {
    roles.add("Jester");
  }
}
    while (roles.length < totalPlayers) {
      roles.add("Villager");
    }
    
    roles.shuffle();
    
    int actualKillers = roles.where((r) => r == "Killer" || r == "Godfather").length;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("ROLE DISTRIBUTION"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("🔪 Killers: $actualKillers (${(actualKillers / totalPlayers * 100).toInt()}%)"),
            Text("👤 Others: ${totalPlayers - actualKillers} (${((totalPlayers - actualKillers) / totalPlayers * 100).toInt()}%)"),
            const Divider(),
            Text("Total Players: $totalPlayers"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => GameScreen(
      players: widget.players,
      roles: roles,
    ),
  ),
);
            },
            child: const Text("START GAME"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Choose Characters'),
        backgroundColor: Colors.grey[900],
        toolbarHeight: 50,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🎭 CORE CHARACTERS (Always Included)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 8),
              _buildCoreCard("🔪 Killer", "Choose who to kill each night", Colors.red),
              _buildCoreCard("🩺 Doctor", "Save one player each night", Colors.blue),
              _buildCoreCard("👤 Villager", "No special ability, vote matters", Colors.grey),
              _buildCoreCard("🕵️ Detective", "Check if a player is a killer", Colors.purple),
              
              const SizedBox(height: 20),
              const Text(
                '⭐ OPTIONAL CHARACTERS',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
              ),
              const SizedBox(height: 8),
              
              _buildOptionalCard("👑 Godfather", "Leader of killers. Detective cannot find him!", includeGodfather, (v) => setState(() => includeGodfather = v)),
              _buildOptionalCard("👵🔫 Grandma", "If killers target her, the attacker dies!", includeGrandma, (v) => setState(() => includeGrandma = v)),
              _buildJesterCard(),
              _buildOptionalCard("🛡️ Bodyguard", "Becomes Godfather if Godfather dies", includeBodyguard, (v) => setState(() => includeBodyguard = v)),
              _buildOptionalCard("🔄 Gamechanger", "Swap two players - changes who dies", includeGamechanger, (v) => setState(() => includeGamechanger = v)),
              
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: Colors.yellow, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Players: ${widget.players.length}",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _startGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('START GAME', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoreCard(String name, String desc, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(desc, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildOptionalCard(String name, String desc, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(desc, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          Checkbox(
            value: value,
            onChanged: (v) => onChanged(v ?? false),
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }
Widget _buildJesterCard() {
  return Container(
    margin: const EdgeInsets.only(bottom: 6),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.grey[800],
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("🃏 Jester", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const Text("All Jesters eliminated = Jester team wins!", style: TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
            Checkbox(
              value: includeJester,
              onChanged: (v) => setState(() {
                includeJester = v ?? false;
                if (!includeJester) jesterCount = 1;
              }),
              activeColor: Colors.green,
            ),
          ],
        ),
        if (includeJester)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Number of Jesters:", style: TextStyle(fontSize: 13)),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 20),
                      onPressed: jesterCount > 1
                          ? () => setState(() => jesterCount--)
                          : null,
                      constraints: const BoxConstraints(),
                      style: IconButton.styleFrom(padding: const EdgeInsets.all(4)),
                    ),
                    Text(
                      "$jesterCount",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 20),
                      onPressed: jesterCount < 3
                          ? () => setState(() => jesterCount++)
                          : null,
                      constraints: const BoxConstraints(),
                      style: IconButton.styleFrom(padding: const EdgeInsets.all(4)),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    ),
  );
}
}
// ==================== GAME SCREEN ====================
class GameScreen extends StatefulWidget {
  final List<String> players;
  final List<String> roles;
  
  GameScreen({super.key, required this.players, required this.roles});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> alivePlayers = [];
  Map<String, String> playerRoles = {};
Map<String, bool> roleRevealed = {};  
  int currentPlayerIndex = 0;
  int roundNumber = 1;
  bool gameStarted = false;
  List<String> deadThisRound = [];   // 👈 ADD THIS
  List<String> jesters = [];
  
  // Night actions
  String? killerTarget;
  String? doctorTarget;
  String? detectiveTarget;
  List<String> gamechangerSwap = [];
  Map<String, String> killerChoices = {};
  bool killersDone = false;
  
  // Special role tracking
  String? godfather;
  String? bodyguard;
  int doctorSelfSavesLeft = 2;
  String? detectiveResult;
  
  // Results
  String nightResult = "";
  bool gameEnded = false;
  bool showNightActions = false;
  
  // UI state
 
  bool hasSelected = false;
  String? selectedPlayer;
String? villagerGuess;  // For villagers and jester

 @override
void initState() {
  super.initState();
  alivePlayers = List.from(widget.players);
  roleRevealed = {};  // Initialize empty map
  
  for (int i = 0; i < widget.players.length; i++) {
    playerRoles[widget.players[i]] = widget.roles[i];
    if (widget.roles[i] == "Godfather") godfather = widget.players[i];
    if (widget.roles[i] == "Bodyguard") bodyguard = widget.players[i];
if (widget.roles[i] == "Jester") jesters.add(widget.players[i]);
    roleRevealed[widget.players[i]] = false;
  }
} 
  
  void selectTarget(String name) {

 String currentPlayer = alivePlayers[currentPlayerIndex];

    if (!isRoleRevealed(currentPlayer)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Reveal your role first! Tap 👁️")),
    );
    return;
  }

if (hasSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You have already made your selection!")),
      );
      return;
    }
    
    
    String currentRole = playerRoles[currentPlayer]!;
    
    if (name == currentPlayer) {
      if (currentRole != "Doctor" && currentRole != "Gamechanger") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You cannot select yourself!")),
        );
        return;
      }
      if (doctorSelfSavesLeft <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No self-saves left! Save someone else.")),
        );
        return;
      }
    }
    
   if ((currentRole == "Killer" || currentRole == "Godfather") && !killersDone) {
   
  String targetRole = playerRoles[name]!;
  if (targetRole == "Killer" || targetRole == "Godfather") {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("You cannot kill another killer!")),
    );
    return;
  }
if (targetRole == "Bodyguard") {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("You cannot kill the Bodyguard!")),
    );
    return;
  }

  setState(() {
    killerChoices[currentPlayer] = name;
    hasSelected = true;
    selectedPlayer = name;
    
    int killersAlive = 0;
    for (var player in alivePlayers) {
      String role = playerRoles[player]!;
      if (role == "Killer" || role == "Godfather") killersAlive++;
    }
    
    if (killerChoices.length >= killersAlive) {
      Map<String, int> voteCount = {};
      for (var choice in killerChoices.values) {
        voteCount[choice] = (voteCount[choice] ?? 0) + 1;
      }
      
      String? topChoice;
      int maxVotes = 0;
      List<String> topChoices = [];
      
      voteCount.forEach((choice, count) {
        if (count > maxVotes) {
          maxVotes = count;
          topChoice = choice;
          topChoices = [choice];
        } else if (count == maxVotes) {
          topChoices.add(choice);
        }
      });
      
      // Check if there's a tie (all different or multiple with same votes)
    if (killerChoices.length >= killersAlive) {
  Map<String, int> voteCount = {};
  for (var choice in killerChoices.values) {
    voteCount[choice] = (voteCount[choice] ?? 0) + 1;
  }
  
  String? topChoice;
  int maxVotes = 0;
  List<String> topChoices = [];
  
  voteCount.forEach((choice, count) {
    if (count > maxVotes) {
      maxVotes = count;
      topChoice = choice;
      topChoices = [choice];
    } else if (count == maxVotes) {
      topChoices.add(choice);
    }
  });
  
  // Check if there's a tie (all different or multiple with same votes)
  if (topChoices.length > 1) {
    // Godfather decides if alive
    if (godfather != null && alivePlayers.contains(godfather)) {
      // Use Godfather's own choice as the target
      String? godfatherChoice = killerChoices[godfather];
      if (godfatherChoice != null && topChoices.contains(godfatherChoice)) {
        killerTarget = godfatherChoice;
      } else {
        // If Godfather's choice is not in tie, randomly pick from tied players
        killerTarget = topChoices[DateTime.now().millisecond % topChoices.length];
      }
    } else {
      // No Godfather, randomly choose from tied players
      killerTarget = topChoices[DateTime.now().millisecond % topChoices.length];
    }
  } else {
    killerTarget = topChoice;
  }
  
  killersDone = true;
}  
}
  });
  return;
}
    
    setState(() {
      hasSelected = true;
      selectedPlayer = name;
      
      if (currentRole == "Doctor") {
        doctorTarget = name;
        if (name == currentPlayer) {
          doctorSelfSavesLeft--;
        }
      } else if (currentRole == "Detective") {
        detectiveTarget = name;
        String targetRole = playerRoles[name]!;
        if (targetRole == "Killer") {
          detectiveResult = "✅ $name is the KILLER!";
        } else if (targetRole == "Godfather") {
          detectiveResult = "❌ $name is NOT a killer";
        } else {
          detectiveResult = "❌ $name is NOT a killer";
        }
      } 
  
else if (currentRole == "Gamechanger") {
  // Check if player already selected (cannot select same player twice)
  if (gamechangerSwap.contains(name)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("❌ You already selected this player! Choose a different player.")),
    );
    return;
  }
  
  // Add the selected player
  setState(() {
    gamechangerSwap.add(name);
    selectedPlayer = name;
    
    if (gamechangerSwap.length == 2) {
      hasSelected = true;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Both players selected! Press PASS button.")),
      );
    } else {
      hasSelected = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selected 1 player. Choose another player.")),
      );
    }
  });
  return;
}

else {
  // VILLAGER or JESTER
  villagerGuess = name;  // 👈 ADD THIS LINE
  hasSelected = true;
  selectedPlayer = name;
}

    });
  }
  
  void _showGodfatherDecision(List<String> options) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("👑 GODFATHER DECISION"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Killers couldn't agree. Choose who to kill:"),
            const SizedBox(height: 20),
            ...options.map((option) => ListTile(
              title: Text(option),
              onTap: () {
                setState(() {
                  killerTarget = option;
                  killersDone = true;
                });
                Navigator.pop(context);
                _goToNextPlayer();
              },
            )),
          ],
        ),
      ),
    );
  }
  
  void _goToNextPlayer() {
print("Moving to next player. Current index: $currentPlayerIndex");
  print("hasSelected before reset: $hasSelected");
  setState(() {
    currentPlayerIndex++;
    
    // Simply go to next player - no skipping
    if (currentPlayerIndex >= alivePlayers.length) {
      processNightPhase();
    } else {
      hasSelected = false;
      selectedPlayer = null;
      detectiveResult = null;
      villagerGuess = null;
print("hasSelected reset to false for next player");
    }
  });
isProcessing = false;  // Add this
}
  
 bool isProcessing = false;  // Add this with your variables

void nextPlayer() {
  // Prevent double calling
  if (isProcessing) return;
  isProcessing = true;
  String currentPlayer = alivePlayers[currentPlayerIndex];
  String currentRole = playerRoles[currentPlayer]!;
  
  print("nextPlayer called. Current player: $currentPlayer, Role: $currentRole");
  print("hasSelected: $hasSelected, killersDone: $killersDone");
  
  // For Killers and Godfather: they can only pass when all killers have voted OR they have selected
  if ((currentRole == "Killer" || currentRole == "Godfather")) {
    if (killersDone) {
      // All killers have voted, allow pass
      _goToNextPlayer();
      return;
    }
    if (!hasSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a player to kill!")),
      );
      return;
    }
    _goToNextPlayer();
    return;
  }
  
  // For ALL OTHER ROLES (Jester, Villager, Doctor, Detective, Gamechanger, Grandma, Bodyguard)
  // They MUST select before passing
  if (!hasSelected) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please select a player first!")),
    );
    return;
  }
  
  _goToNextPlayer();
}
  
  bool _hasAction(String role) {
  // ALL players have action - villagers also guess
  return true;
  }
  
void processNightPhase() {
 deadThisRound.clear();
  String result = "";
  String? actualTarget = killerTarget;
  bool killerSucceeded = false;
  bool doctorSucceeded = false;
  bool detectiveSucceeded = false;
  String? deadPlayer;
 bool grandmaKilledAttacker = false;
String? grandmaAttacker;
bool doctorSaved = false;

  // Check Grandma with Gun
  if (killerTarget != null && playerRoles[killerTarget] == "Grandma") {
    // The KILLER (who attacked) should die, NOT the Grandma
    // We need to find who attacked Grandma
    // The attacker is the one who chose Grandma as target
    String attacker = killerTarget!;  // This is actually Grandma's name - WRONG!
    
    // Instead, the attacker is the killer who made the choice
    // We need to find which killer selected Grandma
    String? actualAttacker;
    for (var entry in killerChoices.entries) {
      if (entry.value == killerTarget) {
        actualAttacker = entry.key;
        break;
      }
    }
  if (actualAttacker != null) {
grandmaAttacker = actualAttacker;
      // Check if doctor saved the attacker
      if (doctorTarget == actualAttacker) {
        // Doctor saved the attacker, no one dies
        result += "\n";
        doctorSaved = true;
        grandmaKilledAttacker = true;
        actualTarget = null;
        deadPlayer = null;
        killerSucceeded = false;
      } else {
        // Grandma kills the attacker
        result += "\n";
        alivePlayers.remove(actualAttacker);
deadThisRound.add(actualAttacker);
        deadPlayer = actualAttacker;
        actualTarget = null;
        grandmaKilledAttacker = true;
        killerSucceeded = true;
      }
    } else {
      // Fallback: remove the first killer
      String firstKiller = killerChoices.keys.first;
grandmaAttacker = firstKiller;
      if (doctorTarget == firstKiller) {
        result += "\n";
        doctorSaved = true;
        grandmaKilledAttacker = true;
        deadPlayer = null;
      } else {
        result += "\n";
        alivePlayers.remove(firstKiller);
        deadPlayer = firstKiller;
        grandmaKilledAttacker = true;
 deadThisRound.add(firstKiller);
      }
      actualTarget = null;
    }
  }
    
  
  // GAMECHANGER SWAP (affects Killer and Doctor only, NOT Detective)
if (gamechangerSwap.length == 2) {
  String playerA = gamechangerSwap[0];
  String playerB = gamechangerSwap[1];
  bool swapApplied = false;
  
  // 1. Swap killer target
  if (actualTarget == playerA) {
    actualTarget = playerB;
    swapApplied = true;
  } else if (actualTarget == playerB) {
    actualTarget = playerA;
    swapApplied = true;
  }
  
  // 2. Swap doctor target (only if killer swap was applied)
  if (swapApplied) {
    if (doctorTarget == playerA) {
      doctorTarget = playerB;
    } else if (doctorTarget == playerB) {
      doctorTarget = playerA;
    }
  }
  
  // 3. Show message if swap happened
  if (swapApplied) {
    result += "🔄 Gamechanger swapped $playerA ↔ $playerB!\n";
  }
}
  
  // Doctor save
  doctorSaved = (doctorTarget == actualTarget && actualTarget != null);
  
  // Check results
  if (actualTarget != null && !doctorSaved) {
    // Killer succeeded
    killerSucceeded = true;
    deadPlayer = actualTarget;
    alivePlayers.remove(actualTarget);
 deadThisRound.add(actualTarget);

    // Check if Jester was killed at night
    if (playerRoles[actualTarget] == "Jester") {
      jesters.remove(actualTarget);
      if (jesters.isEmpty) {
        result += "🃏 JESTER TEAM WINS! All Jesters eliminated! 🃏\n\n";
        gameEnded = true;
      }
    }
    
    if (actualTarget == godfather) {
      if (bodyguard != null && alivePlayers.contains(bodyguard)) {
        playerRoles[bodyguard!] = "Godfather";
        godfather = bodyguard;
      }
    }
  } else if (doctorSaved) {
    // Doctor succeeded (saved the target)
    doctorSucceeded = true;
  } else if (killerTarget != null) {
    // Killer attacked but no one died (doctor saved someone else)
    killerSucceeded = false;
    doctorSucceeded = false;
  } else {
    // No attack
    killerSucceeded = false;
  }
  
  // Detective result
  if (detectiveTarget != null) {
    String targetRole = playerRoles[detectiveTarget]!;
    if (targetRole == "Godfather") {
      detectiveSucceeded = false;
    } else if (targetRole == "Killer") {
      detectiveSucceeded = true;
    } else {
      detectiveSucceeded = false;
    }
  }
  
    // Build result text
  // 1. Killer result
  if (grandmaKilledAttacker) {
    result += "🔪 Killer succeeded to kill\n";
  } else if (killerSucceeded && deadPlayer != null) {
    result += "🔪 Killer succeeded to kill\n";
  } else if (killerTarget != null) {
    result += "🔪 Killer failed to kill\n";
  } else {
    result += "🔪 No attack happened\n";
  }
   
 // 2. Doctor result
  if (doctorSaved && !grandmaKilledAttacker) {
    result += "🩺 Doctor succeeded to save\n";
  } else if (grandmaKilledAttacker && doctorTarget == grandmaAttacker) {
    result += "🩺 Doctor succeeded to save\n";
  } else if (grandmaKilledAttacker) {
    result += "🩺 Doctor failed to save\n";
  } else if (killerTarget != null && !doctorSaved) {
    result += "🩺 Doctor failed to save\n";
  } else {
    result += "🩺 Doctor failed to save\n";
  }
   
  
  // 3. Detective result
  if (detectiveTarget != null) {
    if (detectiveSucceeded) {
      result += "🕵️ Detective detected correctly\n";
    } else {
      result += "🕵️ Detective detected wrongly\n";
    }
  } else {
    result += "🕵️ Detective detected wrongly\n";
  }
  
  // 4. Dead player name
  if (deadPlayer != null) {
    result += "\n💀 ELIMINATED: $deadPlayer";
  } else {
    result += "\n🛡️ No one was eliminated this round";
  }
  
  // Win check
  int killerCount = 0;
  for (var player in alivePlayers) {
    String role = playerRoles[player]!;
    if (role == "Killer" || role == "Godfather") killerCount++;
  }
  
  if (killerCount == 0) {
    result += "\n\n🏆 VILLAGERS WIN! All killers eliminated! 🏆";
    gameEnded = true;
  } else if (killerCount >= alivePlayers.length - killerCount) {
    result += "\n\n🏆 KILLERS WIN! They have taken control! 🏆";
    gameEnded = true;
  }
  
  nightResult = result;
  setState(() {
    showNightActions = true;
  });
}
  
  void startDiscussion() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiscussionScreen(
          players: widget.players,
          playerRoles: playerRoles,
          alivePlayers: alivePlayers,
          roundNumber: roundNumber,
          nightResult: nightResult,
        ),
      ),
    ).then((_) {
      if (!gameEnded) startVoting();
    });
  }
  
  void startVoting() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => VotingScreen(
        players: widget.players,
        playerRoles: playerRoles,
        alivePlayers: alivePlayers,
        deadThisRound: deadThisRound,
        roundNumber: roundNumber,
        nightResult: nightResult,
        godfather: godfather,
      ),
    ),
  ).then((eliminated) {
    print("=== VOTING RESULT ===");
    print("Eliminated player: $eliminated");
    print("Alive players BEFORE: $alivePlayers");

  // Check if Jester was eliminated
if (eliminated != null && playerRoles[eliminated] == "Jester") {
  jesters.remove(eliminated);
  
  // Check if ALL Jesters are eliminated
  if (jesters.isEmpty) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("🃏 JESTER TEAM WINS!"),
        content: const Text("All Jesters have been eliminated! Jesters win!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            child: const Text("PLAY AGAIN"),
          ),
        ],
      ),
    );
    return;
  }
}
    
    // Remove eliminated player from alivePlayers
    if (eliminated != null && !gameEnded) {
      if (alivePlayers.contains(eliminated)) {
        alivePlayers.remove(eliminated);
        print("Removed $eliminated from alive players");
      }
      print("Alive players AFTER: $alivePlayers");

      // Check if Godfather was eliminated
if (eliminated == godfather) {
  // Check if Bodyguard is alive
  if (bodyguard != null && alivePlayers.contains(bodyguard)) {
    // Bodyguard becomes new Godfather
    playerRoles[bodyguard!] = "Godfather";
    godfather = bodyguard;
    print("${bodyguard!} became the new Godfather!");
    
    // Remove only the eliminated Godfather, not all killers
    alivePlayers.remove(eliminated);
  } else {
    // No Bodyguard, all killers die
    List<String> toRemove = [];
    for (var player in alivePlayers) {
      String role = playerRoles[player]!;
      if (role == "Killer" || role == "Godfather") toRemove.add(player);
    }
    for (var player in toRemove) alivePlayers.remove(player);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("⚡ GODFATHER ELIMINATED!"),
        content: const Text("All killers die immediately! Villagers win!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            child: const Text("PLAY AGAIN"),
          ),
        ],
      ),
    );
    return;
  }
}
}
    
    // Start next round only if game not ended
    if (!gameEnded && alivePlayers.length > 1) {
      setState(() {
        roundNumber++;
        currentPlayerIndex = 0;
        killerTarget = null;
        doctorTarget = null;
        detectiveTarget = null;
        detectiveResult = null;
        gamechangerSwap = [];
        showNightActions = false;
        killersDone = false;
        killerChoices.clear();
        hasSelected = false;
        selectedPlayer = null;
        villagerGuess = null;
        deadThisRound.clear();
        
        for (var player in roleRevealed.keys) {
          roleRevealed[player] = false;
        }
      });
    } else if (!gameEnded && alivePlayers.length <= 1) {
      // Game over - only one player left (killer wins)
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text("🏆 GAME OVER"),
          content: const Text("Killers win! They have eliminated everyone!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              child: const Text("PLAY AGAIN"),
            ),
          ],
        ),
      );
    }
  });
}
  String _getRoleDisplay(String role) {
    switch (role) {
      case "Killer": return "🔪 Killer";
      case "Godfather": return "👑 Godfather";
      case "Doctor": return "🩺 Doctor";
      case "Detective": return "🕵️ Detective";
      case "Gamechanger": return "🔄 Gamechanger";
      case "Grandma": return "👵🔫 Grandma";
      case "Jester": return "🃏 Jester";
      case "Bodyguard": return "🛡️ Bodyguard";
      default: return "👤 Villager";
    }
  }
  
  String _getInstructionText(String role) {
    switch (role) {
      case "Killer": return "🔪 Who do you want to kill?";
      case "Godfather": return "👑 Who do you want to kill?";
      case "Doctor": return "🩺 Who would you choose to save?";
      case "Detective": return "🕵️ Who is the killer? Detect!";
      case "Gamechanger": return "🔄 Choose 2 players to swap";
      case "Grandma": return "👵🔫 You have a gun! If targeted, attacker dies! , Guess the killer?";
      case "Jester": return "🃏 Try to get voted out! , Guess the killer?";
      case "Bodyguard": return "🛡️ You become Godfather if Godfather dies , Guess the killer?";
      default: return "👤 Guess is the killer?";
    }
  }
    bool isRoleRevealed(String player) {
    return roleRevealed.containsKey(player) && roleRevealed[player] == true;
  }
List<String> _getAllKillers() {
  List<String> allKillers = [];
  for (var player in alivePlayers) {
    String role = playerRoles[player]!;
    if (role == "Killer" || role == "Godfather") {
      allKillers.add(player);
    }
  }
  return allKillers;
}

  @override
  Widget build(BuildContext context) {
    // ========== START ROUND SCREEN ==========
    if (!gameStarted) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("MAFIA GAME"),
          toolbarHeight: 50,
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Roles have been assigned!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Pass the phone around to see your role",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "How to play:",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text("1. Tap 👁️ to reveal your role", style: TextStyle(fontSize: 14)),
                        const Text("2. Follow the instruction below", style: TextStyle(fontSize: 14)),
                        const Text("3. Select a player", style: TextStyle(fontSize: 14)),
                        const Text("4. Tap PASS TO NEXT PLAYER", style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        gameStarted = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: const Text(
                      "START ROUND 1",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    
    // ========== NIGHT RESULT SCREEN ==========
    if (showNightActions) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: Text("🌙 Night Result - Round $roundNumber")),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.nightlight_round, size: 80, color: Colors.blue),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(nightResult, style: const TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 50),
                    Text("Players alive: ${alivePlayers.length}", style: const TextStyle(fontSize: 18, color: Colors.green)),
                    const SizedBox(height: 30),
                   ElevatedButton(
  onPressed: gameEnded
      ? () => Navigator.popUntil(context, (route) => route.isFirst)
      : startDiscussion,
  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
  child: Text(gameEnded ? "PLAY AGAIN" : "☀️ START DAY PHASE"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    
    // ========== NIGHT PHASE SCREEN ==========
    if (currentPlayerIndex >= alivePlayers.length) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    String currentPlayer = alivePlayers[currentPlayerIndex];
    String currentRole = playerRoles[currentPlayer]!;
    bool revealed = roleRevealed.containsKey(currentPlayer) && roleRevealed[currentPlayer] == true;
    

    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("🌙 Night Phase - Round $roundNumber"),
        toolbarHeight: 50,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Player info row with eye button (role revealed ONCE, can't hide)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.grey[900],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "👤 $currentPlayer",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        roleRevealed.containsKey(currentPlayer) && roleRevealed[currentPlayer] == true 
    ? _getRoleDisplay(currentRole) 
    : "Role: ???",
                        style: const TextStyle(fontSize: 16),
                      ),
                      IconButton(
  icon: Icon(
    Icons.remove_red_eye,
    color: roleRevealed.containsKey(currentPlayer) && roleRevealed[currentPlayer] == true ? Colors.green : Colors.grey,
  ),
  onPressed: roleRevealed.containsKey(currentPlayer) && roleRevealed[currentPlayer] == true
      ? null
      : () {
          setState(() {
            roleRevealed[currentPlayer] = true;
          
                                });
                              },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Doctor self-save info (only shown after role revealed)
            if (roleRevealed.containsKey(currentPlayer) && roleRevealed[currentPlayer] == true && currentRole == "Doctor")
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "🩺 Self-saves left: $doctorSelfSavesLeft",
                    style: TextStyle(
                      color: doctorSelfSavesLeft == 0 ? Colors.red : Colors.yellow,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            
            // Warning when no self-saves left
            if (roleRevealed.containsKey(currentPlayer) && roleRevealed[currentPlayer] == true && currentRole == "Doctor" && doctorSelfSavesLeft == 0)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "⚠️ WARNING: No self-saves remaining!",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            
            // Instruction text (only shown after role revealed)
            if (roleRevealed.containsKey(currentPlayer) && roleRevealed[currentPlayer] == true)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  _getInstructionText(currentRole),
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),

                        // Show Jester team members (only for Jester when role revealed)
            if (revealed && currentRole == "Jester" && jesters.length > 1)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.purple[800],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "🃏 JESTER TEAM",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 9),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: jesters.map((jester) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              jester,
                              style: const TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

   // Show Godfather and Bodyguard info (only for killers when role revealed)
if (revealed && (currentRole == "Killer" || currentRole == "Godfather"))
  Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text("👑 Godfather: ", style: TextStyle(fontSize: 12, color: Colors.yellow)),
              Text(
                godfather != null && alivePlayers.contains(godfather) ? godfather! : "None",
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          Row(
            children: [
              const Text("🛡️ Bodyguard: ", style: TextStyle(fontSize: 12, color: Colors.cyan)),
              Text(
                bodyguard != null && alivePlayers.contains(bodyguard) ? bodyguard! : "None",
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    ),
  ),
             
            // Show all killers with their targets (names always show, targets show when selected)
if (revealed && (currentRole == "Killer" || currentRole == "Godfather"))
  Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: const [
    Text(
      "🔪 KILLERS",
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),
    ),
    Text(
      "🎯 TARGETS",
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.orange),
    ),
  ],
),
          const SizedBox(height: 4),
          ..._getAllKillers().map((killer) {
            String target = killerChoices[killer] ?? "❓ Not selected yet";
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    killer,
                    style: const TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                  Text(
                    target,
                    style: TextStyle(
                      fontSize: 11,
                      color: killerChoices.containsKey(killer) ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    ),
  ),
            
            // Detective result (only after selection)
            if (roleRevealed.containsKey(currentPlayer) && roleRevealed[currentPlayer] == true && currentRole == "Detective" && detectiveResult != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue[900],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    detectiveResult!,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            
            // Player grid (SMALLER BOXES)
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.4,  // 👈 Smaller boxes (wider ratio = shorter height)
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                ),
                itemCount: alivePlayers.length,
                itemBuilder: (context, index) {
                  String name = alivePlayers[index];
                  bool isSelf = name == currentPlayer;
                  bool isSelected = false;
                  
                  if (currentRole == "Gamechanger") isSelected = gamechangerSwap.contains(name);
                  else if ((currentRole == "Killer" || currentRole == "Godfather") && !killersDone && revealed) isSelected = killerChoices.values.contains(name);
                  else if (currentRole == "Doctor") isSelected = doctorTarget == name;
                  else if (currentRole == "Detective") isSelected = detectiveTarget == name;
                  else if (currentRole == "Villager" || currentRole == "Jester") isSelected = villagerGuess == name;
                  else if (currentRole == "Grandma") isSelected = villagerGuess == name;  
else if (currentRole == "Bodyguard") isSelected = villagerGuess == name; 
                  
                  bool isDisabled = false;
if (hasSelected) isDisabled = true;
if (!roleRevealed.containsKey(currentPlayer) || roleRevealed[currentPlayer] != true)
                  if (isSelf && currentRole != "Doctor") isDisabled = true;
                  if (isSelf && currentRole == "Doctor" && doctorSelfSavesLeft <= 0) isDisabled = true;
                  if ((currentRole == "Killer" || currentRole == "Godfather") && killersDone) isDisabled = true;
                  if (currentRole == "Gamechanger" && gamechangerSwap.length >= 2) isDisabled = true;
                  if (currentRole == "Gamechanger" && gamechangerSwap.contains(name)) isDisabled = true;
                  
                  return Card(
                    color: isSelected ? Colors.green[800] : (isSelf ? Colors.blue[800] : Colors.grey[800]),
                    elevation: 1,
                    child: Opacity(
                      opacity: isDisabled ? 0.5 : 1.0,
                      child: InkWell(
                        onTap: isDisabled ? null : () => selectTarget(name),
                        child: Center(
                          child: Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
           // Pass button - BIGGER
Padding(
  padding: const EdgeInsets.all(16.0),
  child: SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: nextPlayer,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: const EdgeInsets.symmetric(vertical: 18),  // 👈 Taller
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),  // 👈 Rounded corners
        ),
      ),
      child: const Text(
        "PASS TO NEXT PLAYER",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),  // 👈 Bigger text
     
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== DISCUSSION SCREEN ====================
class DiscussionScreen extends StatefulWidget {
  final List<String> players;
  final Map<String, String> playerRoles;
  final List<String> alivePlayers;
  final int roundNumber;
  final String nightResult;

  const DiscussionScreen({
    super.key,
    required this.players,
    required this.playerRoles,
    required this.alivePlayers,
    required this.roundNumber,
    required this.nightResult,
  });

  @override
  State<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {
  int secondsLeft = 182;
  Timer? timer;
  bool timerFinished = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (secondsLeft > 0) {
          secondsLeft--;
        } else {
          timer.cancel();
          timerFinished = true;
        }
      });
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "$minutes:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: () async => false,
    child: Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      title: Text("☀️ Day Phase - Discussion - Round ${widget.roundNumber}"),
      backgroundColor: Colors.grey[900],
automaticallyImplyLeading: false,
    ),
    body: Column(
      children: [
        // Timer only (no night result container)
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[900],
          child: Center(
            child: Column(
              children: [
                const Text(
                  "DISCUSSION TIME",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: timerFinished ? Colors.red : Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    formatTime(secondsLeft),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Discussion message with result inside
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    timerFinished ? "⏰ TIME'S UP!" : "🗣️ Discuss who is suspicious...",
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    widget.nightResult,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "👥 Players alive: ${widget.alivePlayers.length}",
                    style: const TextStyle(fontSize: 18, color: Colors.green),
                  ),
                  const SizedBox(height: 30),
                 if (timerFinished)
  Column(
    children: [
      // BACK button
      ElevatedButton(
        onPressed: () {
          Navigator.pop(context);  // Goes back to GameScreen
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          "STAR VOTING",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    ],
  ),
],
  ),

              ),
            ),
          ),
        ],
      ),
),
    );
  }
}
// ==================== VOTING SCREEN ====================
class VotingScreen extends StatefulWidget {
  final List<String> players;
  final Map<String, String> playerRoles;
  final List<String> alivePlayers;
final List<String> deadThisRound;
  final int roundNumber;
  final String nightResult;
  final String? godfather;

  const VotingScreen({
    super.key,
    required this.players,
    required this.playerRoles,
    required this.alivePlayers,
    required this.deadThisRound,
    required this.roundNumber,
    required this.nightResult,
    this.godfather,
  });

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  Map<String, int> votes = {};
  Map<String, List<String>> playerVotes = {};
  int currentVoterIndex = 0;
  List<String> votersList = [];
  bool isTieBreaker = false;
  List<String> tiedPlayersList = [];
  bool _resultShown = false;

  @override
void initState() {
  super.initState();
  for (var player in widget.alivePlayers) {
    votes[player] = 0;
    playerVotes[player] = [];
  }
  _updateVotersList();
}

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  _updateVotersList();
}
void _updateVotersList() {
  List<String> allVoters = List.from(widget.alivePlayers);
  allVoters.addAll(widget.deadThisRound);
  votersList = allVoters;
  
  // Initialize votes and playerVotes for dead players
  for (var player in widget.deadThisRound) {
    if (!votes.containsKey(player)) {
      votes[player] = 0;
    }
    if (!playerVotes.containsKey(player)) {
      playerVotes[player] = [];
    }
  }
}

  bool hasVoted(String player) => playerVotes[player]!.length >= 2;
  int getVotesLeft(String player) => 2 - playerVotes[player]!.length;

  void castVote(String voter, String target) {
    if (playerVotes[voter]!.contains(target)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ You cannot vote for the same person twice!")),
      );
      return;
    }
    
    setState(() {
      playerVotes[voter]!.add(target);
      votes[target] = votes[target]! + 1;
    });
    
    // Check if this voter has completed their votes
    if (hasVoted(voter)) {
      _moveToNextVoter();
    }
  }
  
  void _moveToNextVoter() {
    setState(() {
      currentVoterIndex++;
    });
    
    // If all voters have finished, show result
    if (currentVoterIndex >= votersList.length) {
      _showFinalResult();
    }
  }

  void _showFinalResult() {
    if (_resultShown) return;
    _resultShown = true;
    
    String? eliminated;
    int maxVotes = -1;
    List<String> tiedPlayers = [];

    for (var entry in votes.entries) {
      if (entry.value > maxVotes) {
        maxVotes = entry.value;
        eliminated = entry.key;
        tiedPlayers = [entry.key];
      } else if (entry.value == maxVotes && entry.value > 0) {
        tiedPlayers.add(entry.key);
      }
    }

    if (tiedPlayers.length > 1) {
      _startTieBreaker(tiedPlayers);
      return;
    }

    _showResult(eliminated, maxVotes);
  }
void _startTieBreaker(List<String> tiedPlayers) {
  setState(() {
    isTieBreaker = true;
    tiedPlayersList = tiedPlayers;
    votes = {};
    playerVotes = {};
    currentVoterIndex = 0;
    _resultShown = false;
    
    // Initialize votes for ALL alive players
    for (var player in widget.alivePlayers) {
      votes[player] = 0;
      playerVotes[player] = [];
    }
    
    // ALSO initialize votes for dead players (to prevent null errors)
    for (var player in widget.deadThisRound) {
      if (!votes.containsKey(player)) {
        votes[player] = 0;
      }
      if (!playerVotes.containsKey(player)) {
        playerVotes[player] = [];
      }
    }
  });
  // Update voters list for tie breaker
  _updateVotersList();
}


void castTieBreakerVote(String voter, String target) {
  // Check if target is in tied players list
  if (!tiedPlayersList.contains(target)) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ You can only vote for tied players: ${tiedPlayersList.join(", ")}")),
    );
    return;
  }
  
  setState(() {
    playerVotes[voter]!.add(target);
    votes[target] = votes[target]! + 1;
  });
  
  setState(() {
    currentVoterIndex++;
  });
  
  if (currentVoterIndex >= votersList.length) {
    _finishTieBreaker();
  }
}

  bool hasTieBreakerVoted(String player) => playerVotes[player]!.length >= 1;
  int getTieBreakerVotesLeft(String player) => 1 - playerVotes[player]!.length;

void _finishTieBreaker() {
  String? eliminated;
  int maxVotes = -1;
  List<String> stillTied = [];

  for (var entry in votes.entries) {
    if (entry.value > maxVotes) {
      maxVotes = entry.value;
      eliminated = entry.key;
      stillTied = [entry.key];
    } else if (entry.value == maxVotes && entry.value > 0) {
      stillTied.add(entry.key);
    }
  }

  if (stillTied.length > 1) {
    // Still tied - NO ONE gets eliminated, move to next round
    _showResult(null, 0);
    return;
  }

  _showResult(eliminated, maxVotes);
}

  void _showResult(String? eliminated, int votesCount) {
  // Navigate to result screen
   Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => VotingResultScreen(
        eliminated: eliminated,
        votesCount: votesCount,
        onContinue: () {
          // This closes the result screen and returns to voting screen
          Navigator.pop(context);
          // Then close voting screen and return eliminated player
          Navigator.pop(context, eliminated);
        },
      ),
    ),
  );
}
void skipToNextVoter() {
  setState(() {
    currentVoterIndex++;
  });
  
  if (currentVoterIndex >= votersList.length) {
    if (isTieBreaker) {
      _finishTieBreaker();
    } else {
      _showFinalResult();
    }
  }
}
  @override
  Widget build(BuildContext context) {
    // If all voters have finished, show loading (result will be shown by _showFinalResult)
    if (currentVoterIndex >= votersList.length) {
      return WillPopScope(
      onWillPop: () async => false,
      child: const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text(
                "All players have voted!\nCalculating results...",
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
          ),
      );
    }
    
    String currentVoter = votersList[currentVoterIndex];


    return WillPopScope(
    onWillPop: () async => false,
    child: Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(isTieBreaker ? "⚖️ TIE BREAKER - Round ${widget.roundNumber}" : "🗳️ VOTING - Round ${widget.roundNumber}"),
        backgroundColor: Colors.grey[900],
        centerTitle: true,
automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          if (isTieBreaker)
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    "⚠️ TIE BREAKER ROUND",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Tied players: ${tiedPlayersList.join(", ")}",
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Each player gives 1 vote",
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          
          // Current voter card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue[800]!, Colors.blue[900]!],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text(
                  "🎭 CURRENT VOTER",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  currentVoter,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    isTieBreaker
                        ? "Votes left: ${getTieBreakerVotesLeft(currentVoter)}"
                        : "Votes left: ${getVotesLeft(currentVoter)}",
                    style: const TextStyle(fontSize: 18, color: Colors.yellow, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          
          // Instruction
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              isTieBreaker
                  ? "Vote for 1 player (cannot vote for yourself)"
                  : "Vote for 2 different players (cannot vote same person twice)",
              style: const TextStyle(fontSize: 13, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(height: 10),
          
          
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.5,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
              ),// Player grid
 
            itemCount: votersList.length,
itemBuilder: (context, index) {
  String player = votersList[index];

                bool isCurrentVoter = player == currentVoter;
                int votesReceived = votes[player] ?? 0;
                bool alreadyVotedFor = playerVotes[currentVoter]?.contains(player) ?? false;
                bool voterFinished = isTieBreaker 
                    ? hasTieBreakerVoted(currentVoter)
                    : hasVoted(currentVoter);
bool canBeVoted = !isTieBreaker || tiedPlayersList.contains(player);
bool isDead = !widget.alivePlayers.contains(player);

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: isCurrentVoter 
                      ? Colors.blue[800] 
                      : (alreadyVotedFor ? Colors.green[800] : Colors.grey[800]),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      if (isCurrentVoter) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("❌ You cannot vote for yourself!")),
                        );
                        return;
                      }

if (isDead) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("❌ You cannot vote for a dead player!")),
  );
  return;
}

     
if (!canBeVoted) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("❌ You can only vote for tied players: ${tiedPlayersList.join(", ")}")),
  );
  return;
}
                      if (voterFinished) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(isTieBreaker 
                              ? "✅ You have used your vote!" 
                              : "✅ You have used both votes!")),
                        );
                        return;
                      }

                      if (isTieBreaker) {
                        castTieBreakerVote(currentVoter, player);
                      } else {
                        castVote(currentVoter, player);
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          player,
                         style: TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.bold,
  color: isDead ? Colors.grey : Colors.white,
),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "🗳️ $votesReceived",
                            style: TextStyle(fontSize: 13, color: isDead ? Colors.grey : Colors.yellow, fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (isDead)
                          const Text(
                            "(DEAD)",
                            style: TextStyle(fontSize: 10, color: Colors.red),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: skipToNextVoter,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: const Text("SKIP / NEXT VOTER"),
        ),
      ),
    ),
  ],
),
      ), 
    );
  }
}


// ==================== VOTING RESULT SCREEN ====================
class VotingResultScreen extends StatelessWidget {
  final String? eliminated;
  final int votesCount;
  final VoidCallback onContinue;

  const VotingResultScreen({
    super.key,
    required this.eliminated,
    required this.votesCount,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
  onWillPop: () async => false,
  child: Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("🗳️ VOTING RESULT"),
        backgroundColor: Colors.grey[900],
        centerTitle: true,
automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: eliminated != null ? Colors.red[800] : Colors.green[800],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  eliminated != null ? Icons.gavel : Icons.shield,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                eliminated != null
                    ? "$eliminated was eliminated!                         Killers are still in game"
                    : "No one was eliminated!                         Killers are still in game",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                eliminated != null
                    ? "With $votesCount votes"
                    : "The vote was tied or no majority",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "CONTINUE TO NEXT ROUND",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
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