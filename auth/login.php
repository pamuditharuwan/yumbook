<?php
// ==============================================================================
// YumBook - User Login (auth/login.php)
// ICT 1209: Web Technologies Mini-Project
// ==============================================================================

require_once __DIR__ . '/../includes/db.php';
require_once __DIR__ . '/../includes/functions.php';

// If already logged in, redirect to dashboard
if (isLoggedIn()) {
    header('Location: ../dashboard.php');
    exit;
}

$error = '';
$login_identifier = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $login_identifier = trim($_POST['login_identifier'] ?? '');
    $password = $_POST['password'] ?? '';

    if (empty($login_identifier) || empty($password)) {
        $error = 'Please enter both your username/email and password.';
    } else {
        try {
            $stmt = $pdo->prepare("
                SELECT id, username, name, email, password 
                FROM users 
                WHERE username = ? OR email = ? 
                LIMIT 1
            ");
            $stmt->execute([$login_identifier, $login_identifier]);
            $user = $stmt->fetch();

            if ($user && password_verify($password, $user['password'])) {
                // Prevent session fixation attack (as explicitly required by course security guidelines)
                session_regenerate_id(true);

                // Set session data
                $_SESSION['user_id']   = (int)$user['id'];
                $_SESSION['username']  = $user['username'];
                $_SESSION['user_name'] = $user['name'];
                $_SESSION['email']     = $user['email'];

                setFlashMessage('success', "Welcome back, " . htmlspecialchars($user['name']) . "!");
                header('Location: ../dashboard.php');
                exit;
            } else {
                $error = 'Invalid username/email or password. Please try again.';
            }
        } catch (PDOException $e) {
            $error = 'Database error: ' . $e->getMessage();
        }
    }
}

$pageTitle = 'Login - YumBook';
require_once __DIR__ . '/../includes/header.php';
?>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="card shadow-sm border-0 rounded-4">
                <div class="card-body p-4 p-md-5">
                    <div class="text-center mb-4">
                        <div class="d-inline-flex align-items-center justify-content-center bg-primary-subtle text-primary rounded-circle mb-3" style="width: 56px; height: 56px;">
                            <i class="bi bi-box-arrow-in-right fs-3"></i>
                        </div>
                        <h2 class="h3 fw-bold mb-1">Welcome Back</h2>
                        <p class="text-muted small">Log in to manage your culinary profile and share recipes.</p>
                    </div>

                    <?php if (!empty($error)): ?>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-circle-fill me-2"></i>
                            <?= htmlspecialchars($error) ?>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    <?php endif; ?>

                    <form action="login.php" method="POST" class="needs-validation" novalidate id="loginForm">
                        <div class="mb-3">
                            <label for="login_identifier" class="form-label fw-semibold small">Username or Email <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light text-muted"><i class="bi bi-person"></i></span>
                                <input type="text" class="form-control" id="login_identifier" name="login_identifier" value="<?= htmlspecialchars($login_identifier) ?>" placeholder="Username or email address" required>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="password" class="form-label fw-semibold small">Password <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light text-muted"><i class="bi bi-lock"></i></span>
                                <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" required>
                            </div>
                        </div>

                        <div class="d-grid mb-3">
                            <button type="submit" class="btn btn-primary btn-lg rounded-pill fw-semibold shadow-sm">
                                <i class="bi bi-box-arrow-in-right me-2"></i> Log In
                            </button>
                        </div>

                        <div class="text-center text-muted small">
                            Don't have an account? 
                            <a href="register.php" class="text-primary fw-semibold text-decoration-none">Sign up here</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// Client-side Bootstrap validation
(function () {
    'use strict';
    const form = document.getElementById('loginForm');
    form.addEventListener('submit', function (event) {
        if (!form.checkValidity()) {
            event.preventDefault();
            event.stopPropagation();
        }
        form.classList.add('was-validated');
    }, false);
})();
</script>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
