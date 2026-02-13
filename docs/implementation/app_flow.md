# Love Poems App - User Flow & Logic

## 1. Authentication (New)
- **Login**: Required (Anonymous or Email/Password).
- **Setup**: On first login, user confirms their Email (used for receiving letters).

## 2. Writing a Letter (Sender Role)
- **Access**: Tap "Write" icon (Quill/Pen).
- **Form**:
  - Title
  - Message (The Poem)
  - Target Email (The partner's email).
- **Submission**: Saves to `poems` table with `is_public = false`.

## 3. Daily Letter Logic (Receiver Role)
- **Logic**:
  1.  Check `last_opened_date`.
  2.  If **New Day**:
      - **Fetch Pool**:
        - Query A: Private Poems where `target_email` == My Email AND `id` NOT IN `unlocked_poems`.
        - Query B: Public Poems where `id` NOT IN `unlocked_poems`.
      - **Selection Strategy**:
        - **PRIORITY**: If Query A has results, pick the oldest one (First In, First Out). *Rationale: Personal letters are more important.*
        - **FALLBACK**: If no personal letters, pick random from Query B.
      - **Display**: "A letter has arrived..." (Maybe different seal color for personal letters? Gold vs Red?).
      - **Open**: Adds to `unlocked_poems`, updates `last_opened_date`.

## 4. The Archive
- Shows all unlocked poems.
- Distinguish between "Classics" and "From [Partner]"? (Maybe a small badge).

## 5. Valentine's Proposal
- Same as before.
