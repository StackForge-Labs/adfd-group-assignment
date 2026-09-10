# ADFD — Lab 5 & Lab 6 (Team E)

## What this repo is

A **university group assignment** for a Flutter course, not a production app.
Team E owns two labs out of six; the other four belong to other teams and are
not in this repo.

| Lab | Topic | Stack |
|---|---|---|
| **Lab 5** — `adfd05_architecture/` | Clean Architecture on the client | Flutter + SQLite |
| **Lab 6** — `adfd06_rest_api/` | Full-stack REST | Spring Boot + MySQL + Flutter |

The deliverable is a **presentation**, so readability and explainability matter
more than cleverness. Every design decision must be defensible out loud to a
lecturer.

**Read `docs/` before answering questions about this project.** Those four files
carry the reasoning behind everything here:

| File | What it answers |
|---|---|
| `docs/tong-quan-lab-5-6.md` | What the two labs do, big picture |
| `docs/luong-chay-chuong-trinh.md` | Runtime flow from `main()` to screen |
| `docs/cau-truc-du-an.md` | Folder layout and **why** |
| `docs/phan-cong-task.md` | Who presents what |

---

## Layout

```
adfd-group-assignment/
├── docker-compose.yml            MySQL 8 + phpMyAdmin
├── db/init.sql                   schema + 5 seed rows
├── docs/                         team documentation (Vietnamese)
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
propose flattening it, merging flows, or renaming `exNN`. The assignment brief
lists these exact paths.

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

Wired together with **GetIt**. Each lab has its own copy at
`<flutter-project>/lib/<final-flow>/core/di/injection.dart`.

**Rules that hold in both labs:**

- Domain never imports from `data/` — the dependency arrow only points inward
- `Entity` knows nothing about JSON, SQL, or `null` from the wire
- `Model` is the only place that knows the storage representation
- **Repository is the only place that knows both `Model` and `Entity`**
- Data sources speak raw `Map<String, dynamic>`, never `Entity`

Earlier flows (`ex01/`–`ex04/` in Lab 5, `ex01/`–`ex03/` in Lab 6) deliberately
have **less** structure — they are the teaching progression. Leave them alone.

---

## Running things

**Lab 5** needs nothing but Flutter:

```bash
cd adfd05_architecture && flutter pub get && flutter run -d <device>
```

**Lab 6** needs three processes alive at once:

```bash
docker compose up -d                                   # 1. MySQL
cd adfd06_rest_api/adfd06_backend
mvn clean package -DskipTests
java -jar target/adfd06_rest_api-0.0.1-SNAPSHOT.jar    # 2. backend, port 8082
cd ../adfd06_frontend && flutter run -d <device>       # 3. Flutter
```

Verify the backend before blaming the app:

```bash
curl http://localhost:8082/api/contacts     # must return 5 contacts
```

---

## Deliberate deviations from the assignment brief

Do not "correct" these back — each was a decision, and each is defended in
`docs/cau-truc-du-an.md` and `README.md`.

| Item | Brief says | This repo does | Why |
|---|---|---|---|
| Database | SQL Server | **MySQL** | Lecturer allowed free choice; MySQL runs natively on Apple Silicon |
| Lab 6 folders | `models/ pages/ providers/ services/` | Clean Architecture layers | Applies the lesson from Lab 3 and Lab 5 |
| `artifactId` | brief text says `adfd06_backend` | `adfd06_rest_api` | The lecturer's own **code** says this; his doc and code disagree |
| Lab 5 folders | — | **left exactly as given** | Already Clean Architecture; adding `features/` to a one-feature app buys nothing |

The team also fixed five real defects in the provided code. They are numbered
1–5 in `README.md` under *"Cải tiến của nhóm"* and each is referenced by number
during the presentation — **keep that numbering stable.**

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
  add one when you create a new file there.
- Java: standard Spring layering, Lombok for boilerplate
- Run `flutter analyze` from inside each Flutter project; both must be clean

---

## Commit rules

Enforced by `.husky/commit-msg` — it rejects anything else.

- `type(scope): subject` — **one line**, **≤ 70 characters**, **no body, no footer**
- Types: `feat fix docs style refactor perf test chore revert ci`
- **Never add a `Co-Authored-By` trailer** — the hook reads it as a body
- Scopes in use: `repo` · `db` · `backend` · `lab5` · `lab6` · `readme`

One commit = one concern. Do not sweep unrelated files in with `git add -A`
without checking what it staged first.

---

## What Claude must NOT do

- Do not flatten or rename the `exNN/` structure (see above)
- Do not restructure `ex01/`–`ex04/` of Lab 5 — they are the teaching progression
- Do not switch the database back to SQL Server
- Do not renumber the five improvements in `README.md`
- Do not add tests — the assignment does not ask for them, and no test
  infrastructure exists here
- Do not bump dependency versions unprompted; the demo must stay reproducible
- Do not commit `node_modules/`, `.codegraph/codegraph.db`, or `target/`
- Do not run `git push --force` — the repo is shared with three teammates

---

## Known traps, already paid for

These cost real debugging time. `README.md` has the full write-up.

| Symptom | Cause |
|---|---|
| Spinner spins forever, `Network is unreachable` | Emulator has **airplane mode on** by default → `adb shell cmd connectivity airplane-mode disable` |
| `flutter doctor` says `✗ Android license status unknown` | **False alarm.** New `cmdline-tools` dropped `--licenses`. Verify by building an APK instead. |
| `flutter emulators --create` claims no system image | Same root cause. Create the AVD from Android Studio's GUI. |
| Vietnamese names turn into `?` | Database must be `utf8mb4` **and** the connection string needs `characterEncoding=UTF-8` |
| `10.0.2.2` refused on a real phone | That address only exists for the Android emulator. Real device → LAN IP. iOS simulator → `localhost`. |

<!-- CODEGRAPH_START -->
## CodeGraph

In repositories indexed by CodeGraph (a `.codegraph/` directory exists at the repo root), reach for it BEFORE grep/find or reading files when you need to understand or locate code:

- **MCP tool** (when available): `codegraph_explore` answers most code questions in one call — the relevant symbols' verbatim source plus the call paths between them, including dynamic-dispatch hops grep can't follow. Name a file or symbol in the query to read its current line-numbered source. If it's listed but deferred, load it by name via tool search.
- **Shell** (always works): `codegraph explore "<symbol names or question>"` prints the same output.

If there is no `.codegraph/` directory, skip CodeGraph entirely — indexing is the user's decision.
<!-- CODEGRAPH_END -->
