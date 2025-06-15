// Load poems from the consolidated JSON file
let allPoems = [];
let currentPoem = null;
let favorites = JSON.parse(localStorage.getItem('favoritePoems') || '[]');

async function loadPoems() {
    try {
        const response = await fetch('/consolidated_poems.json');
        const data = await response.json();
        allPoems = data.poems;
        console.log(`Loaded ${allPoems.length} poems`);
    } catch (error) {
        console.error('Error loading poems:', error);
        // Fallback to embedded poems if file loading fails
        loadFallbackPoems();
    }
}

function loadFallbackPoems() {
    allPoems = [
        {
            id: 1,
            title: "Every Moment With You",
            text: "Every moment with you is a blessing, Every touch, a tender caressing. In your eyes, I found my home, With you, I'm never alone.",
            source: "fallback"
        },
        {
            id: 2,
            title: "My Heart's Symphony",
            text: "Your laughter is my heart's symphony, Your smile, the light guiding me. In this world of chaos and strife, You're the peace and joy in my life.",
            source: "fallback"
        },
        {
            id: 3,
            title: "Love Beyond Words",
            text: "Some feelings words cannot contain, Like sunshine after pouring rain. My love for you grows every day, In every possible way.",
            source: "fallback"
        }
    ];
}

function getRandomPoem() {
    if (allPoems.length === 0) return null;
    const randomIndex = Math.floor(Math.random() * allPoems.length);
    return allPoems[randomIndex];
}

function displayPoem(poem) {
    const poemContainer = document.getElementById('poem-container');
    
    // Create fade-out effect
    poemContainer.style.opacity = 0;
    
    setTimeout(() => {
        // Clean the poem text (remove HTML tags if any)
        const cleanText = poem.text.replace(/<br\s*\/?>/gi, '<br>');
        
        poemContainer.innerHTML = `
            <div class="text-center">
                ${poem.title ? `<h2 class="text-2xl font-bold text-pink-600 mb-4">${poem.title}</h2>` : ''}
                <p class="poem-text text-xl md:text-2xl text-gray-700 leading-relaxed">${cleanText}</p>
            </div>
        `;
        
        // Update favorite button
        updateFavoriteButton(poem);
        
        // Create fade-in effect
        poemContainer.style.opacity = 1;
        poemContainer.style.transition = 'opacity 0.5s ease';
        
        currentPoem = poem;
    }, 300);
}

function updateFavoriteButton(poem) {
    const favoriteBtn = document.getElementById('favorite-poem');
    const isFavorite = favorites.some(fav => fav.id === poem.id);
    
    if (isFavorite) {
        favoriteBtn.innerHTML = '💖 Favorited';
        favoriteBtn.classList.remove('from-purple-500', 'to-indigo-500', 'hover:from-purple-600', 'hover:to-indigo-600');
        favoriteBtn.classList.add('from-red-500', 'to-pink-500', 'hover:from-red-600', 'hover:to-pink-600');
    } else {
        favoriteBtn.innerHTML = '❤️ Favorite';
        favoriteBtn.classList.remove('from-red-500', 'to-pink-500', 'hover:from-red-600', 'hover:to-pink-600');
        favoriteBtn.classList.add('from-purple-500', 'to-indigo-500', 'hover:from-purple-600', 'hover:to-indigo-600');
    }
}

function toggleFavorite() {
    if (!currentPoem) return;
    
    const existingIndex = favorites.findIndex(fav => fav.id === currentPoem.id);
    
    if (existingIndex >= 0) {
        // Remove from favorites
        favorites.splice(existingIndex, 1);
        showNotification('Removed from favorites', 'info');
    } else {
        // Add to favorites
        favorites.push(currentPoem);
        showNotification('Added to favorites!', 'success');
    }
    
    localStorage.setItem('favoritePoems', JSON.stringify(favorites));
    updateFavoriteButton(currentPoem);
}

function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `fixed top-4 right-4 px-6 py-3 rounded-lg text-white font-medium z-50 transform translate-x-full transition-transform duration-300 ${
        type === 'success' ? 'bg-green-500' : 'bg-blue-500'
    }`;
    notification.textContent = message;
    
    document.body.appendChild(notification);
    
    // Animate in
    setTimeout(() => {
        notification.classList.remove('translate-x-full');
    }, 100);
    
    // Animate out and remove
    setTimeout(() => {
        notification.classList.add('translate-x-full');
        setTimeout(() => {
            document.body.removeChild(notification);
        }, 300);
    }, 3000);
}

// Initialize the app
document.addEventListener('DOMContentLoaded', async function() {
    await loadPoems();
    
    // Event listeners
    document.getElementById('new-poem').addEventListener('click', function() {
        const poem = getRandomPoem();
        if (poem) {
            displayPoem(poem);
        }
    });
    
    document.getElementById('favorite-poem').addEventListener('click', toggleFavorite);
    
    // Display first poem automatically
    const firstPoem = getRandomPoem();
    if (firstPoem) {
        displayPoem(firstPoem);
    }
});
