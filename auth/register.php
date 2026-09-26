<?php
// ==============================================================================
// YumBook - User Registration (auth/register.php)
// ICT 1209: Web Technologies Mini-Project
// ==============================================================================

require_once __DIR__ . '/../includes/db.php';
require_once __DIR__ . '/../includes/functions.php';

// If already logged in, redirect to dashboard
if (isLoggedIn()) {
    header('Location: ../dashboard.php');
    exit;
}

$errors = [];
$username = '';
$name = '';
$email = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = trim($_POST['username'] ?? '');
    $name = trim($_POST['name'] ?? '');
    $email = trim($_POST['email'] ?? '');
    $password = $_POST['password'] ?? '';
    $confirm_password = $_POST['confirm_password'] ?? '';

    // Server-side validation
    if (empty($username)) {
        $errors[] = 'Username is required.';
    } elseif (!preg_match('/^[a-zA-Z0-9_]{3,30}$/', $username)) {
        $errors[] = 'Username must be between 3 and 30 characters (letters, numbers, underscores only).';
    }

    if (empty($name) || strlen($name) < 2) {
        $errors[] = 'Full name is required (minimum 2 characters).';
    }

    if (empty($email)) {
        $errors[] = 'Email address is required.';
    } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $errors[] = 'Please enter a valid email address.';
    }

    if (empty($password)) {
        $errors[] = 'Password is required.';
    } elseif (strlen($password) < 6) {
        $errors[] = 'Password must be at least 6 characters long.';
    }

    if ($password !== $confirm_password) {
        $errors[] = 'Passwords do not match.';
    }

    // Check if username or email already exists
    if (empty($errors)) {
        try {
            $stmt = $pdo->prepare("SELECT id, username, email FROM users WHERE username = ? OR email = ? LIMIT 1");
            $stmt->execute([$username, $email]);
            $existing = $stmt->fetch();

            if ($existing) {
                if (strcasecmp($existing['username'], $username) === 0) {
                    $errors[] = 'Username is already taken. Please choose another.';
                }
                if (strcasecmp($existing['email'], $email) === 0) {
                    $errors[] = 'An account with this email address already exists.';
                }
            }
        } catch (PDOException $e) {
            $errors[] = 'Database error: ' . $e->getMessage();
        }
    }

    // Insert user into database
    if (empty($errors)) {
        try {
            // Secure password hash using PASSWORD_BCRYPT as required by course guidelines
            $passwordHash = password_hash($password, PASSWORD_BCRYPT);

            $insertStmt = $pdo->prepare("
                INSERT INTO users (username, name, email, password) 
                VALUES (?, ?, ?, ?)
            ");
            $insertStmt->execute([$username, $name, $email, $passwordHash]);

            setFlashMessage('success', 'Registration successful! You can now log in with your credentials.');
            header('Location: login.php');
            exit;
        } catch (PDOException $e) {
            $errors[] = 'Failed to register account: ' . $e->getMessage();
        }
    }
}

$pageTitle = 'Sign Up - YumBook';
require_once __DIR__ . '/../includes/header.php';
?>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-7 col-lg-5">
            <div class="card shadow-sm border-0 rounded-4">
                <div class="card-body p-4 p-md-5">
                    <div class="text-center mb-4">
                        <div class="d-inline-flex align-items-center justify-content-center bg-primary-subtle text-primary rounded-circle mb-3" style="width: 56px; height: 56px;">
                            <i class="bi bi-person-plus fs-3"></i>
                        </div>
                        <h2 class="h3 fw-bold mb-1">Create an Account</h2>
                        <p class="text-muted small">Join YumBook to share your favorite recipes and join our culinary community.</p>
                    </div>

                    <?php if (!empty($errors)): ?>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>
                            <strong>Please correct the following:</strong>
                            <ul class="mb-0 mt-2 ps-3 small">
                                <?php foreach ($errors as $error): ?>
                                    <li><?= htmlspecialchars($error) ?></li>
                                <?php endforeach; ?>
                            </ul>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    <?php endif; ?>

                    <form action="register.php" method="POST" class="needs-validation" novalidate id="registerForm">
                        <div class="mb-3">
                            <label for="username" class="form-label fw-semibold small">Username <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light text-muted"><i class="bi bi-at"></i></span>
                                <input type="text" class="form-control" id="username" name="username" value="<?= htmlspecialchars($username) ?>" placeholder="e.g. foodlover22" required pattern="^[a-zA-Z0-9_]{3,30}$">
                            </div>
                            <div class="form-text small">3-30 characters, letters, numbers, and underscores only.</div>
                        </div>

                        <div class="mb-3">
                            <label for="name" class="form-label fw-semibold small">Full Name <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light text-muted"><i class="bi bi-person"></i></span>
                                <input type="text" class="form-control" id="name" name="name" value="<?= htmlspecialchars($name) ?>" placeholder="e.g. Kamal Perera" required minlength="2">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="email" class="form-label fw-semibold small">Email Address <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light text-muted"><i class="bi bi-envelope"></i></span>
                                <input type="email" class="form-control" id="email" name="email" value="<?= htmlspecialchars($email) ?>" placeholder="name@example.com" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="password" class="form-label fw-semibold small">Password <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light text-muted"><i class="bi bi-lock"></i></span>
                                <input type="password" class="form-control" id="password" name="password" placeholder="At least 6 characters" required minlength="6">
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="confirm_password" class="form-label fw-semibold small">Confirm Password <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light text-muted"><i class="bi bi-lock-fill"></i></span>
                                <input type="password" class="form-control" id="confirm_password" name="confirm_password" placeholder="Re-type your password" required minlength="6">
                            </div>
                        </div>

                        <div class="d-grid mb-3">
                            <button type="submit" class="btn btn-primary btn-lg rounded-pill fw-semibold shadow-sm">
                                <i class="bi bi-person-check me-2"></i> Register Account
                            </button>
                        </div>

                        <div class="text-center text-muted small">
                            Already have an account? 
                            <a href="login.php" class="text-primary fw-semibold text-decoration-none">Log in here</a>
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
    const form = document.getElementById('registerForm');
    form.addEventListener('submit', function (event) {
        const pass = document.getElementById('password').value;
        const confirm = document.getElementById('confirm_password').value;
        if (pass !== confirm) {
            document.getElementById('confirm_password').setCustomValidity("Passwords Don't Match");
        } else {
            document.getElementById('confirm_password').setCustomValidity('');
        }

        if (!form.checkValidity()) {
            event.preventDefault();
            event.stopPropagation();
        }
        form.classList.add('was-validated');
    }, false);
})();
</script>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
