# Güvenli Not Yönetimi ve Yetkilendirme Sistemi

React ve Flutter ile geliştirilmiş, nesne seviyesinde
erişim kontrolünü (BOLA/IDOR) öğretmeyi amaçlayan eğitim projesi.

## Proje amacı

Kullanıcıların yalnızca kendi özel notlarına erişebilmesini
ve yönetici işlemlerinin sunucu tarafında yetkilendirilmesini
örneklemek.

## Teknolojiler

- React
- Vite
- JavaScript
- Flutter
- Dart
- Git
- GitHub

## Proje yapısı

- web/: React uygulaması
- mobile/: Flutter uygulaması
- notes/: Erişim kontrol matrisi
- docs/: API sözleşmesi ve güvenlik belgeleri

## Özellikler

- Kullanıcı A ve B için örnek not listeleri
- Yönetici rolü simülasyonu
- Not kimliği değiştirerek erişim denemesi
- IDOR/BOLA güvenlik açıklamaları
- API güvenlik sözleşmesi
- Sunucu tarafı yetkilendirme sözde kodu
- 10 güvenlik test senaryosu

## Kurulum

### React

Ana proje klasöründen:

cd web
npm install
npm run dev

### Flutter

Ana proje klasöründen:

cd mobile
flutter pub get
flutter run

## Güvenlik

React ve Flutter içindeki erişim kontrolleri yalnızca
arayüz davranışıdır.

Gerçek güvenlik için:

1. Her istekte kimlik doğrulaması yapılmalıdır.
2. Kullanıcı kimliği doğrulanmış oturumdan alınmalıdır.
3. Rol ve işlem izinleri kontrol edilmelidir.
4. Not sahipliği sunucuda doğrulanmalıdır.
5. Yetkisiz erişimler reddedilmelidir.

## Belgeler

- notes/access-control.md
- docs/api-contract.md
- docs/server-authorization.md
- docs/security-tests.md

## Önemli uyarı

Bu proje gerçek backend içermez. React ve Flutter örnekleri
eğitim amaçlı istemci simülasyonlarıdır.

Backend sözde kodu, gerçek bir kimlik doğrulama ve
yetkilendirme sunucusunun yerine geçmez.

Üretim ortamında kullanmadan önce gerçek backend,
veritabanı, token doğrulaması ve güvenlik testleri
uygulanmalıdır.