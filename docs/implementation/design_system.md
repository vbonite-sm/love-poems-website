# Love Poems App - Design System

## Theme Philosophy
**"The Love Letter"**: The app should feel intimate, warm, and personal. It mimics receiving a handwritten letter from a loved one.

## Color Palette

| Name | Hex Code | Usage |
|---|---|---|
| **Rose Rouge** | `#E91E63` | Primary CTA (The Rose), Hearts |
| **Deep Passion** | `#880E4F` | Headlines, Important Text |
| **Soft Blush** | `#FCE4EC` | Background (Subtle), Button Light |
| **Antique White** | `#FFF9C4` | Letter Paper Background (Parchment) |
| **Ink Black** | `#37474F` | Body Text (Legible but soft) |
| **Gold Foil** | `#FFD700` | Accents, Seals, Special Highlights |

## Typography

### Headings (Display)
- **Font**: `Montserrat` (Bold/Semi-bold)
- **Usage**: Screen titles ("My Letters"), Button text.

### Body (Handwriting)
- **Font**: `Dancing Script` or `Great Vibes`
- **Usage**: The actual poem content, "Love, [Name]" signatures.
- **Goal**: Must look like elegant cursive writing but remain readable.

## Components

### 1. The Sealed Envelope
- A container shaped like an envelope.
- **State: New**: Shows a Wax Seal (Gold/Red). Pulsating animation.
- **State: Opened**: Shows the flap open, maybe a peek of the letter inside.

### 2. The Letter View
- A container with `Antique White` background.
- Subtle paper texture overlay (optional).
- Text centered, elegant padding.

### 3. The Rose CTA
- Floating Action Button (FAB) replacement.
- Custom Icon: A rose.
- Animation: Gentle shake every 5-10 seconds.

## Icons
- **Home**: Envelope/Heart.
- **Archive**: Open Box or Book.
- **Favorite**: Heart (Outline vs Filled).
