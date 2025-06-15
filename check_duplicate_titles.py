import json
from collections import Counter

# Load the poems
with open('public/consolidated_poems.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

# Count title occurrences
titles = [poem['title'] for poem in data['poems']]
title_counts = Counter(titles)

# Find duplicates
duplicates = {title: count for title, count in title_counts.items() if count > 1}

print(f'Total poems: {len(data["poems"])}')
print(f'Unique titles: {len(title_counts)}')
print(f'Duplicate titles found: {len(duplicates)}')
print()

if duplicates:
    print('Duplicate titles:')
    for title, count in sorted(duplicates.items()):
        print(f'  "{title}": {count} times')
        
    print('\nPoems with duplicate titles:')
    for title in duplicates:
        matching_poems = [poem for poem in data['poems'] if poem['title'] == title]
        print(f'\n--- "{title}" ({len(matching_poems)} poems) ---')
        for i, poem in enumerate(matching_poems):
            print(f'{i+1}. ID: {poem["id"]}, Source: {poem["source"]}')
            print(f'   Text: {poem["text"][:80]}...')
else:
    print('No duplicate titles found!')
