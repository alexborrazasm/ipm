# IPM Practices — FIC, UDC

Repository for the three lab assignments of **Interfaces Persona-Máquina** (Human-Computer Interaction), a course in the Computer Science degree at the [Facultad de Informática, Universidade da Coruña](https://www.fic.udc.es/).

The application built across all three assignments is the same: **SplitWithTheMachine**, a shared expense tracker. What changes each time is the platform and the technology stack, so you can see how the same UI problems are approached differently depending on the environment.

The backend server is provided by the professor ([splitwithme](https://github.com/nbarreira/splitwithme)). The assignments focus exclusively on the frontend.

Each assignment has its own [Nix](https://nixos.org/) flake that provides a reproducible development environment. The project uses [direnv](https://direnv.net/), so the environment loads automatically when entering the directory. Alternatively, `nix develop` inside the corresponding directory works just as well.

---

## Assignment 1 — Desktop

**Directory:** `desktop/`

**Stack:** Python · GTK 4 · libadwaita · Nix (nixos-25.05)

**Architecture:** MVP (Model-View-Presenter)

The first assignment introduces native desktop GUI development using GTK 4 and libadwaita (the GNOME HIG toolkit), with Python.

The three main learning goals:

- **Architectural patterns**: the app is structured with a `Presenter` that mediates between the `Model` (HTTP calls to the server) and the `View` (GTK widgets). A Python `Protocol` defines the contract between presenter and view, keeping them fully decoupled.

- **Concurrency**: server requests are blocking I/O. The app offloads them to daemon threads (`threading.Thread`) and uses `GLib.idle_add` to marshal UI updates back to GTK's main thread — the correct way to avoid freezing the interface.

- **Internationalization**: all user-visible strings are wrapped with `_()` and `.po`/`.mo` files are generated via `gettext` for English, Spanish, and Galician. Monetary amounts and dates are formatted according to the system locale.

**Dev environment:**

```
cd desktop
nix develop
python app/app.py
```

---

## Assignment 2 — Mobile

**Directory:** `mobile/`

**Stack:** Flutter · Dart · Nix (nixos-unstable)

**Architecture:** MVVM (Model-View-ViewModel)

The second assignment ports the same application to mobile, introducing Flutter's declarative/reactive UI paradigm.

The main learning goals:

- **Adaptive design**: the interface adapts to different screen sizes (phone and tablet) and orientations, with meaningfully different layouts for each form factor.

- **MVVM with `ChangeNotifier`**: an `ExpenseViewModel` owns all application state and notifies widgets on change. Async operations are encapsulated in `Command` objects (`Command0`, `Command1`) that track loading and error state. Results are modelled with a `Result<T>` sealed type using exhaustive pattern matching (`Ok`/`Error`) rather than exceptions.

- **End-to-end tests**: Flutter's integration test library is used to exercise the app through its actual UI, including I/O error scenarios via mocked repositories.

**Dev environment:**

```
cd mobile
nix develop
cd splitwiththemachine
flutter run
```

---

## Assignment 3 — Web

**Directory:** `web/`

**Stack:** HTML5 · CSS3 · Vanilla JavaScript (no frameworks or libraries)

The third assignment takes a deliberately low-level approach: no frameworks, no build tools, no CSS libraries. The goal is to understand the web platform itself before abstracting it.

The main learning goals:

- **Semantic HTML and web standards**: markup uses HTML5 semantic elements. Only [Baseline](https://web-platform-dx.github.io/web-features/)-stable APIs are used — features with solid cross-browser support.

- **Mobile-first and adaptive design**: CSS is written mobile-first and extended with media queries for tablet and desktop breakpoints.

- **Accessibility (WCAG 2 / WAI-ARIA)**: ARIA roles and properties are applied so the app works with screen readers. Live regions (`aria-live`) announce dynamic content changes without a page reload.

- **Modular JS architecture**: code is split into ES modules (`model.js`, `dom.js`, `cache.js`, `main.js`) with no bundler. Concurrency in async operations is handled with a per-resource lock system built on top of `Promise`.

**Dev environment:** any static file server works. No build step required.

---

## Repository layout

```
.
├── desktop/        # Assignment 1 — Python + GTK 4
│   ├── app/        # model.py · view.py · presenter.py
│   └── flake.nix
├── mobile/         # Assignment 2 — Flutter
│   ├── splitwiththemachine/
│   │   └── lib/
│   │       ├── data/   # Repositories and models
│   │       └── ui/     # Views, ViewModel, widgets
│   └── flake.nix
├── web/            # Assignment 3 — HTML/CSS/JS vanilla
│   └── src/
│       ├── index.html
│       ├── css/
│       └── js/
└── splitwithme/    # Backend server (provided by the professor)
```

---

## Authors

Alexandre Borrazás Mancebo · Daniel García Figueroa · Nerea Pérez Pértega

Academic year 2025/26 — [FIC, UDC](https://www.fic.udc.es/)
