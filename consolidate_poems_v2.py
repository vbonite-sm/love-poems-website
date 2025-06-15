import json
import re
from difflib import SequenceMatcher

def similarity(a, b):
    return SequenceMatcher(None, a, b).ratio()

def generate_title_from_text(text):
    """Generate a meaningful title from the poem text"""
    # Clean the text
    clean_text = text.replace('<br>', ' ').replace('"', '').strip()
    
    # Extract first meaningful phrase or key words
    words = clean_text.split()
    
    # Look for key romantic words or phrases
    key_phrases = {
        'love': 'My Love',
        'heart': 'My Heart',
        'smile': 'Your Smile',
        'eyes': 'Your Eyes',
        'embrace': 'Your Embrace',
        'laughter': 'Your Laughter',
        'light': 'Guiding Light',
        'dreams': 'Our Dreams',
        'stars': 'Like Stars',
        'moon': 'Moonlit',
        'sun': 'Sunshine',
        'morning': 'Morning Light',
        'night': 'Through the Night',
        'forever': 'Forever Yours',
        'always': 'Always Together',
        'peace': 'Finding Peace',
        'joy': 'Pure Joy',
        'grace': 'Your Grace',
        'beauty': 'Your Beauty',
        'gentle': 'Gentle Touch',
        'precious': 'Precious Love',
        'tender': 'Tender Moments',
        'candles': 'Candlelight',
        'rose': 'Rose Petals',
        'thunder': 'Thunder Night',
        'diamonds': 'Diamond Heart',
        'mirrors': 'Reflections',
        'galaxies': 'Galaxy Eyes',
        'crystal': 'Crystal Dewdrops',
        'silver': 'Silver Moonlight',
        'golden': 'Golden Sunrise'
    }
    
    # Look for key phrases in order of preference
    for word, title in key_phrases.items():
        if word in clean_text.lower():
            return title
    
    # Extract first few words as title if no key phrase found
    first_words = ' '.join(words[:3])
    # Capitalize properly
    return ' '.join(word.capitalize() for word in first_words.split())

def extract_poems_from_text(text_content):
    """Extract all 53 poems from the text file with proper parsing"""
    poems = []
    
    # Split by numbered items, including edge cases
    lines = text_content.split('\n')
    current_poem = None
    current_lines = []
    
    for line in lines:
        line = line.strip()
        
        # Check if this line starts a new poem
        match = re.match(r'^(\d+)\.?\s*(.*)', line)
        if match:
            # Save previous poem if exists
            if current_poem is not None and current_lines:
                poem_text = format_poem_text(current_lines)
                if poem_text:
                    poems.append({
                        'id': current_poem + 2000,  # Offset to avoid conflicts
                        'title': generate_title_from_text(poem_text),
                        'text': poem_text,
                        'source': 'main_poems_txt',
                        'rhyme_scheme': detect_rhyme_scheme(current_lines)
                    })
            
            # Start new poem
            current_poem = int(match.group(1))
            current_lines = []
            
            # Add first line if it has content after number
            first_content = match.group(2).strip()
            if first_content:
                current_lines.append(first_content)
        
        elif current_poem is not None:
            # Continue current poem
            if line and line not in ['X', '[X]', '']:
                # Clean up formatting
                clean_line = line.strip(' "(),').strip()
                if clean_line:
                    current_lines.append(clean_line)
            elif line in ['X', '[X]']:
                # End of poem marker
                continue
    
    # Don't forget the last poem
    if current_poem is not None and current_lines:
        poem_text = format_poem_text(current_lines)
        if poem_text:
            poems.append({
                'id': current_poem + 2000,
                'title': generate_title_from_text(poem_text),
                'text': poem_text,
                'source': 'main_poems_txt',
                'rhyme_scheme': detect_rhyme_scheme(current_lines)
            })
    
    return poems

def format_poem_text(lines):
    """Format poem lines consistently"""
    if not lines:
        return ""
    
    # Clean and join lines
    clean_lines = []
    for line in lines:
        # Remove quotes and extra whitespace
        clean_line = line.strip(' "(),').strip()
        if clean_line:
            clean_lines.append(clean_line)
    
    # Join with <br> for HTML display
    return '<br>'.join(clean_lines)

def detect_rhyme_scheme(lines):
    """Simple rhyme scheme detection"""
    if len(lines) == 4:
        return "AABB"  # Most common in the collection
    elif len(lines) == 2:
        return "AA"
    else:
        return "ABAB"

def load_json_poems(json_file):
    """Load poems from JSON file"""
    with open(json_file, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    poems = []
    for poem in data['poems']:
        if 'text' in poem and poem['text'] and poem['text'].strip():
            poems.append({
                'id': poem.get('id', len(poems) + 1),
                'title': poem.get('title', ''),
                'text': poem['text'].strip(),
                'rhyme_scheme': poem.get('rhyme_scheme', ''),
                'source': 'json_file'
            })
    
    return poems

def find_duplicates(poems, threshold=0.75):
    """Find potential duplicates based on text similarity"""
    duplicates = []
    
    for i, poem1 in enumerate(poems):
        for j, poem2 in enumerate(poems[i+1:], i+1):
            # Compare cleaned text
            text1 = poem1['text'].replace('<br>', ' ').lower().strip()
            text2 = poem2['text'].replace('<br>', ' ').lower().strip()
            
            sim = similarity(text1, text2)
            if sim >= threshold:
                duplicates.append((i, j, sim, poem1, poem2))
    
    return duplicates

# Main execution
print("Loading poems from JSON file...")
json_poems = load_json_poems('c:/Users/Vlad Bonite/Downloads/poems_json.json')

print("Loading and parsing poems from text file...")
with open('c:/Users/Vlad Bonite/Downloads/[MAIN] POEMS.txt', 'r', encoding='utf-8') as f:
    text_content = f.read()
text_poems = extract_poems_from_text(text_content)

print(f"Found {len(json_poems)} poems in JSON file")
print(f"Found {len(text_poems)} poems in text file")

# Show first few text poems for verification
print("\nFirst 3 text poems parsed:")
for i, poem in enumerate(text_poems[:3]):
    print(f"{i+1}. Title: {poem['title']}")
    print(f"   Text: {poem['text'][:100]}...")
    print(f"   Rhyme: {poem['rhyme_scheme']}")

# Combine all poems
all_poems = json_poems + text_poems

# Check for duplicates
print(f"\nChecking for duplicates among {len(all_poems)} total poems...")
duplicates = find_duplicates(all_poems, threshold=0.7)

if duplicates:
    print(f"Found {len(duplicates)} potential duplicates:")
    for i, j, sim, poem1, poem2 in duplicates:
        print(f"\nSimilarity: {sim:.2f}")
        print(f"Poem {poem1.get('id', 'Unknown')} ({poem1['source']}): {poem1.get('title', 'No title')}")
        print(f"  {poem1['text'][:100]}...")
        print(f"Poem {poem2.get('id', 'Unknown')} ({poem2['source']}): {poem2.get('title', 'No title')}")
        print(f"  {poem2['text'][:100]}...")
else:
    print("No duplicates found!")

# Create final consolidated list
print("\nConsolidating poems...")
final_poems = []
skip_indices = set()

# Mark duplicates to skip (keep JSON version when there's a conflict)
for i, j, sim, poem1, poem2 in duplicates:
    if sim > 0.8:  # High similarity threshold
        if poem1['source'] == 'json_file':
            skip_indices.add(j)
            print(f"Removing duplicate: {poem2.get('title', 'Untitled')} (keeping JSON version)")
        else:
            skip_indices.add(i)
            print(f"Removing duplicate: {poem1.get('title', 'Untitled')} (keeping JSON version)")

# Add non-duplicate poems
for i, poem in enumerate(all_poems):
    if i not in skip_indices:
        final_poems.append(poem)

print(f"\nFinal consolidated list: {len(final_poems)} poems")

# Save consolidated poems
consolidated = {
    "poems": final_poems,
    "metadata": {
        "total_count": len(final_poems),
        "sources": {
            "json_file": len([p for p in final_poems if p['source'] == 'json_file']),
            "main_poems_txt": len([p for p in final_poems if p['source'] == 'main_poems_txt'])
        },
        "duplicates_removed": len(duplicates),
        "last_updated": "2025-06-15"
    }
}

with open('consolidated_poems_v2.json', 'w', encoding='utf-8') as f:
    json.dump(consolidated, f, indent=2, ensure_ascii=False)

print("Enhanced consolidated poems saved to 'consolidated_poems_v2.json'")
print(f"Total: {len(final_poems)} unique poems ready for your website!")
