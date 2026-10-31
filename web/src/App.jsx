import { useMemo, useState } from "react";

const demoUsers = [
  { id: "user-A", name: "Kullanıcı A", role: "USER" },
  { id: "user-B", name: "Kullanıcı B", role: "USER" },
  { id: "admin-1", name: "Yönetici", role: "ADMIN" },
];

const notes = [
  {
    id: "note-101",
    ownerId: "user-A",
    title: "Proje planı",
    content: "Güvenli not uygulamasının geliştirme adımları.",
  },
  {
    id: "note-102",
    ownerId: "user-A",
    title: "Toplantı notları",
    content: "Yeni sürüm için yapılacak işler.",
  },
  {
    id: "note-201",
    ownerId: "user-B",
    title: "Kişisel notlar",
    content: "Kullanıcı B tarafından oluşturulmuş özel not.",
  },
  {
    id: "note-202",
    ownerId: "user-B",
    title: "Alışveriş listesi",
    content: "Market alışverişi için notlar.",
  },
];

function App() {
  const [currentUserId, setCurrentUserId] = useState("user-A");
  const [selectedNote, setSelectedNote] = useState(null);
  const [attackNoteId, setAttackNoteId] = useState("note-201");
  const [message, setMessage] = useState("");

  const currentUser = demoUsers.find(
    (user) => user.id === currentUserId,
  );

  const visibleNotes = useMemo(() => {
    return notes.filter((note) => {
      if (currentUser.role === "ADMIN") {
        return false;
      }

      return note.ownerId === currentUser.id;
    });
  }, [currentUser]);

  function openNote(note) {
    // Bu kontrol sadece arayüz davranışıdır.
    // Gerçek güvenlik sunucuda uygulanmalıdır.
    if (
      currentUser.role !== "ADMIN" &&
      note.ownerId !== currentUser.id
    ) {
      setMessage("Erişim reddedildi: Bu not size ait değil.");
      setSelectedNote(null);
      return;
    }

    if (currentUser.role === "ADMIN") {
      setMessage(
        "Yönetici için ayrıca sunucu tarafı yetki kontrolü gerekir.",
      );
      return;
    }

    setSelectedNote(note);
    setMessage("Not başarıyla görüntülendi.");
  }

  function simulateIdorAttack() {
    const targetNote = notes.find(
      (note) => note.id === attackNoteId,
    );

    if (!targetNote) {
      setMessage("404: Not bulunamadı.");
      return;
    }

    if (
      currentUser.role !== "ADMIN" &&
      targetNote.ownerId !== currentUser.id
    ) {
      setSelectedNote(null);
      setMessage(
        "403 simülasyonu: Başka kullanıcıya ait nota erişim reddedildi.",
      );
      return;
    }

    if (currentUser.role === "ADMIN") {
      setMessage(
        "Yönetici erişimi için tanımlı izin ve iş gereği doğrulanmalıdır.",
      );
      return;
    }

    setSelectedNote(targetNote);
    setMessage("Kendi notunuza erişim sağlandı.");
  }

  function changeUser(event) {
    setCurrentUserId(event.target.value);
    setSelectedNote(null);
    setMessage("");
  }

  return (
    <main className="app">
      <header className="header">
        <div>
          <span className="eyebrow">GÜVENLİK EĞİTİM PROJESİ</span>
          <h1>Güvenli Not Yönetimi</h1>
          <p>
            Kişisel notlarınızı görüntüleyin ve erişim
            politikalarını inceleyin.
          </p>
        </div>

        <div className="user-panel">
          <label htmlFor="user">Demo kullanıcısı</label>
          <select
            id="user"
            value={currentUserId}
            onChange={changeUser}
          >
            {demoUsers.map((user) => (
              <option key={user.id} value={user.id}>
                {user.name} ({user.role})
              </option>
            ))}
          </select>
        </div>
      </header>

      <section className="security-banner">
        <strong>Güvenlik hatırlatması</strong>
        <p>
          Bu uygulamadaki kullanıcı seçimi ve sahiplik
          kontrolleri yalnızca eğitim amaçlıdır. Gerçek
          kimlik doğrulama ve yetkilendirme sunucuda yapılmalıdır.
        </p>
      </section>

      <section className="content">
        <div className="notes-section">
          <div className="section-heading">
            <div>
              <h2>Notlarım</h2>
              <p>
                {currentUser.name} için gösterilen notlar
              </p>
            </div>

            <span className="count">
              {visibleNotes.length} not
            </span>
          </div>

          {currentUser.role === "ADMIN" ? (
            <div className="empty-state">
              <h3>Normal not listesi gösterilmiyor</h3>
              <p>
                Yönetici erişimi otomatik olarak tüm notlara
                erişim anlamına gelmez. Ayrı bir yetki gerekir.
              </p>
            </div>
          ) : (
            <div className="note-grid">
              {visibleNotes.map((note) => (
                <article className="note-card" key={note.id}>
                  <span className="note-label">ÖZEL NOT</span>
                  <h3>{note.title}</h3>
                  <p>{note.content}</p>

                  <div className="note-footer">
                    <code>{note.id}</code>
                    <button onClick={() => openNote(note)}>
                      Görüntüle
                    </button>
                  </div>
                </article>
              ))}
            </div>
          )}
        </div>

        <aside className="attack-panel">
          <span className="eyebrow">GÜVENLİK TESTİ</span>
          <h2>IDOR / BOLA denemesi</h2>

          <p>
            Başka bir kullanıcının not kimliğini girerek
            erişim denemesi yapın.
          </p>

          <label htmlFor="attack-id">Hedef not kimliği</label>

          <input
            id="attack-id"
            value={attackNoteId}
            onChange={(event) =>
              setAttackNoteId(event.target.value)
            }
          />

          <button
            className="danger-button"
            onClick={simulateIdorAttack}
          >
            Erişimi dene
          </button>

          {message && (
            <div className="result" role="status">
              {message}
            </div>
          )}

          {selectedNote && (
            <div className="selected-note">
              <h3>{selectedNote.title}</h3>
              <p>{selectedNote.content}</p>
              <code>{selectedNote.id}</code>
            </div>
          )}
        </aside>
      </section>

      <section className="principles">
        <h2>Güvenlik ilkeleri</h2>

        <div className="principle-grid">
          <div>
            <span>01</span>
            <h3>Kimlik doğrulama</h3>
            <p>Her API isteğinde oturum doğrulanır.</p>
          </div>

          <div>
            <span>02</span>
            <h3>Rol kontrolü</h3>
            <p>Yönetici işlemleri ayrı izin gerektirir.</p>
          </div>

          <div>
            <span>03</span>
            <h3>Sahiplik kontrolü</h3>
            <p>Notun sahibi sunucuda doğrulanır.</p>
          </div>

          <div>
            <span>04</span>
            <h3>Güvenli yanıt</h3>
            <p>Yetkisiz erişim reddedilir.</p>
          </div>
        </div>
      </section>

      <footer>
        Güvenli Not Yönetimi · React Eğitim Uygulaması
      </footer>
    </main>
  );
}

export default App;