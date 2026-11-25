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
      home: const LockScreen(),
    );
  }
}

class LockScreen extends StatefulWidget {
  final String? initialPin;

  const LockScreen({super.key, this.initialPin});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final TextEditingController _pinController = TextEditingController();

  String _mode = 'setup';
  String? _savedPin;
  String? _firstPin;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _savedPin = widget.initialPin;
    if (_savedPin != null && _savedPin!.isNotEmpty) {
      _mode = 'unlock';
    }
  }

  void _submit() {
    final pin = _pinController.text.trim();

    if (pin.length < 4) {
      setState(() {
        _errorText = 'Kamida 4 ta raqam kiriting';
      });
      return;
    }

    if (_mode == 'setup') {
      setState(() {
        _firstPin = pin;
        _mode = 'confirm';
        _errorText = null;
        _pinController.clear();
      });
      return;
    }

    if (_mode == 'confirm') {
      if (pin == _firstPin) {
        final confirmed = pin;
        setState(() {
          _savedPin = confirmed;
          _firstPin = null;
          _mode = 'unlock';
          _errorText = null;
          _pinController.clear();
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => LinkyHomePage(activePin: confirmed),
          ),
        );
      } else {
        setState(() {
          _errorText = 'PIN kodlar mos kelmadi, qaytadan kiriting';
          _pinController.clear();
        });
      }
      return;
    }

    if (_mode == 'unlock') {
      if (pin == _savedPin) {
        setState(() {
          _errorText = null;
          _pinController.clear();
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => LinkyHomePage(activePin: _savedPin),
          ),
        );
      } else {
        setState(() {
          _errorText = 'PIN kod noto\'g\'ri';
          _pinController.clear();
        });
      }
    }
  }

  void _restartSetup() {
    setState(() {
      _firstPin = null;
      _errorText = null;
      _pinController.clear();
      _mode = 'setup';
    });
  }

  String _getTitle() {
    if (_mode == 'setup') return 'Yangi PIN kod o\'rnating';
    if (_mode == 'confirm') return 'PIN kodni qayta kiriting';
    return 'PIN kodni kiriting';
  }

  String _getButtonText() {
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
                _getTitle(),
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
                  fillColor: Colors.white.withOpacity(0.9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => _submit(),
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
                  onPressed: _submit,
                  child: Text(
                    _getButtonText(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              if (_mode == 'confirm') ...[
                const SizedBox(height: 10),
                TextButton(
                  onPressed: _restartSetup,
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
  final String? activePin;

  const LinkyHomePage({super.key, this.activePin});

  @override
  State<LinkyHomePage> createState() => _LinkyHomePageState();
}

class _LinkyHomePageState extends State<LinkyHomePage> {
  int _currentIndex = 0;

  final _posts = [
    {
      'author': 'Linky Official',
      'title': 'Linky ilovasiga xush kelibsiz!',
      'desc': 'Stories, Reels, qidiruv va xabarlar bir joyda.',
      'likes': 24,
      'liked': false,
      'isVideo': true,
    },
    {
      'author': 'Trend Reels',
      'title': 'Mashhur qisqa videolar',
      'desc': 'Yangi videolar va tavsiyalarni ko\'ring.',
      'likes': 18,
      'liked': false,
      'isVideo': true,
    },
  ];

  void _addPost(String title, String desc) {
    setState(() {
      _posts.insert(0, {
        'author': 'Siz',
        'title': title,
        'desc': desc,
        'likes': 1,
        'liked': true,
        'isVideo': false,
      });
    });
  }

  void _openAddPostDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Yangi post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Sarlavha'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Matn'),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Bekor qilish'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.trim().isNotEmpty) {
                _addPost(
                  titleController.text.trim(),
                  descController.text.trim().isEmpty
                      ? 'Yangi post'
                      : descController.text.trim(),
                );
                Navigator.pop(ctx);
              }
            },
            child: const Text('Joylash'),
          ),
        ],
      ),
    );
  }

  void _lockNow() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => LockScreen(initialPin: widget.activePin),
      ),
    );
  }

  void _resetPin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const LockScreen(initialPin: null),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      FeedTab(
        posts: _posts,
        onToggleLike: (index) {
          setState(() {
            final liked = _posts[index]['liked'] as bool;
            _posts[index]['liked'] = !liked;
            _posts[index]['likes'] =
                (_posts[index]['likes'] as int) + (liked ? -1 : 1);
          });
        },
      ),
      SearchTab(posts: _posts),
      const MessagesTab(),
      ProfileTab(
        myPostsCount: _posts.where((p) => p['author'] == 'Siz').length,
        onResetPin: _resetPin,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Linky',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            tooltip: 'Post qo\'shish',
            onPressed: _openAddPostDialog,
          ),
          IconButton(
            icon: const Icon(Icons.lock_outline),
            tooltip: 'Qulflash',
            onPressed: _lockNow,
          ),
        ],
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
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

class FeedTab extends StatelessWidget {
  final posts;
  final Function(int index) onToggleLike;

  const FeedTab({
    super.key,
    required this.posts,
    required this.onToggleLike,
  });

  @override
  Widget build(BuildContext context) {
    final stories = ['Siz', 'Reels', 'Trend', 'Musiqa', 'Yangilik'];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Stories',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 84,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: stories.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${stories[index]} story ochildi'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: const Color(0xFF4A89F3),
                        child: Text(
                          stories[index][0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stories[index],
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(posts.length, (index) {
          final post = posts[index];
          final liked = post['liked'] as bool;
          final isVideo = post['isVideo'] as bool;

          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(child: Icon(Icons.person)),
                      const SizedBox(width: 10),
                      Text(
                        post['author'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (isVideo)
                    Container(
                      height: 150,
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A89F3).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.play_circle_fill,
                          size: 54,
                          color: Color(0xFF4A89F3),
                        ),
                      ),
                    ),
                  Text(
                    post['title'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(post['desc'] as String),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          liked ? Icons.favorite : Icons.favorite_border,
                          color: liked ? Colors.red : null,
                        ),
                        onPressed: () => onToggleLike(index),
                      ),
                      Text('${post['likes']}'),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class SearchTab extends StatefulWidget {
  final posts;

  const SearchTab({super.key, required this.posts});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = (widget.posts as List).where((p) {
      final title = (p['title'] as String).toLowerCase();
      final desc = (p['desc'] as String).toLowerCase();
      final q = _query.toLowerCase();
      return title.contains(q) || desc.contains(q);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Video, reels yoki post qidiring...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (val) {
              setState(() {
                _query = val.trim();
              });
            },
          ),
          const SizedBox(height: 14),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('Hech narsa topilmadi'))
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.play_arrow),
                          title: Text(item['title'] as String),
                          subtitle: Text(item['desc'] as String),
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

class MessagesTab extends StatefulWidget {
  const MessagesTab({super.key});

  @override
  State<MessagesTab> createState() => _MessagesTabState();
}

class _MessagesTabState extends State<MessagesTab> {
  final TextEditingController _msgController = TextEditingController();
  final _messages = [
    'Salom! Linky chatiga xush kelibsiz.',
  ];

  void _send() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(text);
      _msgController.clear();
    });
  }

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return Align(
                alignment: index == 0
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: index == 0
                        ? Colors.grey.shade200
                        : const Color(0xFF4A89F3),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    _messages[index],
                    style: TextStyle(
                      color: index == 0 ? Colors.black87 : Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _msgController,
                  decoration: InputDecoration(
                    hintText: 'Xabar yozing...',
                    border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onSubmitted: (_) => _send(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _send,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileTab extends StatefulWidget {
  final int myPostsCount;
  final VoidCallback onResetPin;

  const ProfileTab({
    super.key,
    required this.myPostsCount,
    required this.onResetPin,
  });

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String _name = 'Linky foydalanuvchisi';
  int _followers = 128;
  bool _following = false;

  void _editName() {
    final controller = TextEditingController(text: _name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ismni o\'zgartirish'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Bekor qilish'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _name = controller.text.trim();
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Saqlash'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 42,
            backgroundColor: Color(0xFF4A89F3),
            child: Icon(Icons.person, size: 42, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 18),
                onPressed: _editName,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    '${widget.myPostsCount}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('Postlar'),
                ],
              ),
              Column(
                children: [
                  Text(
                    '$_followers',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('Obunachilar'),
                ],
              ),
              const Column(
                children: [
                  Text(
                    '15',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Obunalar'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _following = !_following;
                  _followers += _following ? 1 : -1;
                });
              },
              child: Text(_following ? 'Obuna bo\'lingan' : 'Obuna bo\'lish'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: widget.onResetPin,
              icon: const Icon(Icons.password),
              label: const Text('PIN kodni yangidan o\'rnatish'),
            ),
          ),
        ],
      ),
    );
  }
}
