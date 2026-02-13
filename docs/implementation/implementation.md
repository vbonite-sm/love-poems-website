# Implementation Plan - Love Poems Flutter App

## Goal
Rewrite the `love-poems-website` as one high-quality Flutter application.
**Core Features**:
1.  **One Letter a Day**: Users can only open one new envelope per day.
2.  **Sender & Receiver**: Users can write custom letters to their partner. These custom letters are added to the "Daily Rotation".
3.  **Archive**: All opened letters are stored in a separate screen.
4.  **Backend**: Supabase.

## User Review Required
> [!IMPORTANT]
> **Supabase Setup**: The schema will be updated to support custom poems `target_user_id`.

## Proposed Changes

### 1. Project Initialization
- Create Flutter project: `love_poems_app`.
- Dependencies: `supabase_flutter`, `google_fonts`, `flutter_animate`, `confetti`.

### 2. Data Layer (Supabase)

#### Schema Updates
- **Table `poems`**:
  - Add `sender_id` (uuid, nullable).
  - Add `target_email` (text, nullable) or `target_user_id`. (For MVP, we can use a simple "Partner Code" or Email).
  - Policy: Users can see *Public* poems AND *Private* poems sent to them.

### 3. UI/UX Design

#### Screens

**Home Screen**
- **Receiver Mode**: Sees the Daily Envelope.
- **Writer Mode**: Access via a "Quill" icon (Top Left).

**Write Letter Screen**
- **Input**: Title, Body, Theme (Paper style).
- **Action**: "Send to My Love".
- **Result**: Saves to DB. The poem enters the receiver's valid pool.

**Daily Letter Logic (Updated)**
- When fetching a new poem for the day:
    - **Priority**: Check if there are any *unread custom poems* from the partner. If yes, show that one first!
    - **Fallback**: If no custom poems, pick a random *unread public poem*.

## Verification Plan

### Manual Verification
1.  **Write Letter**: Use Account A to write a poem for Account B.
2.  **Receive Letter**: Log in as Account B. Verify the *next* daily letter is the one just written.
3.  **Archive**: Verify it goes to archive after reading.
