/**
 * YumBook - Client Store & Application State (assets/js/app-store.js)
 * ICT 1209: Web Technologies Mini-Project
 */

const STORAGE_KEYS = {
    RECIPES: 'yumbook_recipes_v18',
    MESSAGES: 'yumbook_messages',
    RATINGS: 'yumbook_ratings'
};

// Initialize Data Store in LocalStorage with Safe Recipe Version Migration
function initAppStore() {
    const canonicalMap = new Map();
    if (typeof INITIAL_RECIPES !== 'undefined' && Array.isArray(INITIAL_RECIPES)) {
        INITIAL_RECIPES.forEach(r => canonicalMap.set(r.id, r));
    }

    const currentV11Data = localStorage.getItem(STORAGE_KEYS.RECIPES);

    if (!currentV11Data) {
        // Collect custom user recipes (id > 100) from prior storage keys
        let customRecipes = [];
        const oldVersionKeys = [
            'yumbook_recipes_v17',
            'yumbook_recipes_v16',
            'yumbook_recipes_v15',
            'yumbook_recipes_v14',
            'yumbook_recipes_v13',
            'yumbook_recipes_v12',
            'yumbook_recipes_v11',
            'yumbook_recipes_v10',
            'yumbook_recipes_v9',
            'yumbook_recipes_v8',
            'yumbook_recipes_v7',
            'yumbook_recipes_v6',
            'yumbook_recipes_v5',
            'yumbook_recipes_v4',
            'yumbook_recipes_v3',
            'yumbook_recipes_v2',
            'yumbook_recipes'
        ];

        // Also preserve user ratings for built-in recipes
        const userRatingOverrides = new Map();

        for (const key of oldVersionKeys) {
            try {
                const oldList = JSON.parse(localStorage.getItem(key));
                if (Array.isArray(oldList)) {
                    oldList.forEach(r => {
                        if (r && r.id > 100) {
                            if (!customRecipes.some(c => c.id === r.id)) {
                                customRecipes.push(r);
                            }
                        } else if (r && r.id <= 100) {
                            if (r.rating_count && !userRatingOverrides.has(r.id)) {
                                userRatingOverrides.set(r.id, {
                                    avg_rating: r.avg_rating,
                                    rating_count: r.rating_count
                                });
                            }
                        }
                    });
                }
            } catch (e) {}
        }

        // Build canonical recipes 1-100 with guaranteed correct data & image_url
        const freshBuiltins = (typeof INITIAL_RECIPES !== 'undefined' ? INITIAL_RECIPES : []).map(canonical => {
            const recipeCopy = { ...canonical };
            if (userRatingOverrides.has(recipeCopy.id)) {
                const userRating = userRatingOverrides.get(recipeCopy.id);
                recipeCopy.avg_rating = userRating.avg_rating;
                recipeCopy.rating_count = userRating.rating_count;
            }
            return recipeCopy;
        });

        const fullDataset = [...customRecipes, ...freshBuiltins];
        localStorage.setItem(STORAGE_KEYS.RECIPES, JSON.stringify(fullDataset));
    } else {
        // Continuous synchronization: ensure built-in recipes 1-100 in existing storage match canonical data
        try {
            const parsed = JSON.parse(currentV11Data);
            if (Array.isArray(parsed) && canonicalMap.size > 0) {
                let hasChanges = false;
                const updatedStore = parsed.map(recipe => {
                    if (recipe && recipe.id <= 100 && canonicalMap.has(recipe.id)) {
                        const canonical = canonicalMap.get(recipe.id);
                        if (recipe.image_url !== canonical.image_url || 
                            recipe.title !== canonical.title || 
                            recipe.category !== canonical.category ||
                            recipe.origin !== canonical.origin) {
                            recipe.image_url = canonical.image_url;
                            recipe.title = canonical.title;
                            recipe.category = canonical.category;
                            recipe.origin = canonical.origin;
                            recipe.ingredients = canonical.ingredients;
                            recipe.steps = canonical.steps;
                            if (canonical.name) recipe.name = canonical.name;
                            if (canonical.description) recipe.description = canonical.description;
                            if (canonical.prep_time) recipe.prep_time = canonical.prep_time;
                            if (canonical.preparation_time) recipe.preparation_time = canonical.preparation_time;
                            if (canonical.cooking_time) recipe.cooking_time = canonical.cooking_time;
                            if (canonical.servings) recipe.servings = canonical.servings;
                            if (canonical.difficulty) recipe.difficulty = canonical.difficulty;
                            if (canonical.cooking_instructions) recipe.cooking_instructions = canonical.cooking_instructions;
                            hasChanges = true;
                        }
                    }
                    return recipe;
                });
                if (hasChanges) {
                    localStorage.setItem(STORAGE_KEYS.RECIPES, JSON.stringify(updatedStore));
                }
            }
        } catch (e) {}
    }

    if (!localStorage.getItem(STORAGE_KEYS.MESSAGES)) {
        localStorage.setItem(STORAGE_KEYS.MESSAGES, JSON.stringify([]));
    }
    if (!localStorage.getItem(STORAGE_KEYS.RATINGS)) {
        localStorage.setItem(STORAGE_KEYS.RATINGS, JSON.stringify([]));
    }
}

// -------------------------------------------------------------
// Recipe Operations
// -------------------------------------------------------------
function getAllRecipes() {
    initAppStore();
    try {
        return JSON.parse(localStorage.getItem(STORAGE_KEYS.RECIPES)) || INITIAL_RECIPES;
    } catch (e) {
        return INITIAL_RECIPES;
    }
}

function getRecipeById(id) {
    const recipes = getAllRecipes();
    return recipes.find(r => String(r.id) === String(id));
}

function saveNewRecipe(recipeData) {
    const recipes = getAllRecipes();
    const newId = recipes.length > 0 ? Math.max(...recipes.map(r => r.id)) + 1 : 101;
    const trimmedUrl = (recipeData.image_url || '').trim();

    const newRecipe = {
        id: newId,
        title: recipeData.title,
        category: recipeData.category,
        origin: recipeData.origin || 'Global',
        cooking_time: parseInt(recipeData.cooking_time) || 30,
        author_name: recipeData.author_name || 'Community Chef',
        image_url: trimmedUrl || 'assets/images/recipes/recipe-placeholder.jpg',
        avg_rating: 5.0,
        rating_count: 1,
        ingredients: recipeData.ingredients,
        steps: recipeData.steps
    };

    recipes.unshift(newRecipe);
    localStorage.setItem(STORAGE_KEYS.RECIPES, JSON.stringify(recipes));
    return newRecipe;
}

function rateRecipe(recipeId, ratingValue) {
    const recipes = getAllRecipes();
    const recipeIndex = recipes.findIndex(r => String(r.id) === String(recipeId));
    
    if (recipeIndex !== -1) {
        const recipe = recipes[recipeIndex];
        const currentTotal = (recipe.avg_rating || 5) * (recipe.rating_count || 1);
        const newCount = (recipe.rating_count || 1) + 1;
        const newAvg = (currentTotal + ratingValue) / newCount;

        recipe.avg_rating = parseFloat(newAvg.toFixed(1));
        recipe.rating_count = newCount;

        recipes[recipeIndex] = recipe;
        localStorage.setItem(STORAGE_KEYS.RECIPES, JSON.stringify(recipes));
        return recipe;
    }
    return null;
}

// -------------------------------------------------------------
// Contact Messages
// -------------------------------------------------------------
function saveContactMessage(name, email, message) {
    initAppStore();
    const messages = JSON.parse(localStorage.getItem(STORAGE_KEYS.MESSAGES)) || [];
    messages.push({
        id: Date.now(),
        name,
        email,
        message,
        date: new Date().toISOString()
    });
    localStorage.setItem(STORAGE_KEYS.MESSAGES, JSON.stringify(messages));
}

// -------------------------------------------------------------
// UI Helpers
// -------------------------------------------------------------
function renderStars(rating, count = null) {
    const r = parseFloat(rating) || 5.0;
    const fullStars = Math.floor(r);
    const hasHalf = (r - fullStars) >= 0.5 ? 1 : 0;
    const emptyStars = 5 - (fullStars + hasHalf);

    let html = `<span class="star-rating text-warning" title="${r.toFixed(1)} / 5 stars">`;
    for (let i = 0; i < fullStars; i++) html += '<i class="bi bi-star-fill me-1"></i>';
    if (hasHalf) html += '<i class="bi bi-star-half me-1"></i>';
    for (let i = 0; i < emptyStars; i++) html += '<i class="bi bi-star me-1 text-muted"></i>';
    html += `</span> <span class="rating-score fw-bold ms-1">${r.toFixed(1)}</span>`;
    if (count !== null) {
        html += ` <span class="text-muted small">(${count})</span>`;
    }
    return html;
}

function getCategoryBadgeClass(category) {
    switch ((category || '').toLowerCase().trim()) {
        case 'sri lankan': return 'bg-danger text-white';
        case 'breakfast': return 'bg-warning text-dark';
        case 'lunch': return 'bg-primary text-white';
        case 'dinner': return 'bg-danger text-white';
        case 'dessert': return 'bg-pink text-white';
        case 'vegan': return 'bg-success text-white';
        case 'beverages': return 'bg-info text-dark';
        default: return 'bg-secondary text-white';
    }
}

function getCategoryIcon(category) {
    switch ((category || '').toLowerCase().trim()) {
        case 'sri lankan': return 'bi-fire';
        case 'breakfast': return 'bi-egg-fried';
        case 'lunch': return 'bi-bag-check';
        case 'dinner': return 'bi-fire';
        case 'dessert': return 'bi-cake2';
        case 'vegan': return 'bi-flower1';
        case 'beverages': return 'bi-cup-straw';
        default: return 'bi-journal-bookmark';
    }
}

function getCategoryFallbackImage(category) {
    return 'assets/images/recipes/recipe-placeholder.jpg';
}

function escapeHTML(str) {
    if (!str) return '';
    return String(str)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#039;');
}

document.addEventListener('DOMContentLoaded', () => {
    initAppStore();
});
