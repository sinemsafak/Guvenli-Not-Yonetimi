# Güvenli Not Yönetimi API Sözleşmesi

## 1. Genel bilgiler

API Base URL:
https://api.example.com/v1

İçerik türü:
application/json

Kimlik doğrulama:
Authorization: Bearer <access_token>

HTTPS zorunludur.

## 2. Kullanıcı kimliği

Kullanıcı kimliği doğrulanmış token veya sunucu oturumundan
elde edilir.

İstemcinin gönderdiği userId alanı kimlik doğrulama
amacıyla kullanılmaz.

## 3. Notları listeleme

GET /notes

Başlık:
Authorization: Bearer <access_token>

Başarılı yanıt: 200 OK

Örnek:

{
  "items": [
    {
      "id": "note-101",
      "title": "Proje planı",
      "content": "Proje geliştirme adımları"
    }
  ]
}

Sunucu yalnızca oturumdaki kullanıcının erişebildiği
notları döndürür.

## 4. Not görüntüleme

GET /notes/{noteId}

Örnek:

GET /notes/note-101

Başarılı yanıt: 200 OK

{
  "id": "note-101",
  "title": "Proje planı",
  "content": "Proje geliştirme adımları"
}

Sunucu notun sahibini kontrol eder.

## 5. Not silme

DELETE /notes/{noteId}

Normal kullanıcı yalnızca kendi notunu silebilir.

Yönetici yalnızca tanımlı silme yetkisi ve iş gereği
bulunuyorsa işlem yapabilir.

Başarılı yanıt: 204 No Content

## 6. Kullanıcı rolünü değiştirme

PATCH /admin/users/{userId}/role

Örnek istek:

{
  "role": "ADMIN"
}

Bu işlem normal kullanıcılara açık değildir.

Sunucu:
- Kimliği doğrular.
- Yönetici rolünü doğrular.
- Kullanıcı yönetimi yetkisini kontrol eder.
- İşlem için gerekli politikaları uygular.
- İşlemi güvenlik kayıtlarına yazar.

## 7. HTTP yanıtları

200 OK:
İstek başarıyla tamamlandı.

204 No Content:
Silme işlemi başarıyla tamamlandı.

400 Bad Request:
İstek biçimi geçersiz.

401 Unauthorized:
Kimlik doğrulaması yok veya geçersiz.

403 Forbidden:
Kimliği doğrulanmış kullanıcının işlem yetkisi yok.

404 Not Found:
Kaynak bulunamadı veya varlığı gizlilik nedeniyle
açıklanmıyor.

500 Internal Server Error:
Beklenmeyen sunucu hatası.

## 8. Güvenlik

- Tüm korumalı endpoint'lerde kimlik doğrulaması yapılır.
- Kullanıcı kimliği sunucuda doğrulanmış oturumdan alınır.
- İstemciden gelen userId güvenilir kabul edilmez.
- Not sahipliği sunucu tarafında kontrol edilir.
- Rol ve işlem izinleri sunucu tarafında kontrol edilir.
- Yönetici erişimi varsayılan olarak sınırsız değildir.
- İstek ve erişim kayıtları hassas veri içermeyecek şekilde tutulur.