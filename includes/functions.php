<?php
// ==============================================================================
// YumBook - Helper Functions (includes/functions.php)
// ICT 1209: Web Technologies Mini-Project
// ==============================================================================

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

/**
 * Sanitize text input for safe HTML output
 */
function sanitize($data) {
    if (is_null($data)) return '';
    return htmlspecialchars(trim((string)$data), ENT_QUOTES, 'UTF-8');
}

/**
 * Format origin to display only the country name.
 * Strips parenthetical regional qualifiers like "(Maine / New England)" or "(Highlands)".
 */
function formatOrigin($origin) {
    if (empty($origin)) return 'Global';
    // Strip anything in parentheses (and surrounding whitespace)
    $country = trim(preg_replace('/\s*\(.*?\)/', '', $origin));
    // Also strip after " - " (e.g. "France - Le Beccherie Heritage")
    $country = trim(explode(' - ', $country)[0]);
    // Strip " & " joined pairs and return first
    if (strpos($country, ' & ') !== false) {
        $parts = explode(' & ', $country);
        $country = trim($parts[0]);
    }
    return $country ?: $origin;
}

/**
 * Check if the user is currently logged in
 */
function isLoggedIn() {
    return isset($_SESSION['user_id']) && !empty($_SESSION['user_id']);
}

/**
 * Get the current logged-in user's ID
 */
function getCurrentUserId() {
    return $_SESSION['user_id'] ?? null;
}

/**
 * Get the current logged-in user's full name
 */
function getCurrentUserName() {
    return $_SESSION['user_name'] ?? 'Guest';
}

/**
 * Set a session flash message (e.g. success, danger, warning, info)
 */
function setFlashMessage($type, $message) {
    $_SESSION['flash_message'] = [
        'type' => $type,
        'text' => $message
    ];
}

/**
 * Retrieve and clear the session flash message
 */
function getFlashMessage() {
    if (isset($_SESSION['flash_message'])) {
        $flash = $_SESSION['flash_message'];
        unset($_SESSION['flash_message']);
        return $flash;
    }
    return null;
}

/**
 * Get Bootstrap badge class based on recipe category
 */
function getCategoryBadgeClass($category) {
    switch (strtolower(trim($category))) {
        case 'breakfast':
            return 'bg-warning text-dark';
        case 'lunch':
            return 'bg-primary text-white';
        case 'dinner':
            return 'bg-danger text-white';
        case 'dessert':
            return 'bg-pink text-white';
        case 'vegan':
            return 'bg-success text-white';
        case 'beverages':
            return 'bg-info text-dark';
        default:
            return 'bg-secondary text-white';
    }
}

/**
 * Get Bootstrap icon for recipe category
 */
function getCategoryIcon($category) {
    switch (strtolower(trim($category))) {
        case 'breakfast':
            return 'bi-egg-fried';
        case 'lunch':
            return 'bi-bag-check';
        case 'dinner':
            return 'bi-fire';
        case 'dessert':
            return 'bi-cake2';
        case 'vegan':
            return 'bi-flower1';
        case 'beverages':
            return 'bi-cup-straw';
        default:
            return 'bi-journal-bookmark';
    }
}

/**
 * Render visual star rating HTML
 */
function renderStarRating($rating, $count = null, $showCount = true) {
    $rating = floatval($rating);
    $fullStars = floor($rating);
    $halfStar = ($rating - $fullStars) >= 0.5 ? 1 : 0;
    $emptyStars = 5 - ($fullStars + $halfStar);

    $html = '<span class="star-rating text-warning" title="' . number_format($rating, 1) . ' out of 5 stars">';

    for ($i = 0; $i < $fullStars; $i++) {
        $html .= '<i class="bi bi-star-fill me-1"></i>';
    }
    if ($halfStar) {
        $html .= '<i class="bi bi-star-half me-1"></i>';
    }
    for ($i = 0; $i < $emptyStars; $i++) {
        $html .= '<i class="bi bi-star me-1 text-muted"></i>';
    }

    $html .= '</span>';

    if ($showCount) {
        $html .= ' <span class="rating-score fw-bold ms-1">' . number_format($rating, 1) . '</span>';
        if ($count !== null) {
            $html .= ' <span class="text-muted small">(' . intval($count) . ')</span>';
        }
    }

    return $html;
}

/**
 * Curated per-recipe image map - guarantees an exact, food-matched photo for every recipe.
 * Falls back to category placeholders for any recipe not in the map.
 */
function getRecipeImageUrl($imageUrl, $category = 'Dinner', $recipeId = null) {
    // Per-recipe curated image map (reliable Unsplash photo IDs matched to each dish)
        $recipeImages = [
        // FULL 100-RECIPE ACCURATE IMAGE MAPPINGS
          1 => 'https://images.unsplash.com/photo-1528207776546-365bb710ee93?auto=format&fit=crop&w=1000&q=80',
          2 => 'https://images.unsplash.com/photo-1525351484163-7529414344d8?auto=format&fit=crop&w=1000&q=80',
          3 => 'assets/images/recipes/pol-roti.jpg',
          4 => 'https://images.unsplash.com/photo-1598515214211-89d3c73ae83b?auto=format&fit=crop&w=1000&q=80',
          5 => 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?auto=format&fit=crop&w=1000&q=80',
          6 => 'https://images.unsplash.com/photo-1484723091739-30a097e8f929?auto=format&fit=crop&w=1000&q=80',
          7 => 'https://images.unsplash.com/photo-1510693206972-df098062cb71?auto=format&fit=crop&w=1000&q=80',
          8 => 'assets/images/recipes/string-hoppers.jpg',
          9 => 'https://images.unsplash.com/photo-1590301157890-4810ed352733?auto=format&fit=crop&w=1000&q=80',
         10 => 'https://images.unsplash.com/photo-1590080875515-8a3a8dc5735e?auto=format&fit=crop&w=1000&q=80',
         11 => 'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?auto=format&fit=crop&w=1000&q=80',
         12 => 'https://images.unsplash.com/photo-1511690656952-34342bb7c2f2?auto=format&fit=crop&w=1000&q=80',
         13 => 'https://images.unsplash.com/photo-1582169296194-e4d644c48063?auto=format&fit=crop&w=1000&q=80',
         14 => 'https://images.unsplash.com/photo-1519676867240-f03562e64548?auto=format&fit=crop&w=1000&q=80',
         15 => 'assets/images/recipes/breakfast-quesadilla.jpg',
         16 => 'https://images.unsplash.com/photo-1608039829572-78524f79c4c7?auto=format&fit=crop&w=1000&q=80',
         17 => 'https://images.unsplash.com/photo-1517673132405-a56a62b18caf?auto=format&fit=crop&w=1000&q=80',
         18 => 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?auto=format&fit=crop&w=1000&q=80',
         19 => 'https://images.unsplash.com/photo-1550304943-4f24f54ddde9?auto=format&fit=crop&w=1000&q=80',
         20 => 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?auto=format&fit=crop&w=1000&q=80',
         21 => 'https://images.unsplash.com/photo-1547592166-23ac45744acd?auto=format&fit=crop&w=1000&q=80',
         22 => 'assets/images/recipes/ambul-thiyal.jpg',
         23 => 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?auto=format&fit=crop&w=1000&q=80',
         24 => 'https://images.unsplash.com/photo-1579208030886-b937da0925dc?auto=format&fit=crop&w=1000&q=80',
         25 => 'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?auto=format&fit=crop&w=1000&q=80',
         26 => 'assets/images/recipes/lamprais.jpg',
         27 => 'https://images.unsplash.com/photo-1528736235302-52922df5c122?auto=format&fit=crop&w=1000&q=80',
         28 => 'https://images.unsplash.com/photo-1626804475297-41608ea09aeb?auto=format&fit=crop&w=1000&q=80',
         29 => 'https://images.unsplash.com/photo-1555949258-eb67b1ef0ceb?auto=format&fit=crop&w=1000&q=80',
         30 => 'https://images.unsplash.com/photo-1553163147-622ab57be1c7?auto=format&fit=crop&w=1000&q=80',
         31 => 'https://images.unsplash.com/photo-1593560708920-61dd98c46a4e?auto=format&fit=crop&w=1000&q=80',
         32 => 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&w=1000&q=80',
         33 => 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=1000&q=80',
         34 => 'assets/images/recipes/kottu-roti.jpg',
         35 => 'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=1000&q=80',
         36 => 'https://images.unsplash.com/photo-1612874742237-6526221588e3?auto=format&fit=crop&w=1000&q=80',
         37 => 'assets/images/recipes/black-pork-curry.jpg',
         38 => 'assets/images/recipes/pan-seared-salmon.jpg',
         39 => 'https://images.unsplash.com/photo-1574894709920-11b28e7367e3?auto=format&fit=crop&w=1000&q=80',
         40 => 'https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?auto=format&fit=crop&w=1000&q=80',
         41 => 'https://images.unsplash.com/photo-1514944298352-780c7a52f954?auto=format&fit=crop&w=1000&q=80',
         42 => 'https://images.unsplash.com/photo-1541518763669-27fef04b14ea?auto=format&fit=crop&w=1000&q=80',
         43 => 'assets/images/recipes/jaffna-crab-curry.jpg',
         44 => 'https://images.unsplash.com/photo-1632778149955-e80f8ceca2e8?auto=format&fit=crop&w=1000&q=80',
         45 => 'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?auto=format&fit=crop&w=1000&q=80',
         46 => 'https://images.unsplash.com/photo-1534080564583-6be75777b70a?auto=format&fit=crop&w=1000&q=80',
         47 => 'https://images.unsplash.com/photo-1584947897672-005fa95781a7?auto=format&fit=crop&w=1000&q=80',
         48 => 'assets/images/recipes/mutton-curry.jpg',
         49 => 'https://images.unsplash.com/photo-1600891964599-f61ba0e24092?auto=format&fit=crop&w=1000&q=80',
         50 => 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?auto=format&fit=crop&w=1000&q=80',
         51 => 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?auto=format&fit=crop&w=1000&q=80',
         52 => 'https://images.unsplash.com/photo-1533134242443-d4fd215305ad?auto=format&fit=crop&w=1000&q=80',
         53 => 'assets/images/recipes/watalappan.jpg',
         54 => 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&w=1000&q=80',
         55 => 'https://images.unsplash.com/photo-1569864321318-479606822c9e?auto=format&fit=crop&w=1000&q=80',
         56 => 'https://images.unsplash.com/photo-1568571780765-9276ac8b75a2?auto=format&fit=crop&w=1000&q=80',
         57 => 'https://images.unsplash.com/photo-1470124182917-cc6e71b22ecc?auto=format&fit=crop&w=1000&q=80',
         58 => 'https://images.unsplash.com/photo-1607920591413-4ec007e70023?auto=format&fit=crop&w=1000&q=80',
         59 => 'assets/images/recipes/milk-toffee.jpg',
         60 => 'https://images.unsplash.com/photo-1624300629298-e9de39c13be5?auto=format&fit=crop&w=1000&q=80',
         61 => 'https://images.unsplash.com/photo-1596797038530-2c107229654b?auto=format&fit=crop&w=1000&q=80',
         62 => 'https://images.unsplash.com/photo-1519915028121-7d3463d20b13?auto=format&fit=crop&w=1000&q=80',
         63 => 'https://images.unsplash.com/photo-1488477181946-6428a0291777?auto=format&fit=crop&w=1000&q=80',
         64 => 'https://images.unsplash.com/photo-1614707267537-b85aaf00c4b7?auto=format&fit=crop&w=1000&q=80',
         65 => 'assets/images/recipes/french-strawberry-tart.jpg',
         66 => 'assets/images/recipes/bibikkan.jpg',
         67 => 'https://images.unsplash.com/photo-1551024601-bec78aea704b?auto=format&fit=crop&w=1000&q=80',
         68 => 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?auto=format&fit=crop&w=1000&q=80',
         69 => 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?auto=format&fit=crop&w=1000&q=80',
         70 => 'https://images.unsplash.com/photo-1546833998-877b37c2e5c6?auto=format&fit=crop&w=1000&q=80',
         71 => 'assets/images/recipes/polos-curry.jpg',
         72 => 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=1000&q=80',
         73 => 'https://images.unsplash.com/photo-1476718406336-bb5a9690ee2a?auto=format&fit=crop&w=1000&q=80',
         74 => 'https://images.unsplash.com/photo-1598103442097-8b74394b95c6?auto=format&fit=crop&w=1000&q=80',
         75 => 'https://images.unsplash.com/photo-1541518763669-27fef04b14ea?auto=format&fit=crop&w=1000&q=80',
         76 => 'assets/images/recipes/thai-peanut-rice-noodle-salad.jpg',
         77 => 'https://images.unsplash.com/photo-1541832676-9b763b0239ab?auto=format&fit=crop&w=1000&q=80',
         78 => 'https://images.unsplash.com/photo-1505253716362-afaea1d3d1af?auto=format&fit=crop&w=1000&q=80',
         79 => 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?auto=format&fit=crop&w=1000&q=80',
         80 => 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?auto=format&fit=crop&w=1000&q=80',
         81 => 'https://images.unsplash.com/photo-1525607551316-4a8e16d1f9ba?auto=format&fit=crop&w=1000&q=80',
         82 => 'https://images.unsplash.com/photo-1562967914-608f82629710?auto=format&fit=crop&w=1000&q=80',
         83 => 'https://images.unsplash.com/photo-1579372786545-d24232daf58c?auto=format&fit=crop&w=1000&q=80',
         84 => 'https://images.unsplash.com/photo-1546833998-877b37c2e5c6?auto=format&fit=crop&w=1000&q=80',
         85 => 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?auto=format&fit=crop&w=1000&q=80',
         86 => 'assets/images/recipes/mango-passion-fruit-smoothie.jpg',
         87 => 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?auto=format&fit=crop&w=1000&q=80',
         88 => 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?auto=format&fit=crop&w=1000&q=80',
         89 => 'assets/images/recipes/brazilian-limonada-suica.jpg',
         90 => 'https://images.unsplash.com/photo-1551024709-8f23befc6f87?auto=format&fit=crop&w=1000&q=80',
         91 => 'https://images.unsplash.com/photo-1570696516188-ade861b84a49?auto=format&fit=crop&w=1000&q=80',
         92 => 'https://images.unsplash.com/photo-1517256064527-09c73fc73e38?auto=format&fit=crop&w=1000&q=80',
         93 => 'https://images.unsplash.com/photo-1525385133512-2f3bdd039054?auto=format&fit=crop&w=1000&q=80',
         94 => 'assets/images/recipes/blue-ocean-mocktail.jpg',
         95 => 'https://images.unsplash.com/photo-1543083477-4f785aeafaa9?auto=format&fit=crop&w=1000&q=80',
         96 => 'https://images.unsplash.com/photo-1589733955941-5eeaf752f6dd?auto=format&fit=crop&w=1000&q=80',
         97 => 'https://images.unsplash.com/photo-1597481499750-3e6b22637e12?auto=format&fit=crop&w=1000&q=80',
         98 => 'https://images.unsplash.com/photo-1542990253-0d0f5be5f0ed?auto=format&fit=crop&w=1000&q=80',
         99 => 'https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b?auto=format&fit=crop&w=1000&q=80',
        100 => 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?auto=format&fit=crop&w=1000&q=80',
    ];

    // If DB has a valid local asset or URL, use it
    if (!empty($imageUrl)) {
        return $imageUrl;
    }

    // Always use the curated image for known recipe IDs
    if ($recipeId !== null && isset($recipeImages[(int)$recipeId])) {
        return $recipeImages[(int)$recipeId];
    }

    // Last resort: category placeholder
    $placeholders = [
        'breakfast' => 'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?auto=format&fit=crop&w=600&q=80',
        'lunch'     => 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80',
        'dinner'    => 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?auto=format&fit=crop&w=600&q=80',
        'dessert'   => 'https://images.unsplash.com/photo-1587314168485-3236d6710814?auto=format&fit=crop&w=600&q=80',
        'vegan'     => 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
        'beverages' => 'https://images.unsplash.com/photo-1544145945-f90425340c7e?auto=format&fit=crop&w=600&q=80',
    ];

    $key = strtolower(trim($category));
    return $placeholders[$key] ?? 'https://images.unsplash.com/photo-1498837167922-ddd27525d352?auto=format&fit=crop&w=600&q=80';
}
