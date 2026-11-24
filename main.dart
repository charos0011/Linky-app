import 'package:flutter/material.dart';

void main() {
  runApp(const LinkyApp());
}

class LinkyApp extends StatelessWidget {
  const LinkyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Linky',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4A89F3)),
        useMaterial3: true,
      ),
      home: const LockScreen(child: LinkyHomePage()),
    );
  }
}

class LockScreen extends StatefulWidget {
  final Widget child;
  const LockScreen({super.key, required this.child});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final TextEditingController _pinController = TextEditingController();

  // 'setup' -> 'confirm' -> 'unlock'
  String _mode = 'setup';
  String? _savedPin;
  String? _firstPin;
  String? _errorText;

  void _handleSubmit() {
    final enteredPin = _pinController.text.trim();

    if (enteredPin.length < 4) {
      setState(() {
        _errorText = 'Kamida 4 ta raqam kiriting';
      });
      return;
    }

    if (_mode == 'setup') {
      setState(() {
        _firstPin = enteredPin;
        _mode = 'confirm';
        _errorText = null;
        _pinController.clear();
      });
      return;
    }

    if (_mode == 'confirm') {
      if (enteredPin == _firstPin) {
        setState(() {
          _savedPin = enteredPin;
          _firstPin = null;
          _mode = 'unlock';
          _errorText = null;
          _pinController.clear();
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => widget.child),
        );
      } else {
        setState(() {
          _errorText = 'Parollar mos kelmadi, qaytadan kiriting';
          _pinController.clear();
        });
      }
      return;
    }

    if (_mode == 'unlock') {
      if (enteredPin == _savedPin) {
        setState(() {
          _errorText = null;
          _pinController.clear();
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => widget.child),
        );
      } else {
        setState(() {
          _errorText = 'Parol noto\'g\'ri';
          _pinController.clear();
        });
      }
    }
  }

  void _resetSetup() {
    setState(() {
      _firstPin = null;
      _errorText = null;
      _pinController.clear();
      if (_savedPin == null) {
        _mode = 'setup';
      }
    });
  }

  String get _titleText {
    if (_mode == 'setup') return 'Yangi PIN kod o\'rnating';
    if (_mode == 'confirm') return 'PIN kodni qayta kiriting';
    return 'PIN kodni kiriting';
  }

  String get _buttonText {
    if (_mode == 'setup') return 'Davom etish';
    if (_mode == 'confirm') return 'Tasdiqlash';
    return 'Kirish';
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A89F3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 72, color: Colors.white),
              const SizedBox(height: 16),
              const Text(
                'Linky',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _titleText,
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, letterSpacing: 4),
                decoration: InputDecoration(
                  hintText: 'PIN kod (kamida 4 raqam)',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.85),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => _handleSubmit(),
              ),
              if (_errorText != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorText!,
                  style: const TextStyle(
                    color: Colors.yellowAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: _handleSubmit,
                  child: Text(
                    _buttonText,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              if (_mode == 'confirm') ...[
                const SizedBox(height: 10),
                TextButton(
                  onPressed: _resetSetup,
                  child: const Text(
                    'Qaytadan o\'rnatish',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class LinkyHomePage extends StatefulWidget {
  const LinkyHomePage({super.key});

  @override
  State<LinkyHomePage> createState() => _LinkyHomePageState();
}

class _LinkyHomePageState extends State<LinkyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    _FeedPage(),
    _SearchPage(),
    _MessagesPage(),
    _ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Linky'),
        actions: [
          IconButton(
            icon: const Icon(Icons.lock_outline),
            tooltip: 'Qulflash',
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const LockScreen(child: LinkyHomePage()),
                ),
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Asosiy',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            selectedIcon: Icon(Icons.search),
            label: 'Qidiruv',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Xabarlar',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _FeedPage extends StatefulWidget {
  const _FeedPage();

  @override
  State<_FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<_FeedPage> {
  int _likes = 12;
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Stories',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 82,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              _StoryItem(name: 'Siz'),
              _StoryItem(name: 'Reels'),
              _StoryItem(name: 'Trend'),
              _StoryItem(name: 'Yangi'),
              _StoryItem(name: 'Do\'stlar'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    CircleAvatar(child: Icon(Icons.movie)),
                    SizedBox(width: 10),
                    Text(
                      'Linky Reels & Post',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A89F3).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(Icons.play_circle_fill, size: 56, color: Color(0xFF4A89F3)),
                  ),
                ),
                const SizedBox(height: 10),
                const Text('Yangi video va postlar shu yerda ko\'rinadi.'),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _liked ? Icons.favorite : Icons.favorite_border,
                        color: _liked ? Colors.red : null,
                      ),
                      onPressed: () {
                        setState(() {
                          _liked = !_liked;
                          _likes += _liked ? 1 : -1;
                        });
                      },
                    ),
                    Text('$_likes'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StoryItem extends StatelessWidget {
  final String name;
  const _StoryItem({required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 26,
            child: Icon(Icons.person),
          ),
          const SizedBox(height: 4),
          Text(name, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _SearchPage extends StatefulWidget {
  const _SearchPage();

  @override
  State<_SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<_SearchPage> {
  String _query = '';
  final List<String> _items = const [
    'Linky Reels: Qisqa videolar',
    'Trend musiqalar va kliplar',
    'Yangi foydalanuvchi sahifalari',
    'Foydali darslik va maslahatlar',
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _items
        .where((item) => item.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Video, reels yoki sahifa qidiring...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onChanged: (value) {
              setState(() {
                _query = value.trim();
              });
            },
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.search),
                    title: Text(filtered[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MessagesPage extends StatelessWidget {
  const _MessagesPage();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Card(
          child: ListTile(
            leading: CircleAvatar(child: Icon(Icons.chat)),
            title: Text('Shaxsiy xabarlar'),
            subtitle: Text('Xabar yozish va javob olish bo\'limi'),
          ),
        ),
      ],
    );
  }
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(radius: 42, child: Icon(Icons.person, size: 42)),
          SizedBox(height: 12),
          Text(
            'Linky Profili',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text('0', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Postlar'),
                ],
              ),
              Column(
                children: [
                  Text('0', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Obunachilar'),
                ],
              ),
              Column(
                children: [
                  Text('0', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Obunalar'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
