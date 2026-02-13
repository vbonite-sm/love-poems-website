# Context for Claude

You are building a Flutter app called "Love Poems".
The goal is to create a romantic, high-quality app where the user receives one love letter (poem) per day.

## Tech Stack
- **Framework**: Flutter (Dart)
- **Backend**: Supabase (PostgreSQL)
- **Key Packages**: 
  - `supabase_flutter`
  - `flutter_animate`
  - `confetti`
  - `google_fonts` (Dancing Script, Montserrat)

## Key Features
1.  **Daily Letter**: Logic to check if `last_opened_date` is today. If not, show sealed envelope. If yes, show open state.
2.  **Archive**: A grid view of all poems unlocked in `unlocked_poems` table.
3.  **Valentine's Mode**: A floating "Rose" action button. specific animation when clicked (Proposal).

## Data Model
See `supabase_schema.sql` for table structure.
- `poems`: Pre-populated content.
- `profiles`: `last_opened_date`.
- `unlocked_poems`: History.

## Design
See `design_system.md` for colors and typography.
- Use `Stack` for overlaying the Confetti widget.
- Use `Hero` animations for opening envelopes if possible.
