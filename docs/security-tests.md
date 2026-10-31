# Güvenli Not Yönetimi - Güvenlik Testleri

## Test ortamı

Kullanıcı A:
- ID: user-A
- Rol: USER
- Token: TOKEN_A

Kullanıcı B:
- ID: user-B
- Rol: USER
- Token: TOKEN_B

Yönetici:
- ID: admin-1
- Rol: ADMIN

Test notları:
- note-101 -> user-A
- note-201 -> user-B

## Test sonuçları

| Test | Senaryo | Beklenen HTTP |
|---|---|---|
| T01 | A kendi notunu okur | 200 |
| T02 | B kendi notunu okur | 200 |
| T03 | A, B'nin notunu okur | 404 |
| T04 | B, A'nın notunu okur | 404 |
| T05 | A kendi notunu siler | 204 |
| T06 | A, B'nin notunu siler | 404 |
| T07 | A kullanıcı rolünü değiştirir | 403 |
| T08 | Token olmadan not okunur | 401 |
| T09 | Yetkisiz yönetici özel notu okur | 404 |
| T10 | Yetkili yönetici izinli erişim yapar | 200 |

## T01 - Kendi notunu okuma

1. TOKEN_A ile kimlik doğrula.
2. GET /v1/notes/note-101 çağrısı yap.
3. HTTP 200 bekle.
4. Notun sahibi user-A olmalı.

## T02 - B kullanıcısının kendi notunu okuması

1. TOKEN_B ile kimlik doğrula.
2. GET /v1/notes/note-201 çağrısı yap.
3. HTTP 200 bekle.
4. Notun sahibi user-B olmalı.

## T03 - IDOR: A kullanıcısının B'nin notunu okuması

1. TOKEN_A ile kimlik doğrula.
2. GET /v1/notes/note-201 çağrısı yap.
3. HTTP 404 bekle.
4. Yanıtta not içeriği bulunmamalı.
5. Veritabanındaki not değişmemeli.

## T04 - B kullanıcısının A'nın notunu okuması

1. TOKEN_B ile kimlik doğrula.
2. GET /v1/notes/note-101 çağrısı yap.
3. HTTP 404 bekle.
4. Not içeriği dönmemeli.

## T05 - Kendi notunu silme

1. TOKEN_A ile kimlik doğrula.
2. DELETE /v1/notes/note-101 çağrısı yap.
3. HTTP 204 bekle.
4. Notun silindiğini doğrula.

## T06 - Başka kullanıcının notunu silme

1. TOKEN_A ile kimlik doğrula.
2. DELETE /v1/notes/note-201 çağrısı yap.
3. HTTP 404 bekle.
4. note-201 veritabanında kalmalı.

## T07 - Yetkisiz rol değiştirme

1. TOKEN_A ile kimlik doğrula.
2. PATCH /v1/admin/users/user-B/role çağrısı yap.
3. Role ADMIN göndermeyi dene.
4. HTTP 403 bekle.
5. Kullanıcı B'nin rolü USER olarak kalmalı.

## T08 - Kimlik doğrulamasız erişim

1. Authorization başlığı olmadan istek gönder.
2. GET /v1/notes/note-101 çağrısı yap.
3. HTTP 401 bekle.
4. Not içeriği dönmemeli.

## T09 - Yetkisiz yönetici erişimi

1. Yönetici rolü olan fakat notes:read:any izni olmayan
   kullanıcıyla giriş yap.
2. GET /v1/notes/note-201 çağrısı yap.
3. İş gereği koşulunun da sağlanmadığını doğrula.
4. HTTP 404 bekle.

## T10 - Yetkili yönetici erişimi

1. Geçerli yönetici token'ı kullan.
2. notes:read:any iznini doğrula.
3. İş gereği koşulunu doğrula.
4. GET /v1/notes/note-201 çağrısı yap.
5. HTTP 200 bekle.

## Ek güvenlik kontrolleri

- userId alanı değiştirilerek erişim denenmeli.
- Sahte veya süresi geçmiş token denenmeli.
- Rastgele noteId değerleri denenmeli.
- Yönetici izinleri kaldırılarak tekrar test yapılmalı.
- Silme işlemlerinde sahiplik kontrolü tekrar doğrulanmalı.
- Yetkisiz erişim kayıtları hassas veri içermeden loglanmalı.

## Sonuç

Testler gerçek backend üzerinde çalıştırılmadan
sistem güvenli olarak kabul edilmemelidir.