import 'package:flutter/material.dart';

void main() {
  runApp(const SecureNotesApp());
}

class DemoUser {
  final String id;
  final String name;
  final String role;

  const DemoUser({
    required this.id,
    required this.name,
    required this.role,
  });
}

class Note {
  final String id;
  final String ownerId;
  final String title;
  final String content;

  const Note({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.content,
  });
}

const demoUsers = [
  DemoUser(
    id: 'user-A',
    name: 'Kullanıcı A',
    role: 'USER',
  ),
  DemoUser(
    id: 'user-B',
    name: 'Kullanıcı B',
    role: 'USER',
  ),
  DemoUser(
    id: 'admin-1',
    name: 'Yönetici',
    role: 'ADMIN',
  ),
];

const notes = [
  Note(
    id: 'note-101',
    ownerId: 'user-A',
    title: 'Proje planı',
    content: 'Güvenli not uygulamasının geliştirme adımları.',
  ),
  Note(
    id: 'note-102',
    ownerId: 'user-A',
    title: 'Toplantı notları',
    content: 'Yeni sürüm için yapılacak işler.',
  ),
  Note(
    id: 'note-201',
    ownerId: 'user-B',
    title: 'Kişisel notlar',
    content: 'Kullanıcı B tarafından oluşturulmuş özel not.',
  ),
  Note(
    id: 'note-202',
    ownerId: 'user-B',
    title: 'Alışveriş listesi',
    content: 'Market alışverişi için notlar.',
  ),
];

class SecureNotesApp extends StatelessWidget {
  const SecureNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Güvenli Not Yönetimi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF315DA4),
        ),
        useMaterial3: true,
      ),
      home: const NotesPage(),
    );
  }
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  String currentUserId = 'user-A';
  String attackNoteId = 'note-201';
  String message = '';
  Note? selectedNote;

  DemoUser get currentUser {
    return demoUsers.firstWhere(
      (user) => user.id == currentUserId,
    );
  }

  List<Note> get visibleNotes {
    if (currentUser.role == 'ADMIN') {
      return [];
    }

    return notes.where((note) {
      return note.ownerId == currentUser.id;
    }).toList();
  }

  void openNote(Note note) {
    // Sadece demo amaçlı istemci kontrolüdür.
    // Gerçek sahiplik kontrolü API sunucusunda yapılır.
    if (note.ownerId != currentUser.id) {
      setState(() {
        selectedNote = null;
        message = 'Erişim reddedildi: Bu not size ait değil.';
      });
      return;
    }

    setState(() {
      selectedNote = note;
      message = 'Not başarıyla görüntülendi.';
    });
  }

  void simulateIdorAttack() {
    final targetNote = notes.where(
      (note) => note.id == attackNoteId.trim(),
    );

    if (targetNote.isEmpty) {
      setState(() {
        selectedNote = null;
        message = '404: Not bulunamadı.';
      });
      return;
    }

    final note = targetNote.first;

    if (note.ownerId != currentUser.id) {
      setState(() {
        selectedNote = null;
        message =
            '403 simülasyonu: Başka kullanıcının notuna erişim reddedildi.';
      });
      return;
    }

    setState(() {
      selectedNote = note;
      message = 'Kendi notunuza erişim sağlandı.';
    });
  }

  void changeUser(String? userId) {
    if (userId == null) return;

    setState(() {
      currentUserId = userId;
      selectedNote = null;
      message = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: AppBar(
        title: const Text('Güvenli Not Yönetimi'),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const Text(
              'GÜVENLİK EĞİTİM PROJESİ',
              style: TextStyle(
                color: Color(0xFF4268AA),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Merhaba, ${currentUser.name}',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),

            Card(
              color: const Color(0xFFFFF5DD),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Bu ekran eğitim amaçlıdır. Kullanıcı seçimi ve '
                  'sahiplik kontrolleri gerçek kimlik doğrulaması '
                  'değildir. Güvenlik kontrolü sunucuda yapılmalıdır.',
                  style: TextStyle(height: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Demo kullanıcısı',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              initialValue: currentUserId,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
              items: demoUsers.map((user) {
                return DropdownMenuItem(
                  value: user.id,
                  child: Text('${user.name} (${user.role})'),
                );
              }).toList(),
              onChanged: changeUser,
            ),

            const SizedBox(height: 25),

            const Text(
              'Notlarım',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            if (currentUser.role == 'ADMIN')
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text(
                    'Yönetici için otomatik not erişimi yoktur. '
                    'Tanımlı yetki ve iş gereği kontrol edilmelidir.',
                  ),
                ),
              )
            else if (visibleNotes.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text('Henüz not bulunmuyor.'),
                ),
              )
            else
              ...visibleNotes.map((note) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      note.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${note.content}\n${note.id}',
                    ),
                    isThreeLine: true,
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                    onTap: () => openNote(note),
                  ),
                );
              }),

            const SizedBox(height: 25),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'IDOR / BOLA güvenlik testi',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Başka kullanıcıya ait not kimliğiyle '
                      'erişim denemesi yapın.',
                    ),
                    const SizedBox(height: 15),

                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Hedef not kimliği',
                        border: OutlineInputBorder(),
                      ),
                      controller: TextEditingController(
                        text: attackNoteId,
                      ),
                      onChanged: (value) {
                        attackNoteId = value;
                      },
                    ),

                    const SizedBox(height: 14),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: simulateIdorAttack,
                        child: const Text('Erişimi dene'),
                      ),
                    ),

                    if (message.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF0FA),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(message),
                      ),
                    ],

                    if (selectedNote != null) ...[
                      const Divider(height: 25),
                      Text(
                        selectedNote!.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(selectedNote!.content),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Güvenlik ilkeleri',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const ListTile(
              leading: Icon(Icons.verified_user),
              title: Text('Kimlik doğrulama'),
              subtitle: Text('Her istekte oturum doğrulanır.'),
            ),
            const ListTile(
              leading: Icon(Icons.admin_panel_settings),
              title: Text('Rol kontrolü'),
              subtitle: Text('Yönetici işlemleri ayrıca yetkilendirilir.'),
            ),
            const ListTile(
              leading: Icon(Icons.lock),
              title: Text('Sahiplik kontrolü'),
              subtitle: Text('Not sahibi sunucuda kontrol edilir.'),
            ),
            const ListTile(
              leading: Icon(Icons.shield),
              title: Text('Yetkisiz erişim'),
              subtitle: Text('İzinsiz istekler reddedilir.'),
            ),
          ],
        ),
      ),
    );
  }
}