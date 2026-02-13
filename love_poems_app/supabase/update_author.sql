-- Update the author column for all poems to 'Vlad'
UPDATE public.poems
SET author = 'Vlad'
WHERE is_public = true;

-- Verify the update
SELECT count(*) as updated_poems_count
FROM public.poems
WHERE author = 'Vlad';
