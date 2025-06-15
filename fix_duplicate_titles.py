import json
import re

def generate_unique_title(text, existing_titles, base_title):
    """Generate a unique title based on poem content"""
    clean_text = text.replace('<br>', ' ').lower()
    
    # Specific patterns for unique titles
    unique_patterns = {
        # For "Gentle Spirit" duplicates
        'treasure.*dear': 'Treasured Spirit',
        'truest love': 'Truest Love',
        
        # For "Safe Harbor" duplicates  
        'tender touch.*sweet caress': 'Tender Caress',
        'your embrace.*find my peace': 'Peaceful Embrace',
        
        # For "Grateful Heart" duplicates
        'laughter.*joy.*grace': 'Joy and Grace',
        'solace you provide': 'Sweet Solace',
        'compassion.*deep.*vast': 'Deep Compassion',
        'thanks abound': 'Abundant Thanks',
        
        # For "Whispered Words" duplicates
        'bond so strong': 'Unbreakable Bond',
        'whispered word.*gentle touch': 'Gentle Whispers',
        
        # For "Radiant Smile" duplicates
        'sunbeam.*pure.*true': 'Pure Sunbeam',
        'gentle grace.*smile illuminates': 'Illuminating Grace',
        
        # For "Your Presence" duplicates
        'calms.*anxious mind': 'Calming Presence',
        'thousand stars.*moonlit sky': 'Starlit Dreams',
        'comforting embrace': 'Comfort Zone',
        'shadows deep.*found the light': 'Light in Shadows',
        'presence heals': 'Healing Presence',
        
        # For "Your Laughter" duplicates
        'joyous sound.*happiest music': 'Joyous Music',
        'melody.*sweetest sound': 'Sweet Melody'
    }
    
    # Check for specific patterns
    for pattern, title in unique_patterns.items():
        if re.search(pattern, clean_text):
            if title not in existing_titles:
                return title
    
    # Fallback: add descriptive suffix
    words = clean_text.split()
    
    # Look for key descriptive words
    descriptors = []
    key_words = ['bright', 'sweet', 'gentle', 'pure', 'deep', 'tender', 'warm', 'soft', 'kind', 'true', 'beautiful', 'precious', 'peaceful', 'joyful', 'healing']
    
    for word in words:
        if word in key_words and word not in base_title.lower():
            descriptors.append(word.capitalize())
    
    if descriptors:
        new_title = f"{base_title} ({descriptors[0]})"
        if new_title not in existing_titles:
            return new_title
    
    # Final fallback: numbered suffix
    counter = 2
    while f"{base_title} {counter}" in existing_titles:
        counter += 1
    return f"{base_title} {counter}"

# Load the poems
with open('public/consolidated_poems.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

# Track existing titles
existing_titles = set()
changes_made = []

# Process poems and fix duplicates
for poem in data['poems']:
    original_title = poem['title']
    
    if original_title in existing_titles:
        # Generate unique title
        new_title = generate_unique_title(poem['text'], existing_titles, original_title)
        poem['title'] = new_title
        existing_titles.add(new_title)
        changes_made.append({
            'id': poem['id'],
            'old_title': original_title,
            'new_title': new_title,
            'text_preview': poem['text'][:60] + '...'
        })
        print(f"Changed: '{original_title}' → '{new_title}' (ID: {poem['id']})")
    else:
        existing_titles.add(original_title)

print(f"\nTotal changes made: {len(changes_made)}")

# Save the updated file
with open('public/consolidated_poems.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)

print("Updated consolidated_poems.json with unique titles!")

# Verify no duplicates remain
titles_after = [poem['title'] for poem in data['poems']]
from collections import Counter
title_counts_after = Counter(titles_after)
duplicates_after = {title: count for title, count in title_counts_after.items() if count > 1}

if duplicates_after:
    print(f"\nWARNING: Still have {len(duplicates_after)} duplicate titles!")
    for title, count in duplicates_after.items():
        print(f"  '{title}': {count} times")
else:
    print(f"\n✅ SUCCESS: All {len(titles_after)} titles are now unique!")
