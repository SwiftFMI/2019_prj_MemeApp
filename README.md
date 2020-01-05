# Meme generator

Приложение за създаване и споделяне на мийм (meme) картинки с текст. 
Чрез приложението може да се избере от картинка в галерията на приложението или от тази на устройството и да се въведат горен и/или долен текст. 
Текстът се изрисува върху изображението и то може да се споделя чрез системното меню в други приложения или да бъде запазено в галерията. 
Запазване на мийм във firebase realtime database, за да се вижда и от други потребители.

# Елементи на приложението:

* Начален екран - може да се разгледат заготовки от изображения или да се избере от галерията;
* Екран за редактиране - потребителят може да въведе горен и/или долен текст;
* Системно меню за споделяне:
 * messages, facebook, save to photos, etc.;
* Екран с галерия от генерирани мийм от други потребители
 * Възможност за преглеждане, скролиране (scroll, pan) и увеличаване (zoom) на изображение от списъка
* Бонус - избор на шрифтове и размери от списък

# Технически елементи:
* [Firebase Realtime Database](https://firebase.google.com/docs/database/ios/start)
* [Firebase Storage](https://firebase.google.com/docs/storage/ios/start)
* Четене и писане във файловата система
* Photos


Финален проект за ИД "Програмиране за iOS със Swift" 2019/2020