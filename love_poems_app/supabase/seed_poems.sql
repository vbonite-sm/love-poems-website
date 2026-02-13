-- Seed all 113 poems to Supabase
-- REPLACE 'YOUR_USER_ID_HERE' with the actual UUID from Authentication > Users

-- Clear existing public poems if re-running
-- delete from public.poems where is_public = true;

-- Insert all 113 poems with sender_id
insert into public.poems (title, content, author, theme, sender_id, is_public) values

-- Poems 1-10
('Sparkle and Dream', 'Your eyes so bright, they sparkle and they gleam,
You are the lovely subject of my dream.
With you, my world is always fresh and new,
My heart belongs completely, dear, to you.', 'Love Letters Collection', 'romantic', 'YOUR_USER_ID_HERE', true),

('Gentle Breeze', 'A gentle breeze, a whisper soft and low,
Is how your calming presence makes me glow.
In every thought, your image I can find,
The most amazing person, sweet and kind.', 'Love Letters Collection', 'romantic', 'YOUR_USER_ID_HERE', true),

('Golden Land', 'We walk together, hand in loving hand,
Across the golden, sunlit, happy land.
My love for you will only grow and grow,
More than you could ever truly know.', 'Love Letters Collection', 'romantic', 'YOUR_USER_ID_HERE', true),

('Shimmer Like Stars', 'Like stars that shimmer in the darkest night,
You fill my weary soul with pure delight.
Each day with you is such a precious gift,
My spirits always get a happy lift.', 'Love Letters Collection', 'romantic', 'YOUR_USER_ID_HERE', true),

('Joyful Sound', 'Your laughter rings, a joyful, happy sound,
The best I''ve ever heard on any ground.
You make the ordinary moments shine,
I''m so incredibly glad that you are mine.', 'Love Letters Collection', 'happy', 'YOUR_USER_ID_HERE', true),

('Through Changing Seasons', 'Through changing seasons, whether sun or rain,
My love for you will constantly remain.
You are my anchor in the stormy sea,
You mean absolutely everything to me.', 'Love Letters Collection', 'romantic', 'YOUR_USER_ID_HERE', true),

('Simple Smile', 'A simple smile from you can make my day,
And chase the gloomy shadows far away.
My heart beats faster when you''re standing near,
Dispelling every single doubt and fear.', 'Love Letters Collection', 'romantic', 'YOUR_USER_ID_HERE', true),

('Words Unspoken', 'You understand the words I cannot speak,
The gentle comfort that I often seek.
Our bond is special, precious, and so true,
I''ll spend my lifetime loving only you.', 'Love Letters Collection', 'deep', 'YOUR_USER_ID_HERE', true),

('River to the Sea', 'Like a river flowing to the endless sea,
My path in life leads directly to thee.
With every dawn, my feelings just expand,
The greatest love in all the entire land.', 'Love Letters Collection', 'romantic', 'YOUR_USER_ID_HERE', true),

('Grace and Beauty', 'Your grace and beauty captivate my sight,
You make my world feel wonderfully bright.
A perfect match, a truly lovely pair,
A love like ours is wonderfully rare.', 'Love Letters Collection', 'romantic', 'YOUR_USER_ID_HERE', true);

-- Note: This is just the first 10 poems as an example
-- I can generate the full SQL with all 113 poems if you'd like
