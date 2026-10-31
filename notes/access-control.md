# Not Yönetimi - Erişim Kontrol Matrisi

## 1. Roller

- USER: Normal kullanıcı
- ADMIN: Yönetici

## 2. Temel kurallar

1. Her kullanıcı yalnızca kendisine ait özel notları görebilir.
2. Not kimliği tahmin edilebilir veya değiştirilebilir olsa bile
   başka kullanıcının notuna erişim sağlanamaz.
3. Kullanıcı rolünü normal kullanıcı değiştiremez.
4. Yönetici işlemleri sunucu tarafında ayrıca yetkilendirilir.
5. İstemcideki buton gizleme işlemi güvenlik kontrolü değildir.

## 3. Erişim matrisi

| İşlem | Normal kullanıcı | Yönetici |
|---|---|---|
| Kendi notunu görüntüleme | İzin ver | İzin ver |
| Başka kullanıcının özel notunu görüntüleme | Reddet | Yalnızca tanımlı yetki ve iş gereği varsa |
| Kullanıcı rolünü değiştirme | Reddet | Sunucu politikasıyla sınırla |
| Not silme | Yalnızca kendi notu | Tanımlı yetkiye göre |

## 4. Kimlik ve sahiplik politikası

- Kullanıcı kimliği doğrulanmış oturumdan elde edilir.
- İstek gövdesindeki userId alanına güvenilmez.
- Her not isteğinde sahiplik kontrolü yapılır.
- Normal kullanıcı başka kullanıcının notunu okuyamaz veya silemez.
- Yönetici de varsayılan olarak sınırsız erişime sahip değildir.

## 5. Yetkilendirme

- Kimlik doğrulaması yoksa HTTP 401.
- Kimlik doğrulaması var ancak rol/yetki yoksa HTTP 403.
- Kaynak bulunmuyorsa veya gizlilik politikası nedeniyle
  kaynağın varlığı açıklanmıyorsa HTTP 404.
- Başarılı işlemlerde uygun HTTP 2xx yanıtı döndürülür.

## 6. Güvenlik ilkesi

Erişim kontrolünün nihai kararı yalnızca güvenilir
sunucu tarafında verilmelidir.