<?php
// ==============================================================================
// YumBook - User Dashboard (dashboard.php)
// ICT 1209: Web Technologies Mini-Project
// Section 7.4 Dashboard Wireframe & User Recipe Management
// ==============================================================================

require_once __DIR__ . '/includes/db.php';
require_once __DIR__ . '/includes/functions.php';

// Authentication check
if (!isLoggedIn()) {
    setFlashMessage('warning', 'Please log in to access your user dashboard.');
    header('Location: auth/login.php');
    exit;
}

$userId = getCurrentUserId();
$errors = [];
$success = '';

// Fetch current user details
try {
    $userStmt = $pdo->prepare("SELECT id, username, name, email, created_at FROM users WHERE id = ?");
    $userStmt->execute([$userId]);
    $user = $userStmt->fetch();

    if (!$user) {
        // If user not found in DB, clear session and redirect to login
        session_destroy();
        header('Location: auth/login.php');
        exit;
    }
} catch (PDOException $e) {
    die("Database error: " . $e->getMessage());
}

// Handle New Recipe Submission
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'add_recipe') {
    $title        = trim($_POST['title'] ?? '');
    $category     = trim($_POST['category'] ?? '');
    $origin       = trim($_POST['origin'] ?? 'Global');
    $cooking_time = intval($_POST['cooking_time'] ?? 0);
    $ingredients  = trim($_POST['ingredients'] ?? '');
    $steps        = trim($_POST['steps'] ?? '');
    $image_url    = trim($_POST['image_url'] ?? '');

    $allowedCategories = ['Breakfast', 'Lunch', 'Dinner', 'Dessert', 'Vegan', 'Beverages'];

    if (empty($title) || strlen($title) < 3) {
        $errors[] = 'Recipe title must be at least 3 characters long.';
    }

    if (!in_array($category, $allowedCategories)) {
        $errors[] = 'Please select a valid recipe category.';
    }

    if ($cooking_time <= 0) {
        $errors[] = 'Please enter a valid cooking time in minutes.';
    }

    if (empty($ingredients)) {
        $errors[] = 'Please list the recipe ingredients.';
    }

    if (empty($steps)) {
        $errors[] = 'Please provide the preparation steps.';
    }

    if (empty($errors)) {
        try {
            $insertRecipe = $pdo->prepare("
                INSERT INTO recipes (user_id, title, category, origin, cooking_time, ingredients, steps, instructions, image_url) 
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            ");
            $insertRecipe->execute([
                $userId,
                $title,
                $category,
                $origin ?: 'Global',
                $cooking_time,
                $ingredients,
                $steps,
                $steps, // instructions synced with steps
                $image_url ?: null
            ]);

            setFlashMessage('success', "Recipe '<strong>" . htmlspecialchars($title) . "</strong>' was successfully published!");
            header('Location: dashboard.php');
            exit;
        } catch (PDOException $e) {
            $errors[] = 'Failed to publish recipe: ' . $e->getMessage();
        }
    }
}

// Fetch recipes created by this user
try {
    $recipesStmt = $pdo->prepare("
        SELECT r.*, 
               COALESCE(AVG(ra.rating), 5.0) as avg_rating, 
               COUNT(ra.id) as rating_count
        FROM recipes r
        LEFT JOIN ratings ra ON r.id = ra.recipe_id
        WHERE r.user_id = ?
        GROUP BY r.id
        ORDER BY r.id DESC
    ");
    $recipesStmt->execute([$userId]);
    $myRecipes = $recipesStmt->fetchAll();
} catch (PDOException $e) {
    $myRecipes = [];
}

$pageTitle = 'My Dashboard - YumBook';
require_once __DIR__ . '/includes/header.php';
?>

<div class="container py-4">
    <!-- User Profile Header Banner -->
    <div class="card border-0 shadow-sm rounded-4 bg-primary text-white mb-4 overflow-hidden">
        <div class="card-body p-4 p-md-5 position-relative">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <div class="d-flex align-items-center gap-3 mb-2">
                        <div class="rounded-circle bg-white text-primary d-flex align-items-center justify-content-center shadow" style="width: 64px; height: 64px; font-size: 1.8rem; font-weight: 700;">
                            <?= strtoupper(substr($user['name'], 0, 1)) ?>
                        </div>
                        <div>
                            <h1 class="h2 fw-bold mb-0 text-white"><?= htmlspecialchars($user['name']) ?></h1>
                            <div class="opacity-75 small">
                                <span class="badge bg-white text-primary me-2">@<?= htmlspecialchars($user['username']) ?></span>
                                <span><i class="bi bi-envelope me-1"></i><?= htmlspecialchars($user['email']) ?></span>
                            </div>
                        </div>
                    </div>
                    <p class="mb-0 mt-3 text-white-50">
                        Welcome to your creator dashboard. Here you can submit authentic homemade recipes, monitor feedback, and manage your culinary creations.
                    </p>
                </div>
                <div class="col-md-4 mt-3 mt-md-0 text-md-end">
                    <a href="#newRecipeCard" class="btn btn-light btn-lg rounded-pill fw-semibold shadow-sm text-primary">
                        <i class="bi bi-plus-circle me-1"></i> Add New Recipe
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Stats Cards -->
    <div class="row g-3 mb-4">
        <div class="col-sm-6 col-lg-3">
            <div class="card border-0 shadow-sm rounded-4 h-100">
                <div class="card-body d-flex align-items-center p-3">
                    <div class="rounded-circle bg-primary-subtle text-primary p-3 me-3">
                        <i class="bi bi-journal-bookmark-fill fs-3"></i>
                    </div>
                    <div>
                        <div class="text-muted small">My Recipes</div>
                        <div class="fs-4 fw-bold"><?= count($myRecipes) ?></div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-lg-3">
            <div class="card border-0 shadow-sm rounded-4 h-100">
                <div class="card-body d-flex align-items-center p-3">
                    <div class="rounded-circle bg-success-subtle text-success p-3 me-3">
                        <i class="bi bi-star-fill fs-3"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Account Status</div>
                        <div class="fs-5 fw-bold text-success">Verified Cook</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-lg-3">
            <div class="card border-0 shadow-sm rounded-4 h-100">
                <div class="card-body d-flex align-items-center p-3">
                    <div class="rounded-circle bg-warning-subtle text-warning p-3 me-3">
                        <i class="bi bi-calendar-check fs-3"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Member Since</div>
                        <div class="fs-6 fw-bold"><?= date('M Y', strtotime($user['created_at'])) ?></div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-lg-3">
            <div class="card border-0 shadow-sm rounded-4 h-100">
                <div class="card-body d-flex align-items-center p-3">
                    <div class="rounded-circle bg-info-subtle text-info p-3 me-3">
                        <i class="bi bi-globe-americas fs-3"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Community Recipes</div>
                        <div class="fs-4 fw-bold">100+</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <?php if (!empty($errors)): ?>
        <div class="alert alert-danger alert-dismissible fade show rounded-3 shadow-sm mb-4" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>
            <strong>Please resolve the following issues:</strong>
            <ul class="mb-0 mt-2 ps-3 small">
                <?php foreach ($errors as $err): ?>
                    <li><?= htmlspecialchars($err) ?></li>
                <?php endforeach; ?>
            </ul>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <?php endif; ?>

    <div class="row g-4">
        <!-- Add New Recipe Form -->
        <div class="col-lg-6" id="newRecipeCard">
            <div class="card border-0 shadow-sm rounded-4 h-100">
                <div class="card-header bg-white border-bottom p-4">
                    <div class="d-flex align-items-center gap-2">
                        <i class="bi bi-pencil-square text-primary fs-4"></i>
                        <h2 class="h5 fw-bold mb-0">Share a New Recipe</h2>
                    </div>
                    <p class="text-muted small mb-0 mt-1">Submit your dish to the YumBook recipe collection.</p>
                </div>
                <div class="card-body p-4">
                    <form action="dashboard.php" method="POST" class="needs-validation" novalidate id="addRecipeForm">
                        <input type="hidden" name="action" value="add_recipe">

                        <div class="mb-3">
                            <label for="title" class="form-label fw-semibold small">Recipe Title <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="title" name="title" placeholder="e.g. Traditional Sri Lankan Kothu Roti" required minlength="3">
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label for="category" class="form-label fw-semibold small">Category <span class="text-danger">*</span></label>
                                <select class="form-select" id="category" name="category" required>
                                    <option value="" selected disabled>Select category...</option>
                                    <option value="Breakfast">Breakfast</option>
                                    <option value="Lunch">Lunch</option>
                                    <option value="Dinner">Dinner</option>
                                    <option value="Dessert">Dessert</option>
                                    <option value="Vegan">Vegan</option>
                                    <option value="Beverages">Beverages</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="cooking_time" class="form-label fw-semibold small">Cooking Time (minutes) <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" id="cooking_time" name="cooking_time" placeholder="e.g. 35" min="1" max="1440" required>
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label for="origin" class="form-label fw-semibold small">Country / Origin</label>
                                <input type="text" class="form-control" id="origin" name="origin" placeholder="e.g. Sri Lanka, Italy, Mexico">
                            </div>
                            <div class="col-md-6">
                                <label for="image_url" class="form-label fw-semibold small">Image URL (Optional)</label>
                                <input type="url" class="form-control" id="image_url" name="image_url" placeholder="https://example.com/photo.jpg">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="ingredients" class="form-label fw-semibold small">Ingredients <span class="text-danger">*</span></label>
                            <textarea class="form-control font-monospace small" id="ingredients" name="ingredients" rows="5" placeholder="Enter each ingredient on a new line:&#10;2 cups basmati rice&#10;1 tsp turmeric powder&#10;400ml coconut milk" required></textarea>
                            <div class="form-text small">Enter each ingredient on its own separate line.</div>
                        </div>

                        <div class="mb-4">
                            <label for="steps" class="form-label fw-semibold small">Preparation Steps / Instructions <span class="text-danger">*</span></label>
                            <textarea class="form-control small" id="steps" name="steps" rows="6" placeholder="Step 1: Wash and rinse rice until water runs clear...&#10;Step 2: Heat ghee in a deep clay pot over medium flame...&#10;Step 3: Simmer gently for 20 minutes until fluffy." required></textarea>
                            <div class="form-text small">Explain each step clearly with tips and timing cues.</div>
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary btn-lg rounded-pill fw-semibold shadow-sm">
                                <i class="bi bi-cloud-arrow-up me-2"></i> Publish Recipe
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- My Recipes List -->
        <div class="col-lg-6">
            <div class="card border-0 shadow-sm rounded-4 h-100">
                <div class="card-header bg-white border-bottom p-4 d-flex align-items-center justify-content-between">
                    <div>
                        <h2 class="h5 fw-bold mb-0">My Submitted Recipes</h2>
                        <p class="text-muted small mb-0 mt-1">Dishes published under your account.</p>
                    </div>
                    <span class="badge bg-primary rounded-pill px-3 py-2"><?= count($myRecipes) ?> Published</span>
                </div>
                <div class="card-body p-4">
                    <?php if (empty($myRecipes)): ?>
                        <div class="text-center py-5">
                            <div class="bg-light rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 72px; height: 72px;">
                                <i class="bi bi-egg-fried text-muted fs-2"></i>
                            </div>
                            <h3 class="h6 fw-bold">No Recipes Published Yet</h3>
                            <p class="text-muted small mx-auto" style="max-width: 320px;">
                                You haven't added any recipes yet. Use the form on the left to submit your first delicious recipe!
                            </p>
                        </div>
                    <?php else: ?>
                        <div class="list-group list-group-flush gap-3">
                            <?php foreach ($myRecipes as $recipe): ?>
                                <div class="list-group-item p-3 border rounded-3 d-flex gap-3 align-items-center">
                                    <img src="<?= htmlspecialchars(getRecipeImageUrl($recipe['image_url'], $recipe['category'], $recipe['id'])) ?>" 
                                         alt="<?= htmlspecialchars($recipe['title']) ?>" 
                                         class="rounded-3 object-fit-cover shadow-sm flex-shrink-0" 
                                         style="width: 80px; height: 80px;">
                                    <div class="flex-grow-1 min-w-0">
                                        <div class="d-flex align-items-center gap-2 mb-1 flex-wrap">
                                            <span class="badge <?= getCategoryBadgeClass($recipe['category']) ?> rounded-pill small">
                                                <i class="bi <?= getCategoryIcon($recipe['category']) ?> me-1"></i><?= htmlspecialchars($recipe['category']) ?>
                                            </span>
                                            <span class="text-muted small">
                                                <i class="bi bi-clock me-1"></i><?= intval($recipe['cooking_time']) ?> mins
                                            </span>
                                            <span class="text-muted small">
                                                <i class="bi bi-geo-alt me-1"></i><?= htmlspecialchars(formatOrigin($recipe['origin'])) ?>
                                            </span>
                                        </div>
                                        <h4 class="h6 fw-bold text-truncate mb-1">
                                            <?= htmlspecialchars($recipe['title']) ?>
                                        </h4>
                                        <div class="small">
                                            <?= renderStarRating($recipe['avg_rating'], $recipe['rating_count']) ?>
                                        </div>
                                    </div>
                                    <div class="flex-shrink-0">
                                        <a href="recipe-detail.php?id=<?= $recipe['id'] ?>" class="btn btn-outline-primary btn-sm rounded-pill" title="View recipe">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                    </div>
                                </div>
                            <?php endforeach; ?>
                        </div>
                    <?php endif; ?>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// Client-side Bootstrap validation
(function () {
    'use strict';
    const form = document.getElementById('addRecipeForm');
    if (form) {
        form.addEventListener('submit', function (event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        }, false);
    }
})();
</script>

<?php require_once __DIR__ . '/includes/footer.php'; ?>
