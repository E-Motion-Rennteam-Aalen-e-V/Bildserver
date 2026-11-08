# 📸 Blog-Bilder

Dieser Ordner enthält die **Cover-Bilder für Blog-Beiträge**.

---

## Namenskonvention

Das Bild muss **genau so heißen wie der Slug des Blog-Beitrags** (Dateiname ohne `.md`):

```
content/blog/[slug].md  →  public/uploads/blog/[slug].jpg
```

### Beispiele

| Blog-Beitrag (Datei)                        | Bild (Datei)                                     |
|--------------------------------------------|--------------------------------------------------|
| `content/blog/the-restart.md`              | `public/uploads/blog/the-restart.jpg`            |
| `content/blog/meet-and-greet-2026.md`      | `public/uploads/blog/meet-and-greet-2026.jpg`    |
| `content/blog/werkstatt-nachtschicht.md`   | `public/uploads/blog/werkstatt-nachtschicht.jpg` |

---

## Erlaubte Formate

- `.jpg` / `.jpeg` (empfohlen)
- `.png`
- `.webp`

---

## Schritt-für-Schritt: Neuen Blog-Beitrag mit Bild anlegen

1. **Blog-Markdown erstellen** unter `content/blog/mein-titel.md`

2. **Im Frontmatter den Bildpfad eintragen:**
   ```yaml
   ---
   title: "Mein Blog-Titel"
   date: "2026-10-06T12:00:00.000Z"
   author: "E-Motion Team"
   excerpt: "Kurze Zusammenfassung..."
   coverImage: /uploads/blog/mein-titel.jpg
   ---
   ```

3. **Bild hochladen** als `public/uploads/blog/mein-titel.jpg`
   - Gleicher Name wie der Slug (Dateiname der `.md`-Datei)
   - Empfohlene Größe: **1200 × 675 px** (16:9)
   - Maximale Dateigröße: **500 KB**

---

## Aktueller Blog-Beitrag

| Slug              | Bild erwartet unter                            | Status        |
|-------------------|------------------------------------------------|---------------|
| `the-restart`     | `public/uploads/blog/the-restart.jpg`          | ⬆️ Hochladen  |
