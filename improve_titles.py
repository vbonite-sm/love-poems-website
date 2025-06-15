import json
import re

def generate_better_title(text, poem_id):
    """Generate more specific and meaningful titles"""
    # Clean the text
    clean_text = text.replace('<br>', ' ').replace('"', '').strip().lower()
    
    # Specific patterns and their corresponding titles
    specific_titles = {
        # Specific imagery
        'candles flicker': 'Candlelight Magic',
        'rose petals': 'Rose Petals',
        'thunder rumbles': 'Safe in the Storm',
        'diamonds sparkle': 'Diamond Heart',
        'mirrors reflect': 'True Reflection',
        'galaxies afar': 'Galaxy of Love',
        'crystal dewdrops': 'Morning Dewdrops',
        'silver moonlight': 'Silver Moonbeams',
        'golden sunrise': 'Golden Dawn',
        'raindrops fall': 'Love in the Rain',
        'window panes': 'Window to My Heart',
        
        # Emotions and actions
        'your laughter rings': 'Your Laughter',
        'your smile': 'Radiant Smile',
        'your eyes': 'In Your Eyes',
        'your embrace': 'Safe Harbor',
        'your touch': 'Gentle Touch',
        'your presence': 'Your Presence',
        'find my peace': 'Finding Peace',
        'gentle spirit': 'Gentle Spirit',
        'heart beats strong': 'Steady Heartbeat',
        'every morning': 'Morning Thoughts',
        'every breath': 'With Every Breath',
        'tender heart': 'Tender Heart',
        'work of art': 'Work of Art',
        'shadows deep': 'Light in Darkness',
        'thousand stars': 'Starlit Love',
        'perfect sweet': 'Sweet Reality',
        'precious gem': 'Precious Moments',
        'whispered word': 'Whispered Words',
        'grateful heart': 'Grateful Heart',
        'gentle grace': 'Graceful Love',
        'bond so strong': 'Unbreakable Bond',
        'brand new start': 'New Beginnings',
        'whispered prayer': 'Silent Prayer',
        'endless care': 'Endless Care',
        'find my song': 'My Song',
        'brand new start': 'Fresh Start',
        'flame.*steady glow': 'Steady Flame',
        'side by side': 'Side by Side',
        'every tear': 'Healing Tears',
        'stars.*dance': 'Dancing Stars',
        'moonbeams dance': 'Dancing Moonbeams',
        'earth.*heaven': 'Heaven on Earth'
    }
    
    # First, check for specific patterns
    for pattern, title in specific_titles.items():
        if re.search(pattern, clean_text):
            return title
    
    # If no specific pattern matches, use first meaningful words
    words = clean_text.split()
    
    # Look for meaningful starting phrases
    if len(words) >= 3:
        first_three = ' '.join(words[:3])
        
        # Some common beautiful starting phrases
        if 'my love for' in first_three:
            return 'My Love For You'
        elif 'in your' in first_three:
            return 'In Your Embrace'
        elif 'for all' in first_three:
            return 'Grateful Heart'
        elif 'with every' in first_three:
            return 'With Every Beat'
        elif 'through every' in first_three:
            return 'Through Every Season'
        elif 'each moment' in first_three:
            return 'Precious Moments'
        elif 'my heart' in first_three:
            return 'My Heart Sings'
        elif 'your gentle' in first_three:
            return 'Gentle Soul'
        elif 'my dearest' in first_three:
            return 'My Dearest Love'
        elif 'a love like' in first_three:
            return 'Precious Gift'
        elif 'joy blooms' in first_three:
            return 'Blooming Joy'
        elif 'thank you' in first_three:
            return 'My Gratitude'
    
    # Fallback to numbered titles to ensure uniqueness
    return f"Love Poem {poem_id - 2000}"

# Load the consolidated file
print("Loading consolidated poems...")
with open('consolidated_poems_v2.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

# Update titles for main_poems_txt entries
updated_count = 0
for poem in data['poems']:
    if poem['source'] == 'main_poems_txt':
        old_title = poem['title']
        new_title = generate_better_title(poem['text'], poem['id'])
        if new_title != old_title:
            poem['title'] = new_title
            updated_count += 1
            print(f"Updated: {old_title} -> {new_title}")

print(f"\nUpdated {updated_count} titles")

# Save the improved version
with open('consolidated_poems_v3.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)

print("Saved improved version as 'consolidated_poems_v3.json'")
print(f"Total poems: {len(data['poems'])}")
print(f"JSON poems: {data['metadata']['sources']['json_file']}")
print(f"Text poems: {data['metadata']['sources']['main_poems_txt']}")
