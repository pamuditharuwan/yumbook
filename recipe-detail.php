<?php
// ==============================================================================
// YumBook - Recipe Detail Page (recipe-detail.php)
// ICT 1209: Web Technologies Mini-Project
// ==============================================================================

require_once __DIR__ . '/includes/db.php';
require_once __DIR__ . '/includes/functions.php';

$recipeId = intval($_GET['id'] ?? 0);

if ($recipeId <= 0) {
    setFlashMessage('danger', 'Invalid recipe requested.');
    header('Location: recipes.php');
    exit;
}

// -----------------------------------------------------------------------------
// Handle Star Rating Submission (POST)
// -----------------------------------------------------------------------------
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['submit_rating'])) {
    $ratingVal = intval($_POST['rating'] ?? 0);
    $userIp = $_SERVER['REMOTE_ADDR'] ?? '127.0.0.1';
    $userId = getCurrentUserId();
    $raterIdentifier = $userId ? "user_{$userId}" : "ip_{$userIp}";

    if ($ratingVal >= 1 && $ratingVal <= 5) {
        // Check if user/IP already rated this recipe
        $checkStmt = $pdo->prepare("SELECT id FROM ratings WHERE recipe_id = :recipe_id AND user_ip_or_id = :identifier");
        $checkStmt->execute([
            'recipe_id'  => $recipeId,
            'identifier' => $raterIdentifier
        ]);
        $existing = $checkStmt->fetch();

        if ($existing) {
            // Update rating
            $updateStmt = $pdo->prepare("UPDATE ratings SET rating = :rating, created_at = NOW() WHERE id = :id");
            $updateStmt->execute([
                'rating' => $ratingVal,
                'id'     => $existing['id']
            ]);
            setFlashMessage('success', "Your rating has been updated to <strong>{$ratingVal} stars</strong>! Thank you.");
        } else {
            // Insert new rating
            $insertStmt = $pdo->prepare("INSERT INTO ratings (recipe_id, user_ip_or_id, rating) VALUES (:recipe_id, :identifier, :rating)");
            $insertStmt->execute([
                'recipe_id'  => $recipeId,
                'identifier' => $raterIdentifier,
                'rating'     => $ratingVal
            ]);
            setFlashMessage('success', "Thank you! You gave this recipe <strong>{$ratingVal} stars</strong>.");
        }

        header("Location: recipe-detail.php?id={$recipeId}#ratingSection");
        exit;
    } else {
        setFlashMessage('warning', 'Please select a valid rating between 1 and 5 stars.');
    }
}

// -----------------------------------------------------------------------------
// Fetch Recipe Details with Average Rating
// -----------------------------------------------------------------------------
$stmt = $pdo->prepare("
    SELECT r.*, 
           COALESCE(AVG(rt.rating), 0) AS avg_rating,
           COUNT(rt.id) AS rating_count,
           u.name AS author_name
    FROM recipes r
    LEFT JOIN ratings rt ON r.id = rt.recipe_id
    LEFT JOIN users u ON r.user_id = u.id
    WHERE r.id = :id
    GROUP BY r.id
");
$stmt->execute(['id' => $recipeId]);
$recipe = $stmt->fetch();

if (!$recipe) {
    setFlashMessage('danger', 'The requested recipe could not be found.');
    header('Location: recipes.php');
    exit;
}

$pageTitle = htmlspecialchars($recipe['title']) . ' - YumBook';
require_once __DIR__ . '/includes/header.php';

// Format ingredients into an array of clean lines
$ingredientsList = array_filter(array_map('trim', explode("\n", $recipe['ingredients'])));

// Format preparation steps into an array of clean steps
$stepsList = array_filter(array_map('trim', explode("\n", $recipe['steps'])));

// Fetch Related Recipes in the same category
$relatedStmt = $pdo->prepare("
    SELECT r.*, 
           COALESCE(AVG(rt.rating), 0) AS avg_rating,
           COUNT(rt.id) AS rating_count
    FROM recipes r
    LEFT JOIN ratings rt ON r.id = rt.recipe_id
    WHERE r.category = :category AND r.id != :current_id
    GROUP BY r.id
    ORDER BY avg_rating DESC
    LIMIT 3
");
$relatedStmt->execute([
    'category'   => $recipe['category'],
    'current_id' => $recipeId
]);
$relatedRecipes = $relatedStmt->fetchAll();
?>

<div class="container py-2">
    <!-- Breadcrumb Navigation -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="index.php" class="text-decoration-none">Home</a></li>
            <li class="breadcrumb-item"><a href="recipes.php" class="text-decoration-none">Recipes</a></li>
            <li class="breadcrumb-item"><a href="recipes.php?category=<?= urlencode($recipe['category']) ?>" class="text-decoration-none"><?= htmlspecialchars($recipe['category']) ?></a></li>
            <li class="breadcrumb-item active" aria-current="page"><?= htmlspecialchars($recipe['title']) ?></li>
        </ol>
    </nav>

    <!-- Recipe Header Card -->
    <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
        <div class="row g-0">
            <div class="col-lg-6">
                <img src="<?= htmlspecialchars(getRecipeImageUrl($recipe['image_url'], $recipe['category'], $recipe['id'])) ?>" 
                     alt="<?= htmlspecialchars($recipe['title']) ?>" 
                     class="img-fluid h-100 w-100" 
                     style="min-height: 340px; max-height: 420px; object-fit: cover;">
            </div>
            <div class="col-lg-6 p-4 p-md-5 d-flex flex-column justify-content-center">
                <div class="d-flex flex-wrap gap-2 mb-3">
                    <span class="badge <?= getCategoryBadgeClass($recipe['category']) ?> fs-6 px-3 py-2 rounded-pill">
                        <i class="bi <?= getCategoryIcon($recipe['category']) ?> me-1"></i>
                        <?= htmlspecialchars($recipe['category']) ?>
                    </span>
                    <span class="badge bg-primary text-white fs-6 px-3 py-2 rounded-pill" style="background: linear-gradient(135deg, #0284c7 0%, #0369a1 100%) !important;">
                        <i class="bi bi-geo-alt-fill me-1"></i> <?= htmlspecialchars(formatOrigin($recipe['origin'] ?? 'Global')) ?>
                    </span>
                    <span class="badge bg-dark text-white fs-6 px-3 py-2 rounded-pill">
                        <i class="bi bi-clock me-1"></i> <?= intval($recipe['cooking_time']) ?> minutes
                    </span>
                </div>

                <h1 class="h2 fw-bold text-dark mb-3"><?= htmlspecialchars($recipe['title']) ?></h1>

                <div class="mb-3 d-flex align-items-center gap-2">
                    <?= renderStarRating($recipe['avg_rating'], $recipe['rating_count']) ?>
                </div>

                <div class="text-muted small border-top pt-3 mt-2">
                    <div class="row g-2">
                        <div class="col-sm-6">
                            <i class="bi bi-person-fill text-primary me-1"></i> Master Chef: 
                            <strong class="text-dark"><?= htmlspecialchars($recipe['author_name'] ?? 'YumBook Chef') ?></strong>
                        </div>
                        <div class="col-sm-6">
                            <i class="bi bi-globe-americas text-primary me-1"></i> Culinary Origin: 
                            <strong class="text-dark"><?= htmlspecialchars(formatOrigin($recipe['origin'] ?? 'Authentic Regional')) ?></strong>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <!-- Ingredients Column -->
        <div class="col-lg-5">
            <div class="card border-0 shadow-sm rounded-4 p-4 mb-4 sticky-top" style="top: 80px; z-index: 10;">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h3 class="h4 fw-bold mb-0">
                        <i class="bi bi-basket-fill text-warning me-2"></i>Ingredients
                    </h3>
                    <span class="badge bg-light text-muted border"><?= count($ingredientsList) ?> items</span>
                </div>
                <p class="text-muted small mb-3">Check off ingredients as you prepare them:</p>

                <ul class="list-unstyled ingredient-list mb-0">
                    <?php foreach ($ingredientsList as $idx => $ing): ?>
                        <li class="ingredient-checkbox-item d-flex align-items-start gap-2">
                            <input class="form-check-input mt-1 flex-shrink-0" type="checkbox" id="ing_<?= $idx ?>">
                            <label class="form-check-label flex-grow-1 cursor-pointer" for="ing_<?= $idx ?>">
                                <?= htmlspecialchars(ltrim($ing, "-*• ")) ?>
                            </label>
                        </li>
                    <?php endforeach; ?>
                </ul>
            </div>
        </div>

        <!-- Preparation Steps Column -->
        <div class="col-lg-7">
            <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 mb-4">
                <h3 class="h4 fw-bold mb-4">
                    <i class="bi bi-list-ol text-primary me-2"></i>Preparation Steps
                </h3>

                <div class="d-flex flex-column gap-4">
                    <?php 
                    $stepNum = 1;
                    foreach ($stepsList as $step): 
                        // Strip leading "1.", "Step 1:", etc. for clean uniform layout
                        $cleanStep = preg_replace('/^(step\s*\d+[:.]?|\d+[\.)])\s*/i', '', $step);
                        $parts = explode(' - ', $cleanStep, 2);
                    ?>
                        <div class="p-3 step-card shadow-sm">
                            <div class="d-flex align-items-start gap-3">
                                <span class="step-number flex-shrink-0"><?= $stepNum ?></span>
                                <div class="step-text pt-1 flex-grow-1">
                                    <?php if (count($parts) === 2 && strlen($parts[0]) < 65): ?>
                                        <h6 class="fw-bold text-dark mb-1 fs-6"><?= htmlspecialchars(trim($parts[0])) ?></h6>
                                        <p class="mb-0 text-secondary" style="line-height: 1.65;"><?= nl2br(htmlspecialchars(trim($parts[1]))) ?></p>
                                    <?php else: ?>
                                        <p class="mb-0 text-secondary" style="line-height: 1.65;"><?= nl2br(htmlspecialchars($cleanStep)) ?></p>
                                    <?php endif; ?>
                                </div>
                            </div>
                        </div>
                    <?php 
                        $stepNum++;
                    endforeach; 
                    ?>
                </div>
            </div>

            <!-- Simple Star Rating System (Matches Proposal Requirement) -->
            <div class="card border-0 shadow-sm rounded-4 p-4 mb-4" id="ratingSection">
                <h4 class="fw-bold mb-2">
                    <i class="bi bi-star-half text-warning me-2"></i>Rate this Recipe
                </h4>
                <p class="text-muted small mb-3">
                    Tried this dish? Give it a score from 1 to 5 stars to help other students!
                </p>

                <form action="recipe-detail.php?id=<?= $recipe['id'] ?>" method="POST">
                    <div class="rating-widget mb-3 d-flex align-items-center gap-2" id="ratingWidget">
                        <i class="bi bi-star star-btn" data-value="1" title="1 Star - Poor"></i>
                        <i class="bi bi-star star-btn" data-value="2" title="2 Stars - Fair"></i>
                        <i class="bi bi-star star-btn" data-value="3" title="3 Stars - Good"></i>
                        <i class="bi bi-star star-btn" data-value="4" title="4 Stars - Very Good"></i>
                        <i class="bi bi-star star-btn" data-value="5" title="5 Stars - Excellent"></i>
                        <input type="hidden" name="rating" id="selectedRating" value="5">
                    </div>
                    
                    <div id="ratingDescription" class="small text-muted fw-semibold mb-3">
                        5 - Excellent &amp; Delicious!
                    </div>

                    <button type="submit" name="submit_rating" class="btn btn-primary btn-sm px-4">
                        <i class="bi bi-check2-circle me-1"></i> Submit Rating
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- Related Recipes Section -->
    <?php if (!empty($relatedRecipes)): ?>
        <div class="mt-5">
            <h3 class="h4 fw-bold mb-4">More <?= htmlspecialchars($recipe['category']) ?> Recipes</h3>
            <div class="row g-4">
                <?php foreach ($relatedRecipes as $rel): ?>
                    <div class="col-md-4">
                        <div class="card h-100 recipe-card">
                            <div class="recipe-card-img-wrapper">
                                <img src="<?= htmlspecialchars(getRecipeImageUrl($rel['image_url'], $rel['category'], $rel['id'])) ?>" 
                                     class="recipe-card-img" 
                                     alt="<?= htmlspecialchars($rel['title']) ?>"
                                     loading="lazy">
                                <span class="badge badge-cat <?= getCategoryBadgeClass($rel['category']) ?>">
                                    <?= htmlspecialchars($rel['category']) ?>
                                </span>
                                <span class="badge-time">
                                    <i class="bi bi-clock me-1"></i><?= intval($rel['cooking_time']) ?> mins
                                </span>
                            </div>
                            <div class="card-body d-flex flex-column">
                                <h6 class="card-title fw-bold mb-2">
                                    <a href="recipe-detail.php?id=<?= $rel['id'] ?>" class="text-decoration-none text-dark">
                                        <?= htmlspecialchars($rel['title']) ?>
                                    </a>
                                </h6>
                                <div class="mb-3">
                                    <?= renderStarRating($rel['avg_rating'], $rel['rating_count']) ?>
                                </div>
                                <div class="mt-auto">
                                    <a href="recipe-detail.php?id=<?= $rel['id'] ?>" class="btn btn-outline-primary btn-sm w-100">
                                        View Recipe
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                <?php endforeach; ?>
            </div>
        </div>
    <?php endif; ?>
</div>

<?php require_once __DIR__ . '/includes/footer.php'; ?>
