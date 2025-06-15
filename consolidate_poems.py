import json
import re
from difflib import SequenceMatcher

def similarity(a, b):
    return SequenceMatcher(None, a, b).ratio()

def extract_poems_from_text(text_content):
    """Extract poems from the text file format"""
    poems = []
    # Split by numbered items
    poem_blocks = re.split(r'\n(?=\d+\.)', text_content.strip())
    
    for block in poem_blocks:
        if not block.strip():
            continue
            
        lines = block.strip().split('\n')
        if not lines:
            continue
            
        # Extract number and first line
        first_line = lines[0]
        match = re.match(r'(\d+)\.\s*(.*)', first_line)
        
        if match:
            poem_num = int(match.group(1))
            first_poem_line = match.group(2)
            
            # Collect all poem lines (skip lines with just X or [X])
            poem_lines = [first_poem_line] if first_poem_line else []
            
            for line in lines[1:]:
                line = line.strip()
                if line and line not in ['X', '[X]', '']:
                    poem_lines.append(line)
                elif line in ['X', '[X]']:
                    break  # Stop at marker
            
            if poem_lines:
                poem_text = ' '.join(poem_lines)
                poems.append({
                    'id': poem_num + 1000,  # Offset to avoid conflicts
                    'text': poem_text,
                    'source': 'text_file'
                })
    
    return poems

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
                'text': poem['text'].replace('<br>', ' ').strip(),
                'rhyme_scheme': poem.get('rhyme_scheme', ''),
                'source': 'json_file'
            })
    
    return poems

def find_duplicates(poems, threshold=0.8):
    """Find potential duplicates based on text similarity"""
    duplicates = []
    
    for i, poem1 in enumerate(poems):
        for j, poem2 in enumerate(poems[i+1:], i+1):
            sim = similarity(poem1['text'].lower(), poem2['text'].lower())
            if sim >= threshold:
                duplicates.append((i, j, sim, poem1, poem2))
    
    return duplicates

# Load poems from both sources
print("Loading poems from JSON file...")
json_poems = load_json_poems('c:/Users/Vlad Bonite/Downloads/poems_json.json')

print("Loading poems from text file...")
with open('c:/Users/Vlad Bonite/Downloads/[MAIN] POEMS.txt', 'r', encoding='utf-8') as f:
    text_content = f.read()
text_poems = extract_poems_from_text(text_content)

print(f"Found {len(json_poems)} poems in JSON file")
print(f"Found {len(text_poems)} poems in text file")

# Combine all poems
all_poems = json_poems + text_poems

# Check for duplicates
print("\nChecking for duplicates...")
duplicates = find_duplicates(all_poems, threshold=0.7)

if duplicates:
    print(f"Found {len(duplicates)} potential duplicates:")
    for i, j, sim, poem1, poem2 in duplicates:
        print(f"\nSimilarity: {sim:.2f}")
        print(f"Poem {poem1['id']} ({poem1['source']}): {poem1['text'][:100]}...")
        print(f"Poem {poem2['id']} ({poem2['source']}): {poem2['text'][:100]}...")
else:
    print("No duplicates found!")

# Create consolidated list (remove duplicates by keeping JSON version)
print("\nConsolidating poems...")
final_poems = []
skip_indices = set()

for i, j, sim, poem1, poem2 in duplicates:
    if sim > 0.8:  # High similarity threshold
        # Keep the JSON version (usually more complete)
        if poem1['source'] == 'json_file':
            skip_indices.add(j)
        else:
            skip_indices.add(i)

for i, poem in enumerate(all_poems):
    if i not in skip_indices:
        final_poems.append(poem)

print(f"Final consolidated list: {len(final_poems)} poems")

# Save consolidated poems
consolidated = {
    "poems": final_poems,
    "metadata": {
        "total_count": len(final_poems),
        "sources": {
            "json_file": len([p for p in final_poems if p['source'] == 'json_file']),
            "text_file": len([p for p in final_poems if p['source'] == 'text_file'])
        },
        "duplicates_removed": len(duplicates)
    }
}

with open('consolidated_poems.json', 'w', encoding='utf-8') as f:
    json.dump(consolidated, f, indent=2, ensure_ascii=False)

print("Consolidated poems saved to 'consolidated_poems.json'")
