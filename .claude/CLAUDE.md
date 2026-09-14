# ADFD — Lab 5 & Lab 6 (Team E)

## What this repo is

A **university group assignment** for a Flutter course, not a production app.
Team E owns two labs out of six; the other four belong to other teams.

| Lab | Topic | Stack |
|---|---|---|
| **Lab 5** — `adfd05_architecture/` | Clean Architecture on the client | Flutter + SQLite |
| **Lab 6** — `adfd06_rest_api/` | Full-stack REST | Spring Boot + MySQL + Flutter |

Team E: **Mai Trung Hậu** · **Phạm Hoàng Tuấn** (leader) · **Lê Minh Trí** ·
**Lâm Hoàng An**. The repo owner is Hậu.

The deliverable was a **presentation**, so readability and explainability matter
more than cleverness. Every design decision must be defensible out loud to a
lecturer.

---

## Current state — presentation DELIVERED

The presentation was built and given. Both demo apps run end to end, verified on
an Android emulator against a live MySQL.

**What that means for you:** the code and the slide material are a matched pair.
Changing a class name, a folder, or an improvement number can silently
invalidate a document, a diagram, or a spoken script. Before renaming or moving
anything, grep `docs/` for the old name.

Work now falls into two buckets:

1. **Maintenance and Q&A** — explaining the code, fixing small defects,
   preparing answers to lecturer questions.
2. **Continued improvement** — refactors and features are welcome, subject to
   the constraints below.

---

## Read these before answering questions

`docs/` is the reasoning behind everything here. It is written in Vietnamese and
is **more authoritative than your own reading of the code** on questions of
*why*.

| File | What it answers |
|---|---|
| `docs/tong-quan-lab-5-6.md` | What the two labs do, big picture |
| `docs/cau-truc-du-an.md` | Folder layout and **why** |
| `docs/luong-chay-chuong-trinh.md` | Runtime flow from `main()` to screen |
| `docs/hieu-sau-lab-5.md` | **Deep dive on Lab 5** — 7 parts, 18 self-check questions |
| `docs/kich-ban-thuyet-trinh-lab-5.md` | Spoken script, slides 1–13, with images |
| `docs/lenh-hay-dung.md` | Command reference and troubleshooting |
| `docs/phan-cong-task.md` | Who presented what |
| `docs/slide-thuyet-trinh-v2.md` | Slide content, 25 slides — **the version in use** |
| `docs/slide-noi-dung-thuan.md` | Screen text only, input for Canva |
| `docs/slide-thuyet-trinh.md` | v1, 39 slides — superseded, kept for reference |

`reference/` holds the **lecturer's original material** for all six labs — the
PDF brief and his untouched source. When a question is "does this match what the
lecturer asked for?", that folder is the answer, not memory.

`docs/assets/` holds 8 hand-drawn SVG diagrams (`so-do-1..8`), app screenshots,
per-slide PNGs used by the script (`slides/`), and the full exported deck
(`slides-export/`).

---

## Layout

```
adfd-group-assignment/
├── docker-compose.yml            MySQL 8 + phpMyAdmin (see caveat below)
├── db/init.sql                   schema + 5 seed rows
├── docs/                         team documentation + slides (Vietnamese)
├── reference/lab-1 … lab-6/      lecturer's original briefs and source
├── adfd05_architecture/          Flutter — Lab 5, 5 flows
└── adfd06_rest_api/
    ├── adfd06_backend/           Spring Boot 4.1.1, port 8082
    └── adfd06_frontend/          Flutter — Lab 6, 4 flows
```

The two Flutter projects are **standalone** — each has its own `pubspec.lock`.
There is no pub workspace. Run `flutter pub get` inside each project.

---

## The `exNN/` convention — do not "fix" this

Every Flutter project here holds **several versions of the same app**, one per
teaching step. The lecturer calls each step a **"Flow"** — his own word, not a
Flutter concept.

```
lib/
├── main.dart          ← pick a Flow by uncommenting ONE import
├── ex01_flow.dart     ← each defines its own class MyApp
├── ex01/              ← code belonging to Flow 1
├── ex02_flow.dart
├── ex02/
└── ...
```

This looks wrong by normal Flutter standards, and it is — for a normal app. Here
it is **deliberate**: it lets the team demo the progression step by step. Do not
propose flattening it, merging flows, or renaming `exNN`. The brief lists these
exact paths.

> "Flow" here has nothing to do with Flutter's `Flow` widget or the FlutterFlow
> product. Do not conflate them.

---

## Architecture — both labs share one shape

The final flow of each lab (`ex05/` in Lab 5, `ex04/` in Lab 6) uses the same
layering:

```
Page (UI)  →  Provider  →  I<X>Repository        ← domain: contract only
                                 ↑
                         <X>RepositoryImpl       ← data: Model ⇄ Entity mapping
                                 ↓
                          I<X>DataSource         ← data: contract
                                 ↑
                        <X>DataSourceImpl
                                 ↓
        Lab 5: DatabaseHelper → SQLite
        Lab 6: ApiClient      → HTTP → Spring Boot → MySQL
```

Wired with **GetIt** at `<flutter-project>/lib/<final-flow>/core/di/injection.dart`.

**Rules that hold in both labs:**

- Domain never imports from `data/` — the dependency arrow only points inward
- `Entity` knows nothing about JSON, SQL, or `null` from the wire
- `Model` is the only place that knows the storage representation
- **Repository is the only place that knows both `Model` and `Entity`**
- Data sources speak raw `Map<String, dynamic>`, never `Entity`

**The division that gets asked about most:** a Data Source knows *where to fetch
from* — SQL, table names, column names. A Repository knows *what to translate it
into* — raw rows to `Entity`. Splitting them is what lets
`PostRepositoryImpl` stop importing `DatabaseHelper`, which in turn is what makes
the one-line source swap possible. That swap is the climax of the presentation.

Earlier flows (`ex01/`–`ex04/` in Lab 5, `ex01/`–`ex03/` in Lab 6) deliberately
have **less** structure — they are the teaching progression. Leave them alone.

---

## The one-line switch

`adfd05_architecture/lib/ex05/core/di/injection.dart`:

```dart
const bool useInMemoryDataSource = false;   // true → InMemoryPostDataSource
```

Flipping this swaps SQLite for an in-memory list, and **no other file changes**.
It is the single most important artefact in the repo — the whole Lab 5 argument
rests on it. Do not delete `InMemoryPostDataSource`, and do not leave the flag on
`true` in a commit.

After flipping it, press **`R`** (hot restart), not `r` — hot reload does not
re-run `main()`, so GetIt keeps the old registration and it looks like the change
did nothing.

---

## Running things

**Lab 5** needs nothing but Flutter — no Docker, no backend:

```bash
cd adfd05_architecture && flutter pub get && flutter run -d emulator-5554
```

**Lab 6** needs three processes alive, in this order:

```bash
# 1. MySQL — see caveat
docker exec mysql-container mysql -uroot -p112233 \
  -e "SELECT COUNT(*) FROM adfddb.contacts;"        # must return 5

# 2. backend, port 8082
cd adfd06_rest_api/adfd06_backend
java -jar target/adfd06_rest_api-0.0.1-SNAPSHOT.jar

# 3. Flutter
cd adfd06_rest_api/adfd06_frontend && flutter run -d emulator-5554
```

> **MySQL caveat.** The owner's machine already runs a container named
> `mysql-container` on port 3306. `docker-compose.yml` would start a *second*
> one named `adfd_mysql` on the same port and fail. The compose file is for
> teammates who have no MySQL. Check `docker ps` before running it.

Verify the backend before blaming the app:

```bash
curl http://localhost:8082/api/contacts
```

Re-build the jar only after changing Java code: `mvn clean package -DskipTests`.

---

## Deliberate deviations from the brief

Do not "correct" these back — each was a decision, defended in
`docs/cau-truc-du-an.md` and `README.md`.

| Item | Brief says | This repo does | Why |
|---|---|---|---|
| Database | SQL Server | **MySQL** | Lecturer allowed free choice; runs natively on Apple Silicon |
| Lab 6 folders | `models/ pages/ providers/ services/` | Clean Architecture layers | Applies the lesson from Lab 3 and Lab 5 |
| `artifactId` | doc says `adfd06_backend` | `adfd06_rest_api` | The lecturer's own **code** says this; his doc and code disagree |
| Lab 5 folders | — | **left exactly as given** | Already Clean Architecture; `features/` in a one-feature app buys nothing |

The team also fixed five real defects in the provided code, numbered 1–5 in
`README.md` under *"Cải tiến của nhóm"*. Each is referenced **by number** in the
slides and the script — **keep that numbering stable.**

---

## Language

- **Reply to the user in Vietnamese.**
- Docs, lesson material, and **all code comments**: Vietnamese
- Identifiers, class names, file names, commit messages, and this file: English
- Never translate a Flutter, Dart, Spring or JPA API name into Vietnamese —
  `build`, `setState`, `@Column` must match the official docs the team looks up

---

## Code conventions

- Dart: files `snake_case.dart`, classes `PascalCase`, trailing commas mandatory
- Comments explain **why**, never **what**
- Each Dart file in the final flows ends with a `/* FLOW ... */` block drawing
  its place in the chain. This is the lecturer's house style — **keep it**, and
  add one when creating a new file there.
- Java: standard Spring layering, Lombok for boilerplate
- Run `flutter analyze` inside each Flutter project; both must be clean
- The `I` prefix marks a **contract only** — `IPostDataSource` is the interface,
  `PostDataSourceImpl` is the implementation. There is no `IPostDataSourceImpl`.

---

## Commit rules

Enforced by `.husky/commit-msg` — it rejects anything else.

- `type(scope): subject` — **one line**, **≤ 70 characters**, **no body, no footer**
- Types: `feat fix docs style refactor perf test chore revert ci`
- **Never add a `Co-Authored-By` trailer** — the hook reads it as a body
- Scopes in use: `repo` `lab5` `lab6` `backend` `db` `di` `post` `script`
  `slides` `assets` `reference` `readme` `husky`

One commit = one concern. Do not sweep unrelated files in with `git add -A`
without checking what it staged.

`.husky/pre-commit` formats staged Dart files, re-stages them, then runs
`flutter analyze --no-fatal-infos`. Info lints pass; warnings and errors block.

**Git identity comes from the global config** (`maaitlunghau`). Never set a
repo-local `user.email`. History was rewritten once to fix exactly that.

---

## What Claude must NOT do

- Do not flatten or rename the `exNN/` structure
- Do not restructure `ex01/`–`ex04/` of Lab 5 — they are the teaching progression
- Do not delete `InMemoryPostDataSource` or commit the switch set to `true`
- Do not switch the database back to SQL Server
- Do not renumber the five improvements in `README.md`
- Do not rename classes or move files without grepping `docs/` first — the slide
  material names them explicitly
- Do not add tests — the assignment does not ask for them and no test
  infrastructure exists
- Do not bump dependency versions unprompted; the demo must stay reproducible
- Do not commit `node_modules/`, `.codegraph/codegraph.db`, or `target/`
- Do not run `git push --force` — the repo is shared with three teammates
- Do not edit `reference/` — it is the lecturer's material, kept verbatim

---

## Known traps, already paid for

| Symptom | Cause and fix |
|---|---|
| Host keyboard does not type into the emulator | AVD was made with `avdmanager`, which defaults to `hw.keyboard=no`. Shut the emulator down **first**, set `hw.keyboard=yes` in `~/.android/avd/<name>.avd/config.ini`, restart. Editing while it runs is overwritten on exit. |
| `adb: command not found` | Not on PATH. Use `~/Library/Android/sdk/platform-tools/adb` |
| Spinner forever, `Network is unreachable` | Emulator boots with **airplane mode on** → `adb shell cmd connectivity airplane-mode disable` |
| `Port 8082 was already in use` | An orphaned backend (`PPID 1`) from an earlier session. `lsof -nP -iTCP:8082 -sTCP:LISTEN` then `kill`. Do not change the port. |
| `flutter doctor` says `✗ Android license status unknown` | **False alarm.** New `cmdline-tools` dropped `--licenses`. Verify by building an APK. |
| `flutter emulators --create` claims no system image | Same root cause. Use `avdmanager create avd` — but then see the keyboard trap above. |
| Vietnamese names become `?` | DB must be `utf8mb4` **and** the connection string needs `characterEncoding=UTF-8` |
| `10.0.2.2` refused on a real phone | That address exists only for the Android emulator. Real device → LAN IP. iOS simulator → `localhost`. |
| Search breaks on `A&B`, `C#1`, `a+b` | Build URLs with `Uri.http(...)`, never string concatenation. Spaces and Vietnamese diacritics are fine — that part was a false alarm. |
| Changing the DI switch appears to do nothing | You pressed `r`. Press `R`. |

<!-- CODEGRAPH_START -->
## CodeGraph

In repositories indexed by CodeGraph (a `.codegraph/` directory exists at the repo root), reach for it BEFORE grep/find or reading files when you need to understand or locate code:

- **MCP tool** (when available): `codegraph_explore` answers most code questions in one call — the relevant symbols' verbatim source plus the call paths between them, including dynamic-dispatch hops grep can't follow. Name a file or symbol in the query to read its current line-numbered source. If it's listed but deferred, load it by name via tool search.
- **Shell** (always works): `codegraph explore "<symbol names or question>"` prints the same output.

If there is no `.codegraph/` directory, skip CodeGraph entirely — indexing is the user's decision.
<!-- CODEGRAPH_END -->
