# ZeroDoc — Decision Log

---

## 2026-03-02 — Project Initialization & Architecture

**Context:** Starting the ZeroDoc Flutter project. Need to lock core architecture decisions before writing any code.

**Decisions:**

| Area | Decision | Rationale |
|---|---|---|
| State Management | Riverpod (flutter_riverpod + hooks_riverpod + riverpod_annotation) | Compile-safe DI + state in one package, less boilerplate than BLoC, ideal for solo dev |
| Navigation | GoRouter (go_router) | Declarative routing, deep link support, official Flutter team package |
| DI | Riverpod only | Riverpod is itself a DI framework — adding get_it would be redundant |
| Design System | Custom "Paper & Ink" on Material 3 base | Warm, calm, tactile aesthetic per UI/UX design doc |
| Fonts | Fraunces (titles) + DM Sans (body) via google_fonts | Defined in UI/UX design doc |
| PDF Engine | syncfusion_flutter_pdf (read/write) + pdfx (rendering) | Syncfusion covers encryption, metadata, merge/split; pdfx for page thumbnails |
| Linting | very_good_analysis | Strict, well-maintained ruleset |
| Platforms | Android + iOS | Web optional in Phase 4 |
| Architecture | Feature-first clean architecture | Domain → Data → Presentation layers per feature |
| Generated Files | Committed (*.g.dart, *.freezed.dart) | Solo project — no merge conflict risk, saves CI build time |
| Error Handling | Either<Failure, Success> via fpdart | Functional error handling, no exception swallowing |
| Logging | logger package | Never use print() |

**Alternatives Considered:**
- BLoC: More boilerplate, better for large teams — overkill for solo dev
- GetX: Fast prototyping but tightly coupled, poor testability
- Provider: Limited scalability for complex async flows

**Tradeoffs:**
- Riverpod has a learning curve with code generation, but the compile-time safety and reduced boilerplate are worth it for this project
- Syncfusion requires a free community license key — acceptable for AGPL open-source project
