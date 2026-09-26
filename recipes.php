<?php
// ==============================================================================
// YumBook - Browse / Search Recipes Page (recipes.php)
// ICT 1209: Web Technologies Mini-Project
// Wireframe: 7.2 Browse / Search Recipes Page
// ==============================================================================

$pageTitle = 'Browse & Search Recipes - YumBook';
require_once __DIR__ . '/includes/header.php';

// -----------------------------------------------------------------------------
// Read and Sanitize Query Parameters
// -----------------------------------------------------------------------------
$searchQuery = trim($_GET['q'] ?? '');
$categoryFilter = trim($_GET['category'] ?? '');
$timeFilter = trim($_GET['time'] ?? '');
$sortOption = trim($_GET['sort'] ?? 'newest');
$page = max(1, intval($_GET['page'] ?? 1));
$perPage = 12;
$offset = ($page - 1) * $perPage;

// -----------------------------------------------------------------------------
// Build Dynamic SQL Query with Prepared Statements
// -----------------------------------------------------------------------------
$whereClauses = [];
$params = [];

// 1. Search Query (Title, Ingredients, or Category)
if (!empty($searchQuery)) {
    $whereClauses[] = "(r.title LIKE :search_title OR r.ingredients LIKE :search_ing OR r.category LIKE :search_cat OR r.origin LIKE :search_origin)";
    $params['search_title'] = '%' . $searchQuery . '%';
    $params['search_ing'] = '%' . $searchQuery . '%';
    $params['search_cat'] = '%' . $searchQuery . '%';
    $params['search_origin'] = '%' . $searchQuery . '%';
}

// 2. Category Filter
$validCategories = ['Breakfast', 'Lunch', 'Dinner', 'Dessert', 'Vegan', 'Beverages'];
if (!empty($categoryFilter) && in_array($categoryFilter, $validCategories)) {
    $whereClauses[] = "r.category = :category";
    $params['category'] = $categoryFilter;
}

// 3. Cooking Time Filter
if ($timeFilter === 'under30') {
    $whereClauses[] = "r.cooking_time < 30";
} elseif ($timeFilter === '30to60') {
    $whereClauses[] = "r.cooking_time BETWEEN 30 AND 60";
} elseif ($timeFilter === 'over60') {
    $whereClauses[] = "r.cooking_time > 60";
}

$whereSql = !empty($whereClauses) ? 'WHERE ' . implode(' AND ', $whereClauses) : '';

// 4. Sorting Logic
$orderBy = "r.id DESC"; // Default: Newest
if ($sortOption === 'highest_rated') {
    $orderBy = "avg_rating DESC, rating_count DESC, r.id DESC";
} elseif ($sortOption === 'time_asc') {
    $orderBy = "r.cooking_time ASC";
} elseif ($sortOption === 'time_desc') {
    $orderBy = "r.cooking_time DESC";
} elseif ($sortOption === 'title_asc') {
    $orderBy = "r.title ASC";
}

// -----------------------------------------------------------------------------
// Get Total Matching Recipe Count for Pagination
// -----------------------------------------------------------------------------
$countSql = "SELECT COUNT(DISTINCT r.id) FROM recipes r {$whereSql}";
$countStmt = $pdo->prepare($countSql);
$countStmt->execute($params);
$totalRecipes = (int) $countStmt->fetchColumn();
$totalPages = ceil($totalRecipes / $perPage);

// -----------------------------------------------------------------------------
// Fetch Paginated Recipes
// -----------------------------------------------------------------------------
$sql = "
    SELECT r.*, 
           COALESCE(AVG(rt.rating), 0) AS avg_rating,
           COUNT(rt.id) AS rating_count,
           u.name AS author_name
    FROM recipes r
    LEFT JOIN ratings rt ON r.id = rt.recipe_id
    LEFT JOIN users u ON r.user_id = u.id
    {$whereSql}
    GROUP BY r.id
    ORDER BY {$orderBy}
    LIMIT :offset, :perPage
";

$stmt = $pdo->prepare($sql);
foreach ($params as $key => $val) {
    $stmt->bindValue(':' . $key, $val);
}
$stmt->bindValue(':offset', $offset, PDO::PARAM_INT);
$stmt->bindValue(':perPage', $perPage, PDO::PARAM_INT);
$stmt->execute();
$recipes = $stmt->fetchAll();

// Get recipe count per category for sidebar display
$categoryCountsStmt = $pdo->query("SELECT category, COUNT(*) as count FROM recipes GROUP BY category");
$categoryCounts = $categoryCountsStmt->fetchAll(PDO::FETCH_KEY_PAIR);
?>

<div class="container">
    <!-- Page Header & Search Bar (Matches Wireframe 7.2) -->
    <div class="d-md-flex justify-content-between align-items-center mb-4">
        <div>
            <h1 class="h2 fw-bold text-dark mb-1">Browse Recipes</h1>
            <p class="text-muted mb-0">Showing <?= number_format($totalRecipes) ?> delicious recipes</p>
        </div>
    </div>

    <!-- Search & Sort Top Toolbar -->
    <form action="recipes.php" method="GET" id="searchFilterForm" class="mb-4">
        <div class="card p-3 border-0 shadow-sm rounded-3">
            <div class="row g-2 align-items-center">
                <div class="col-md-7">
                    <div class="input-group">
                        <span class="input-group-text bg-white text-muted border-end-0">
                            <i class="bi bi-search"></i>
                        </span>
                        <input type="text" 
                               name="q" 
                               class="form-control border-start-0" 
                               placeholder="Search by recipe name or ingredient..." 
                               value="<?= htmlspecialchars($searchQuery) ?>">
                        <button class="btn btn-primary" type="submit">Search</button>
                    </div>
                </div>
                
                <div class="col-md-5">
                    <div class="d-flex align-items-center gap-2 justify-content-md-end">
                        <label for="sortSelect" class="form-label mb-0 small text-nowrap fw-semibold">Sort by:</label>
                        <select name="sort" id="sortSelect" class="form-select form-select-sm" style="max-width: 200px;" onchange="this.form.submit()">
                            <option value="newest" <?= ($sortOption === 'newest') ? 'selected' : '' ?>>Newest</option>
                            <option value="highest_rated" <?= ($sortOption === 'highest_rated') ? 'selected' : '' ?>>Highest Rated</option>
                            <option value="time_asc" <?= ($sortOption === 'time_asc') ? 'selected' : '' ?>>Cooking Time: Fast first</option>
                            <option value="time_desc" <?= ($sortOption === 'time_desc') ? 'selected' : '' ?>>Cooking Time: Slow first</option>
                            <option value="title_asc" <?= ($sortOption === 'title_asc') ? 'selected' : '' ?>>Alphabetical (A-Z)</option>
                        </select>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4 mt-2">
            <!-- Sidebar Filter Column (Matches Wireframe 7.2) -->
            <div class="col-lg-3">
                <div class="card filter-card p-3 mb-4 shadow-sm">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold mb-0">Filters</h5>
                        <?php if (!empty($searchQuery) || !empty($categoryFilter) || !empty($timeFilter)): ?>
                            <a href="recipes.php" class="small text-danger text-decoration-none">Reset All</a>
                        <?php endif; ?>
                    </div>

                    <!-- Category Filters -->
                    <div class="mb-4">
                        <h6 class="fw-semibold text-secondary mb-2">Category</h6>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="radio" name="category" id="cat_all" value="" <?= empty($categoryFilter) ? 'checked' : '' ?>>
                            <label class="form-check-label d-flex justify-content-between" for="cat_all">
                                <span>All Categories</span>
                            </label>
                        </div>
                        <?php foreach ($validCategories as $cat): ?>
                            <div class="form-check mb-2">
                                <input class="form-check-input" type="radio" name="category" id="cat_<?= $cat ?>" value="<?= $cat ?>" <?= ($categoryFilter === $cat) ? 'checked' : '' ?>>
                                <label class="form-check-label d-flex justify-content-between" for="cat_<?= $cat ?>">
                                    <span><?= $cat ?></span>
                                    <span class="badge bg-light text-muted rounded-pill"><?= $categoryCounts[$cat] ?? 0 ?></span>
                                </label>
                            </div>
                        <?php endforeach; ?>
                    </div>

                    <!-- Cooking Time Filters -->
                    <div class="mb-4">
                        <h6 class="fw-semibold text-secondary mb-2">Cooking Time</h6>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="radio" name="time" id="time_all" value="" <?= empty($timeFilter) ? 'checked' : '' ?>>
                            <label class="form-check-label" for="time_all">Any Time</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="radio" name="time" id="time_under30" value="under30" <?= ($timeFilter === 'under30') ? 'checked' : '' ?>>
                            <label class="form-check-label" for="time_under30">Under 30 mins</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="radio" name="time" id="time_30to60" value="30to60" <?= ($timeFilter === '30to60') ? 'checked' : '' ?>>
                            <label class="form-check-label" for="time_30to60">30 - 60 mins</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="radio" name="time" id="time_over60" value="over60" <?= ($timeFilter === 'over60') ? 'checked' : '' ?>>
                            <label class="form-check-label" for="time_over60">Over 60 mins</label>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary w-100">
                        <i class="bi bi-funnel me-1"></i> Apply Filters
                    </button>
                </div>
            </div>

            <!-- Recipe Grid Column (Matches Wireframe 7.2) -->
            <div class="col-lg-9">
                <?php if (!empty($recipes)): ?>
                    <div class="row g-4">
                        <?php foreach ($recipes as $recipe): ?>
                            <div class="col-md-6 col-xl-4">
                                <div class="card h-100 recipe-card">
                                    <div class="recipe-card-img-wrapper">
                                        <img src="<?= htmlspecialchars(getRecipeImageUrl($recipe['image_url'], $recipe['category'], $recipe['id'])) ?>" 
                                             class="recipe-card-img" 
                                             alt="<?= htmlspecialchars($recipe['title']) ?>"
                                             loading="lazy">
                                        <span class="badge badge-cat <?= getCategoryBadgeClass($recipe['category']) ?>">
                                            <i class="bi <?= getCategoryIcon($recipe['category']) ?> me-1"></i>
                                            <?= htmlspecialchars($recipe['category']) ?>
                                        </span>
                                        <span class="badge-time">
                                            <i class="bi bi-clock me-1"></i><?= intval($recipe['cooking_time']) ?> mins
                                        </span>
                                    </div>
                                    
                                    <div class="card-body d-flex flex-column">
                                        <div class="d-flex align-items-center gap-1 mb-1 text-primary small fw-semibold">
                                            <i class="bi bi-geo-alt-fill text-danger"></i>
                                            <span><?= htmlspecialchars(formatOrigin($recipe['origin'] ?? 'Authentic Regional')) ?></span>
                                        </div>

                                        <h5 class="card-title fw-bold mb-2">
                                            <a href="recipe-detail.php?id=<?= $recipe['id'] ?>" class="text-decoration-none text-dark">
                                                <?= htmlspecialchars($recipe['title']) ?>
                                            </a>
                                        </h5>
                                        
                                        <div class="mb-2">
                                            <?= renderStarRating($recipe['avg_rating'], $recipe['rating_count']) ?>
                                        </div>
                                        
                                        <p class="card-text text-muted small flex-grow-1">
                                            <?= htmlspecialchars(mb_strimwidth(str_replace("\n", ", ", $recipe['ingredients']), 0, 75, '...')) ?>
                                        </p>
                                        
                                        <div class="mt-auto pt-2 border-top d-flex align-items-center justify-content-between">
                                            <button type="button" 
                                                    class="btn btn-sm btn-outline-secondary rounded-pill px-2 d-inline-flex align-items-center gap-1"
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#quickViewModal"
                                                    data-title="<?= htmlspecialchars($recipe['title']) ?>"
                                                    data-category="<?= htmlspecialchars($recipe['category']) ?>"
                                                    data-origin="<?= htmlspecialchars(formatOrigin($recipe['origin'])) ?>"
                                                    data-time="<?= intval($recipe['cooking_time']) ?>"
                                                    data-image="<?= htmlspecialchars(getRecipeImageUrl($recipe['image_url'], $recipe['category'], $recipe['id'])) ?>"
                                                    data-ingredients="<?= htmlspecialchars($recipe['ingredients']) ?>"
                                                    data-url="recipe-detail.php?id=<?= $recipe['id'] ?>">
                                                <i class="bi bi-eye"></i> Quick View
                                            </button>
                                            <a href="recipe-detail.php?id=<?= $recipe['id'] ?>" class="btn btn-primary btn-sm px-3 rounded-pill">
                                                View Recipe
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        <?php endforeach; ?>
                    </div>

                    <!-- Pagination (Matches Wireframe 7.2) -->
                    <?php if ($totalPages > 1): ?>
                        <?php
                            // Build base query string without 'page' parameter
                            $queryParams = $_GET;
                            unset($queryParams['page']);
                            $baseQueryString = http_build_query($queryParams);
                            $linkPrefix = 'recipes.php?' . ($baseQueryString ? $baseQueryString . '&' : '') . 'page=';
                        ?>
                        <nav aria-label="Recipe pagination" class="mt-5">
                            <ul class="pagination justify-content-center">
                                <!-- Previous Button -->
                                <li class="page-item <?= ($page <= 1) ? 'disabled' : '' ?>">
                                    <a class="page-link" href="<?= $linkPrefix . ($page - 1) ?>" aria-label="Previous">
                                        <span aria-hidden="true">&laquo; Prev</span>
                                    </a>
                                </li>

                                <!-- Page Numbers -->
                                <?php for ($p = 1; $p <= $totalPages; $p++): ?>
                                    <li class="page-item <?= ($p === $page) ? 'active' : '' ?>">
                                        <a class="page-link" href="<?= $linkPrefix . $p ?>"><?= $p ?></a>
                                    </li>
                                <?php endfor; ?>

                                <!-- Next Button -->
                                <li class="page-item <?= ($page >= $totalPages) ? 'disabled' : '' ?>">
                                    <a class="page-link" href="<?= $linkPrefix . ($page + 1) ?>" aria-label="Next">
                                        <span aria-hidden="true">Next &raquo;</span>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    <?php endif; ?>

                <?php else: ?>
                    <div class="card p-5 text-center border-0 shadow-sm rounded-4">
                        <div class="mb-3 text-muted">
                            <i class="bi bi-emoji-neutral fs-1"></i>
                        </div>
                        <h4 class="fw-bold">No Recipes Found</h4>
                        <p class="text-muted">No recipes matched your search criteria. Try different keywords or reset your filters.</p>
                        <div>
                            <a href="recipes.php" class="btn btn-outline-primary">
                                <i class="bi bi-arrow-counterclockwise me-1"></i> Reset All Filters
                            </a>
                        </div>
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </form>
</div>

<?php require_once __DIR__ . '/includes/footer.php'; ?>
