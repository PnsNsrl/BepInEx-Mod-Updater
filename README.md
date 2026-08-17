# 🔄 BepInEx Mod Updater

> **Automatic mod updates for ANY game with BepInEx — directly from ThunderStore, no launcher required.**

**[🇬🇧 English](#-english) | [🇷🇺 Русский](#-русский) | [🇪🇸 Español](#-español) | [🇧🇷 Português](#-português) | [🇩🇪 Deutsch](#-deutsch) | [🇫🇷 Français](#-français)**

---

## 🇬🇧 English

> **Automatic mod updates for ANY game with BepInEx — directly from ThunderStore, no launcher required.**

### 📦 Installation

1. Download `BepInExUpdater.exe` from [**Releases**](../../releases)
2. Put it **anywhere** — the program scans ALL your Steam libraries (C:, D:, ...) and finds every game with BepInEx by itself
3. Run `BepInExUpdater.exe`

### 🎮 How to use

1. Run the program
2. It scans all Steam libraries and lists games with BepInEx (if there are several — pick one by number)
3. It fetches the ThunderStore catalog and scans your mods
4. A report appears:
   ```
   --- CHECK RESULTS ---
     [OK]        Mod1 1.7.2
     [UPDATE]    Mod2: 3.0.1  ->  3.0.2
     [NOT FOUND] Mod3 1.0.0 (not on ThunderStore, skipped)
   ```
5. If updates are available it asks: `Do you want to update these mods? (Yes - 1, No - 2)`
6. After updating — a summary and the backups path

### 🛡️ Safety

- Before every update the old mod version is **moved to a backup**, not deleted
- If download or extraction fails — **automatic rollback**
- Downloaded archives are verified by **zip signature (PK)** and **exact size** from the ThunderStore API
- The program never touches anything outside the folders of the mods being updated

### 🌍 Languages

The program speaks **6 languages** — the language is picked automatically from your Windows language:

| Language | Code |
|---|---|
| 🇬🇧 English | `en` |
| 🇷🇺 Русский | `ru` |
| 🇪🇸 Español | `es` |
| 🇧🇷 Português (BR) | `pt` |
| 🇩🇪 Deutsch | `de` |
| 🇫🇷 Français | `fr` |

**How to change the language:**
1. Run the program with the `/lang` argument:
   - create a shortcut to `BepInExUpdater.exe`, open its properties and append ` /lang` to the path;
   - or in PowerShell: `.\BepInExUpdater.exe /lang`
2. Pick a language by number (1–6) — the choice is saved to `lang.txt` next to the program
3. To return to auto-detection — just delete `lang.txt`

### ❓ FAQ

**The program found no games**
It looks for games with a `BepInEx` folder inside `Steam\steamapps\common\<game>`. Make sure BepInEx is installed.

**A mod is listed as `[NOT FOUND]`**
That mod is not on ThunderStore (local/removed mod) — it is simply skipped.

**What are "loose" .dll files in the report?**
Those are mods dropped into `plugins` as a single file without a folder. Their version cannot be detected. Unzip the mod's zip as a folder — and updates become automatic.

**The game is running — can I still update?**
The program will warn you and ask. Better close the game: mod files are locked and the update may fail.

**Where are the old mod versions?**
In the `.mod_backups` folder inside `plugins`. The last 3 versions of each mod are kept, older ones are cleaned automatically.

---

## 🇷🇺 Русский

> **Автоматическое обновление модов для ЛЮБОЙ игры с BepInEx — напрямую с ThunderStore, без установки лаунчера.**

### 📦 Установка

1. Скачайте `BepInExUpdater.exe` из раздела [**Releases**](../../releases)
2. Положите его **куда угодно** — программа сама просканирует все библиотеки Steam (C:, D:, ...) и найдёт все игры с BepInEx
3. Запустите `BepInExUpdater.exe`

### 🎮 Как пользоваться

1. Запустите программу
2. Она просканирует все библиотеки Steam и покажет игры с BepInEx (если их несколько — выберите нужную по номеру)
3. Программа получит каталог ThunderStore и просканирует ваши моды
4. Появится отчёт:
   ```
   --- РЕЗУЛЬТАТ ПРОВЕРКИ ---
     [OK]        Мод1 1.7.2
     [UPDATE]    Мод2: 3.0.1  ->  3.0.2
     [NOT FOUND] Мод3 1.0.0 (нет на ThunderStore, пропущен)
   ```
5. Если есть обновления — программа спросит: `Хотите ли вы обновить данные моды? (Да - 1, Нет - 2)`
6. После обновления — итог и путь к бэкапам

### 🛡️ Безопасность

- Перед каждым обновлением старая версия мода **перемещается в бэкап**, а не удаляется
- Если скачивание или распаковка упали — **автоматический откат** на место
- Скачанный архив проверяется по **zip-сигнатуре (PK)** и **точному размеру** из API ThunderStore
- Программа ничего не трогает за пределами папок обновляемых модов

### 🌍 Языки

Программа говорит на **6 языках** — язык выбирается автоматически по языку Windows:

| Язык | Код |
|---|---|
| 🇬🇧 English | `en` |
| 🇷🇺 Русский | `ru` |
| 🇪🇸 Español | `es` |
| 🇧🇷 Português (BR) | `pt` |
| 🇩🇪 Deutsch | `de` |
| 🇫🇷 Français | `fr` |

**Как сменить язык:**
1. Запустите программу с аргументом `/lang`:
   - создайте ярлык на `BepInExUpdater.exe`, откройте свойства и допишите ` /lang` после пути;
   - либо в PowerShell: `.\BepInExUpdater.exe /lang`
2. Выберите язык цифрой (1–6) — выбор сохранится в файл `lang.txt` рядом с программой
3. Чтобы вернуться к автоопределению — просто удалите `lang.txt`

### ❓ FAQ

**Программа не нашла игры**
Она ищет игры с папкой `BepInEx` внутри `Steam\steamapps\common\<игра>`. Убедитесь, что BepInEx установлен.

**Мод в списке `[NOT FOUND]`**
Такого мода нет на ThunderStore (локальный/удалённый мод) — он просто пропускается.

**Что за «голые» .dll в отчёте?**
Это моды, кинутые в `plugins` одним файлом без папки. Их версию определить нельзя. Распакуйте zip мода папкой — и обновление станет автоматическим.

**Игра запущена — можно обновляться?**
Программа предупредит и спросит. Лучше закрыть игру: файлы модов заблокированы, обновление может упасть.

**Где старые версии модов?**
В папке `.mod_backups` внутри `plugins`. Хранятся последние 3 версии каждого мода, старые чистятся автоматически.

---

## 🇪🇸 Español

> **Actualización automática de mods para CUALQUIER juego con BepInEx — directamente desde ThunderStore, sin instalar ningún launcher.**

### 📦 Instalación

1. Descarga `BepInExUpdater.exe` desde [**Releases**](../../releases)
2. Ponlo **donde quieras** — el programa escanea TODAS tus bibliotecas de Steam (C:, D:, ...) y encuentra cada juego con BepInEx por sí mismo
3. Ejecuta `BepInExUpdater.exe`

### 🎮 Cómo usarlo

1. Ejecuta el programa
2. Escanea todas las bibliotecas de Steam y muestra los juegos con BepInEx (si hay varios — elige uno por número)
3. Obtiene el catálogo de ThunderStore y escanea tus mods
4. Aparece un informe:
   ```
   --- RESULTADOS DE LA COMPROBACIÓN ---
     [OK]        Mod1 1.7.2
     [UPDATE]    Mod2: 3.0.1  ->  3.0.2
     [NOT FOUND] Mod3 1.0.0 (no está en ThunderStore, omitido)
   ```
5. Si hay actualizaciones, pregunta: `¿Quieres actualizar estos mods? (Sí - 1, No - 2)`
6. Tras actualizar — resumen y ruta de las copias de seguridad

### 🛡️ Seguridad

- Antes de cada actualización, la versión antigua del mod **se mueve a una copia de seguridad**, no se borra
- Si la descarga o extracción falla — **reversión automática**
- Los archivos descargados se verifican por la **firma zip (PK)** y el **tamaño exacto** de la API de ThunderStore
- El programa no toca nada fuera de las carpetas de los mods que se actualizan

### 🌍 Idiomas

El programa habla **6 idiomas** — el idioma se elige automáticamente según tu idioma de Windows:

| Idioma | Código |
|---|---|
| 🇬🇧 English | `en` |
| 🇷🇺 Русский | `ru` |
| 🇪🇸 Español | `es` |
| 🇧🇷 Português (BR) | `pt` |
| 🇩🇪 Deutsch | `de` |
| 🇫🇷 Français | `fr` |

**Cómo cambiar el idioma:**
1. Ejecuta el programa con el argumento `/lang`:
   - crea un acceso directo a `BepInExUpdater.exe`, abre sus propiedades y añade ` /lang` tras la ruta;
   - o en PowerShell: `.\BepInExUpdater.exe /lang`
2. Elige el idioma con un número (1–6) — la elección se guarda en `lang.txt` junto al programa
3. Para volver a la detección automática — simplemente borra `lang.txt`

### ❓ FAQ

**El programa no encuentra juegos**
Busca juegos con carpeta `BepInEx` dentro de `Steam\steamapps\common\<juego>`. Asegúrate de que BepInEx está instalado.

**Un mod aparece como `[NOT FOUND]`**
Ese mod no está en ThunderStore (mod local/eliminado) — simplemente se omite.

**¿Qué son los .dll "sueltos" del informe?**
Son mods echados en `plugins` como un solo archivo sin carpeta. No se puede detectar su versión. Descomprime el zip del mod como carpeta — y las actualizaciones serán automáticas.

**El juego está en marcha — ¿puedo actualizar?**
El programa te avisará y preguntará. Mejor cierra el juego: los archivos están bloqueados y la actualización puede fallar.

**¿Dónde están las versiones antiguas de los mods?**
En la carpeta `.mod_backups` dentro de `plugins`. Se guardan las últimas 3 versiones de cada mod, las más antiguas se limpian automáticamente.

---

## 🇧🇷 Português

> **Atualização automática de mods para QUALQUER jogo com BepInEx — direto do ThunderStore, sem instalar launcher.**

### 📦 Instalação

1. Baixe o `BepInExUpdater.exe` em [**Releases**](../../releases)
2. Coloque-o **onde quiser** — o programa escaneia TODAS as suas bibliotecas da Steam (C:, D:, ...) e encontra cada jogo com BepInEx sozinho
3. Execute o `BepInExUpdater.exe`

### 🎮 Como usar

1. Execute o programa
2. Ele escaneia todas as bibliotecas da Steam e mostra os jogos com BepInEx (se houver vários — escolha um pelo número)
3. Ele obtém o catálogo do ThunderStore e escaneia seus mods
4. Aparece um relatório:
   ```
   --- RESULTADO DA VERIFICAÇÃO ---
     [OK]        Mod1 1.7.2
     [UPDATE]    Mod2: 3.0.1  ->  3.0.2
     [NOT FOUND] Mod3 1.0.0 (não está no ThunderStore, ignorado)
   ```
5. Se houver atualizações, ele pergunta: `Deseja atualizar estes mods? (Sim - 1, Não - 2)`
6. Após atualizar — resumo e caminho dos backups

### 🛡️ Segurança

- Antes de cada atualização, a versão antiga do mod **é movida para um backup**, não apagada
- Se o download ou a extração falharem — **reversão automática**
- Os arquivos baixados são verificados pela **assinatura zip (PK)** e pelo **tamanho exato** da API do ThunderStore
- O programa não toca em nada fora das pastas dos mods que estão sendo atualizados

### 🌍 Idiomas

O programa fala **6 idiomas** — o idioma é escolhido automaticamente pelo idioma do seu Windows:

| Idioma | Código |
|---|---|
| 🇬🇧 English | `en` |
| 🇷🇺 Русский | `ru` |
| 🇪🇸 Español | `es` |
| 🇧🇷 Português (BR) | `pt` |
| 🇩🇪 Deutsch | `de` |
| 🇫🇷 Français | `fr` |

**Como mudar o idioma:**
1. Execute o programa com o argumento `/lang`:
   - crie um atalho para `BepInExUpdater.exe`, abra as propriedades e acrescente ` /lang` após o caminho;
   - ou no PowerShell: `.\BepInExUpdater.exe /lang`
2. Escolha o idioma pelo número (1–6) — a escolha é salva em `lang.txt` junto ao programa
3. Para voltar à detecção automática — basta apagar o `lang.txt`

### ❓ FAQ

**O programa não encontra jogos**
Ele procura jogos com pasta `BepInEx` dentro de `Steam\steamapps\common\<jogo>`. Verifique se o BepInEx está instalado.

**Um mod aparece como `[NOT FOUND]`**
Esse mod não está no ThunderStore (mod local/removido) — ele é simplesmente ignorado.

**O que são os .dll "soltos" do relatório?**
São mods jogados em `plugins` como um único arquivo sem pasta. Não dá para detectar a versão deles. Extraia o zip do mod como pasta — e as atualizações ficarão automáticas.

**O jogo está em execução — posso atualizar?**
O programa avisará e perguntará. Melhor fechar o jogo: os arquivos dos mods ficam bloqueados e a atualização pode falhar.

**Onde estão as versões antigas dos mods?**
Na pasta `.mod_backups` dentro de `plugins`. São guardadas as últimas 3 versões de cada mod, as mais antigas são limpas automaticamente.

---

## 🇩🇪 Deutsch

> **Automatische Mod-Updates für JEDES Spiel mit BepInEx — direkt von ThunderStore, ohne Launcher.**

### 📦 Installation

1. Lade die `BepInExUpdater.exe` aus [**Releases**](../../releases) herunter
2. Lege sie **ab, wo du willst** — das Programm durchsucht ALLE deine Steam-Bibliotheken (C:, D:, ...) und findet jedes Spiel mit BepInEx von selbst
3. Starte `BepInExUpdater.exe`

### 🎮 Benutzung

1. Programm starten
2. Es durchsucht alle Steam-Bibliotheken und zeigt die Spiele mit BepInEx (bei mehreren — wähle eines per Nummer)
3. Es lädt den ThunderStore-Katalog und durchsucht deine Mods
4. Ein Bericht erscheint:
   ```
   --- PRÜFERGEBNIS ---
     [OK]        Mod1 1.7.2
     [UPDATE]    Mod2: 3.0.1  ->  3.0.2
     [NOT FOUND] Mod3 1.0.0 (nicht auf ThunderStore, übersprungen)
   ```
5. Gibt es Updates, fragt es: `Möchtest du diese Mods aktualisieren? (Ja - 1, Nein - 2)`
6. Nach dem Update — Zusammenfassung und Backup-Pfad

### 🛡️ Sicherheit

- Vor jedem Update wird die alte Mod-Version **in ein Backup verschoben**, nicht gelöscht
- Schlägt Download oder Entpacken fehl — **automatischer Rollback**
- Heruntergeladene Archive werden per **Zip-Signatur (PK)** und **exakter Größe** aus der ThunderStore-API geprüft
- Das Programm fasst nichts außerhalb der Ordner der zu aktualisierenden Mods an

### 🌍 Sprachen

Das Programm spricht **6 Sprachen** — die Sprache wird automatisch anhand deiner Windows-Sprache gewählt:

| Sprache | Code |
|---|---|
| 🇬🇧 English | `en` |
| 🇷🇺 Русский | `ru` |
| 🇪🇸 Español | `es` |
| 🇧🇷 Português (BR) | `pt` |
| 🇩🇪 Deutsch | `de` |
| 🇫🇷 Français | `fr` |

**So änderst du die Sprache:**
1. Starte das Programm mit dem Argument `/lang`:
   - erstelle eine Verknüpfung zu `BepInExUpdater.exe`, öffne die Eigenschaften und hänge ` /lang` an den Pfad an;
   - oder in PowerShell: `.\BepInExUpdater.exe /lang`
2. Wähle die Sprache per Nummer (1–6) — die Wahl wird in `lang.txt` neben dem Programm gespeichert
3. Um zur automatischen Erkennung zurückzukehren — lösche einfach die `lang.txt`

### ❓ FAQ

**Das Programm findet keine Spiele**
Es sucht nach Spielen mit einem `BepInEx`-Ordner in `Steam\steamapps\common\<Spiel>`. Stelle sicher, dass BepInEx installiert ist.

**Ein Mod erscheint als `[NOT FOUND]`**
Dieser Mod ist nicht auf ThunderStore (lokaler/entfernter Mod) — er wird einfach übersprungen.

**Was sind die „losen" .dll-Dateien im Bericht?**
Das sind Mods, die als einzelne Datei ohne Ordner in `plugins` geworfen wurden. Ihre Version ist nicht erkennbar. Entpacke das Zip des Mods als Ordner — dann werden Updates automatisch.

**Das Spiel läuft — kann ich trotzdem updaten?**
Das Programm warnt und fragt. Besser das Spiel schließen: Die Mod-Dateien sind gesperrt und das Update kann fehlschlagen.

**Wo sind die alten Mod-Versionen?**
Im Ordner `.mod_backups` innerhalb von `plugins`. Die letzten 3 Versionen jedes Mods bleiben erhalten, ältere werden automatisch gelöscht.

---

## 🇫🇷 Français

> **Mise à jour automatique des mods pour N'IMPORTE quel jeu avec BepInEx — directement depuis ThunderStore, sans launcher.**

### 📦 Installation

1. Téléchargez `BepInExUpdater.exe` depuis [**Releases**](../../releases)
2. Mettez-le **où vous voulez** — le programme scanne TOUTES vos bibliothèques Steam (C:, D:, ...) et trouve chaque jeu avec BepInEx tout seul
3. Lancez `BepInExUpdater.exe`

### 🎮 Utilisation

1. Lancez le programme
2. Il scanne toutes les bibliothèques Steam et affiche les jeux avec BepInEx (s'il y en a plusieurs — choisissez-en un par numéro)
3. Il récupère le catalogue ThunderStore et scanne vos mods
4. Un rapport apparaît :
   ```
   --- RÉSULTAT DE LA VÉRIFICATION ---
     [OK]        Mod1 1.7.2
     [UPDATE]    Mod2: 3.0.1  ->  3.0.2
     [NOT FOUND] Mod3 1.0.0 (absent de ThunderStore, ignoré)
   ```
5. S'il y a des mises à jour, il demande : `Voulez-vous mettre à jour ces mods ? (Oui - 1, Non - 2)`
6. Après la mise à jour — bilan et chemin des sauvegardes

### 🛡️ Sécurité

- Avant chaque mise à jour, l'ancienne version du mod est **déplacée dans une sauvegarde**, pas supprimée
- Si le téléchargement ou l'extraction échoue — **annulation automatique**
- Les archives téléchargées sont vérifiées par la **signature zip (PK)** et la **taille exacte** de l'API ThunderStore
- Le programme ne touche à rien en dehors des dossiers des mods mis à jour

### 🌍 Langues

Le programme parle **6 langues** — la langue est choisie automatiquement selon votre langue Windows :

| Langue | Code |
|---|---|
| 🇬🇧 English | `en` |
| 🇷🇺 Русский | `ru` |
| 🇪🇸 Español | `es` |
| 🇧🇷 Português (BR) | `pt` |
| 🇩🇪 Deutsch | `de` |
| 🇫🇷 Français | `fr` |

**Comment changer de langue :**
1. Lancez le programme avec l'argument `/lang` :
   - créez un raccourci vers `BepInExUpdater.exe`, ouvrez ses propriétés et ajoutez ` /lang` après le chemin ;
   - ou dans PowerShell : `.\BepInExUpdater.exe /lang`
2. Choisissez la langue par numéro (1–6) — le choix est enregistré dans `lang.txt` à côté du programme
3. Pour revenir à la détection automatique — supprimez simplement `lang.txt`

### ❓ FAQ

**Le programme ne trouve aucun jeu**
Il cherche des jeux avec un dossier `BepInEx` dans `Steam\steamapps\common\<jeu>`. Vérifiez que BepInEx est installé.

**Un mod apparaît comme `[NOT FOUND]`**
Ce mod n'est pas sur ThunderStore (mod local/supprimé) — il est simplement ignoré.

**Que sont les .dll « isolés » du rapport ?**
Ce sont des mods déposés dans `plugins` en un seul fichier sans dossier. Leur version est indéterminable. Décompressez le zip du mod en dossier — et les mises à jour deviendront automatiques.

**Le jeu est en cours d'exécution — puis-je mettre à jour ?**
Le programme vous avertira et demandera. Mieux vaut fermer le jeu : les fichiers des mods sont verrouillés et la mise à jour peut échouer.

**Où sont les anciennes versions des mods ?**
Dans le dossier `.mod_backups` dans `plugins`. Les 3 dernières versions de chaque mod sont conservées, les plus anciennes sont nettoyées automatiquement.

---

## 🔧 Build the .exe from source

```powershell
Install-Module ps2exe -Scope CurrentUser
Invoke-ps2exe -inputFile .\BepInExUpdater.ps1 -outputFile .\BepInExUpdater.exe `
    -title 'BepInEx Mod Updater' -version '1.1'
```

---

## 📜 Changelog

### v1.1.0
- 🔭 **Universal**: works with ANY game that has BepInEx + a ThunderStore community
- 📚 Scans ALL Steam libraries on ALL drives (registry + `libraryfolders.vdf`)
- 🎮 Game selection when several games with BepInEx are installed
- ⚡ Whole ThunderStore catalog fetched in ONE request (fast and reliable)
- 🛡️ Backups (last 3 per mod) and automatic rollback
- 📦 Dependency check and download integrity verification
- 📄 Log file `updater_log.txt`
- 🎨 Pretty console: banner, large font, centering, scrolling
- 🌍 Localization: 6 languages (en/ru/es/pt/de/fr) with auto-detection and manual selection (`/lang`)

### v1.0
- First public release (PEAK-only version)