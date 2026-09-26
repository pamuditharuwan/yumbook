<?php
// ==============================================================================
// YumBook - Home Page (index.php)
// ICT 1209: Web Technologies Mini-Project
// Wireframe: 7.1 Home Page
// ==============================================================================

$pageTitle = 'YumBook - Discover & Share Delicious Recipes';
require_once __DIR__ . '/includes/header.php';

// Fetch Featured Recipes (Top rated recipes with at least 1 rating, or latest recipes)
$featuredStmt = $pdo->query("
    SELECT r.*, 
           COALESCE(AVG(rt.rating), 0) AS avg_rating,
           COUNT(rt.id) AS rating_count,
           u.name AS author_name
    FROM recipes r
    LEFT JOIN ratings rt ON r.id = rt.recipe_id
    LEFT JOIN users u ON r.user_id = u.id
    GROUP BY r.id
    ORDER BY avg_rating DESC, rating_count DESC, r.id ASC
    LIMIT 6
");
$featuredRecipes = $featuredStmt->fetchAll();

// Fetch Category Counts for quick display
$categoryCountsStmt = $pdo->query("
    SELECT category, COUNT(*) as count 
    FROM recipes 
    GROUP BY category
");
$categoryCounts = $categoryCountsStmt->fetchAll(PDO::FETCH_KEY_PAIR);
?>

<div class="container">
    <!-- Hero Section (Matches Wireframe 7.1) -->
    <div class="hero-section mb-5 shadow-sm">
        <div class="row align-items-center gy-4">
            <div class="col-lg-6 order-2 order-lg-1">
                <span class="badge bg-warning text-dark px-3 py-2 rounded-pill mb-2 fw-semibold">
                    <i class="bi bi-fire me-1"></i> Digital Recipe Book
                </span>
                <h1 class="display-5 hero-title mb-3">Discover &amp; Share Great Recipes</h1>
                <p class="lead text-muted mb-4">
                    Explore delicious homemade meals, authentic Sri Lankan dishes, and global favorites. Find your next cooking inspiration!
                </p>
                
                <!-- Search Box inside Hero -->
                <form action="recipes.php" method="GET" class="mb-4">
                    <div class="input-group input-group-lg shadow-sm">
                        <span class="input-group-text bg-white border-end-0 text-muted">
                            <i class="bi bi-search"></i>
                        </span>
                        <input type="text" name="q" class="form-control border-start-0" placeholder="Search recipes (e.g. chicken curry, waffles)..." aria-label="Search recipes">
                        <button class="btn btn-primary px-4 fw-semibold" type="submit">Search</button>
                    </div>
                </form>
                
                <!-- Category Chips (Matches Wireframe 7.1) -->
                <div class="d-flex flex-wrap gap-2 align-items-center">
                    <span class="small fw-bold text-secondary me-1">Popular:</span>
                    <a href="recipes.php?category=Breakfast" class="category-chip">Breakfast</a>
                    <a href="recipes.php?category=Lunch" class="category-chip">Lunch</a>
                    <a href="recipes.php?category=Dinner" class="category-chip">Dinner</a>
                    <a href="recipes.php?category=Dessert" class="category-chip">Dessert</a>
                    <a href="recipes.php?category=Vegan" class="category-chip">Vegan</a>
                    <a href="recipes.php?category=Beverages" class="category-chip">Beverages</a>
                </div>
            </div>
            
            <div class="col-lg-6 order-1 order-lg-2">
                <!-- Bootstrap 5 Carousel: Featured Recipe Showcase -->
                <div id="heroRecipeCarousel" class="carousel slide carousel-fade rounded-4 overflow-hidden shadow-sm" data-bs-ride="carousel">
                    <div class="carousel-indicators">
                        <button type="button" data-bs-target="#heroRecipeCarousel" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
                        <button type="button" data-bs-target="#heroRecipeCarousel" data-bs-slide-to="1" aria-label="Slide 2"></button>
                        <button type="button" data-bs-target="#heroRecipeCarousel" data-bs-slide-to="2" aria-label="Slide 3"></button>
                    </div>
                    <div class="carousel-inner" style="height: 380px;">
                        <div class="carousel-item active h-100" data-bs-interval="4500">
                            <img src="assets/images/recipes/lamprais.jpg" class="d-block w-100 h-100 object-fit-cover" alt="Sri Lankan Lamprais">
                            <div class="carousel-caption text-start p-4 rounded-3" style="background: linear-gradient(180deg, transparent 0%, rgba(0,0,0,0.85) 100%); bottom: 0; left: 0; right: 0;">
                                <span class="badge bg-warning text-dark mb-1">Featured Dish</span>
                                <h5 class="fw-bold mb-1 text-white">Traditional Sri Lankan Lamprais</h5>
                                <p class="small text-white-50 mb-0 d-none d-sm-block">Slow-cooked rice, mixed meat curry & sambols wrapped in banana leaf.</p>
                            </div>
                        </div>
                        <div class="carousel-item h-100" data-bs-interval="4500">
                            <img src="https://images.unsplash.com/photo-1528207776546-365bb710ee93?auto=format&fit=crop&w=1000&q=80" class="d-block w-100 h-100 object-fit-cover" alt="Blueberry Pancakes">
                            <div class="carousel-caption text-start p-4 rounded-3" style="background: linear-gradient(180deg, transparent 0%, rgba(0,0,0,0.85) 100%); bottom: 0; left: 0; right: 0;">
                                <span class="badge bg-primary mb-1">Top Breakfast</span>
                                <h5 class="fw-bold mb-1 text-white">Fluffy Blueberry Buttermilk Pancakes</h5>
                                <p class="small text-white-50 mb-0 d-none d-sm-block">Cloud-soft pancakes served with wild berries & warm maple syrup.</p>
                            </div>
                        </div>
                        <div class="carousel-item h-100" data-bs-interval="4500">
                            <img src="https://images.unsplash.com/photo-1467003909585-2f8a72700288?auto=format&fit=crop&w=1000&q=80" class="d-block w-100 h-100 object-fit-cover" alt="Pan-Seared Salmon">
                            <div class="carousel-caption text-start p-4 rounded-3" style="background: linear-gradient(180deg, transparent 0%, rgba(0,0,0,0.85) 100%); bottom: 0; left: 0; right: 0;">
                                <span class="badge bg-danger mb-1">Chef's Special</span>
                                <h5 class="fw-bold mb-1 text-white">Crispy-Skin Pan-Seared Salmon</h5>
                                <p class="small text-white-50 mb-0 d-none d-sm-block">Tender Atlantic salmon with butter-glazed asparagus spears.</p>
                            </div>
                        </div>
                    </div>
                    <button class="carousel-control-prev" type="button" data-bs-target="#heroRecipeCarousel" data-bs-slide="prev">
                        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                        <span class="visually-hidden">Previous</span>
                    </button>
                    <button class="carousel-control-next" type="button" data-bs-target="#heroRecipeCarousel" data-bs-slide="next">
                        <span class="carousel-control-next-icon" aria-hidden="true"></span>
                        <span class="visually-hidden">Next</span>
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Featured Recipes Section (Matches Wireframe 7.1) -->
    <div class="mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="h3 fw-bold mb-1">Featured Recipes</h2>
                <p class="text-muted mb-0">Handpicked top-rated recipes from our community</p>
            </div>
            <a href="recipes.php" class="btn btn-outline-primary btn-sm">
                View All Recipes <i class="bi bi-arrow-right ms-1"></i>
            </a>
        </div>

        <div class="row g-4">
            <?php if (!empty($featuredRecipes)): ?>
                <?php foreach ($featuredRecipes as $recipe): ?>
                    <div class="col-md-6 col-lg-4">
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
                                <h5 class="card-title fw-bold mb-2">
                                    <a href="recipe-detail.php?id=<?= $recipe['id'] ?>" class="text-decoration-none text-dark">
                                        <?= htmlspecialchars($recipe['title']) ?>
                                    </a>
                                </h5>
                                
                                <div class="mb-3">
                                    <?= renderStarRating($recipe['avg_rating'], $recipe['rating_count']) ?>
                                </div>
                                
                                <p class="card-text text-muted small flex-grow-1">
                                    <?= htmlspecialchars(mb_strimwidth(str_replace("\n", ", ", $recipe['ingredients']), 0, 90, '...')) ?>
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
            <?php else: ?>
                <div class="col-12">
                    <div class="alert alert-info text-center py-4">
                        No recipes found. Please import <code>sql/database.sql</code> into your database.
                    </div>
                </div>
            <?php endif; ?>
        </div>
    </div>

    <!-- How YumBook Works (Matches Wireframe 7.1) -->
    <div class="card bg-white border-0 shadow-sm rounded-4 p-4 p-md-5 mb-5">
        <div class="text-center mb-5">
            <span class="badge bg-light text-primary px-3 py-2 rounded-pill fw-semibold mb-2">Simple &amp; Easy</span>
            <h2 class="fw-bold">How YumBook Works</h2>
            <p class="text-muted">A shared, categorized recipe space built for home cooks and students</p>
        </div>

        <div class="row g-4 text-center">
            <div class="col-md-4">
                <div class="p-3">
                    <div class="d-inline-flex align-items-center justify-content-center bg-warning bg-opacity-10 text-warning rounded-circle p-3 mb-3" style="width: 70px; height: 70px;">
                        <i class="bi bi-person-plus-fill fs-2 text-primary"></i>
                    </div>
                    <h5 class="fw-bold">1. Create an Account</h5>
                    <p class="text-muted small">
                        Sign up quickly in seconds to join the community and start creating your personal culinary collection.
                    </p>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="p-3">
                    <div class="d-inline-flex align-items-center justify-content-center bg-primary bg-opacity-10 text-primary rounded-circle p-3 mb-3" style="width: 70px; height: 70px;">
                        <i class="bi bi-search fs-2"></i>
                    </div>
                    <h5 class="fw-bold">2. Browse or Submit Recipes</h5>
                    <p class="text-muted small">
                        Search delicious dishes by category or cooking time, or publish your own family recipes with steps and ingredients.
                    </p>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="p-3">
                    <div class="d-inline-flex align-items-center justify-content-center bg-success bg-opacity-10 text-success rounded-circle p-3 mb-3" style="width: 70px; height: 70px;">
                        <i class="bi bi-star-fill fs-2"></i>
                    </div>
                    <h5 class="fw-bold">3. Rate &amp; Share Feedback</h5>
                    <p class="text-muted small">
                        Rate tested recipes 1 to 5 stars, review cooking times, and help fellow students discover great meals.
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<?php require_once __DIR__ . '/includes/footer.php'; ?>
