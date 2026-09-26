<?php
// ==============================================================================
// YumBook - Contact Us Page (contact.php)
// ICT 1209: Web Technologies Mini-Project
// Wireframe: 7.3 Contact Page
// ==============================================================================

require_once __DIR__ . '/includes/db.php';
require_once __DIR__ . '/includes/functions.php';

$errors = [];
$successMsg = '';
$name = '';
$email = '';
$message = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name = trim($_POST['name'] ?? '');
    $email = trim($_POST['email'] ?? '');
    $message = trim($_POST['message'] ?? '');

    // Server-side validation
    if (empty($name) || strlen($name) < 2) {
        $errors[] = 'Please enter your full name (minimum 2 characters).';
    }

    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $errors[] = 'Please enter a valid email address.';
    }

    if (empty($message) || strlen($message) < 10) {
        $errors[] = 'Your message must be at least 10 characters long.';
    }

    // Insert into contact_messages table if valid
    if (empty($errors)) {
        try {
            $insertStmt = $pdo->prepare("
                INSERT INTO messages (name, email, message) 
                VALUES (:name, :email, :message)
            ");
            $insertStmt->execute([
                'name'    => $name,
                'email'   => $email,
                'message' => $message
            ]);

            $successMsg = 'Thank you for reaching out! Your message has been sent successfully. We will get back to you shortly.';
            // Reset form fields after successful submission
            $name = '';
            $email = '';
            $message = '';
        } catch (PDOException $e) {
            $errors[] = 'Database error: ' . $e->getMessage();
        }
    }
}

$pageTitle = 'Contact Us - YumBook';
require_once __DIR__ . '/includes/header.php';
?>

<div class="container py-3">
    <!-- Page Header (Matches Wireframe 7.3) -->
    <div class="mb-4">
        <h1 class="h2 fw-bold text-dark mb-1">Contact Us</h1>
        <p class="text-muted">Have a question, suggestion, or found an issue? Send us a message below.</p>
    </div>

    <!-- Confirmation Success Message Area (Matches Wireframe 7.3) -->
    <?php if (!empty($successMsg)): ?>
        <div class="alert alert-success alert-dismissible fade show shadow-sm mb-4" role="alert">
            <div class="d-flex align-items-center gap-2">
                <i class="bi bi-check-circle-fill fs-4 text-success"></i>
                <div>
                    <strong>Message Delivered!</strong><br>
                    <?= htmlspecialchars($successMsg) ?>
                </div>
            </div>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <?php endif; ?>

    <?php if (!empty($errors)): ?>
        <div class="alert alert-danger shadow-sm mb-4">
            <h6 class="fw-bold mb-2"><i class="bi bi-exclamation-octagon-fill me-1"></i> Please correct the errors below:</h6>
            <ul class="mb-0 ps-3">
                <?php foreach ($errors as $err): ?>
                    <li><?= htmlspecialchars($err) ?></li>
                <?php endforeach; ?>
            </ul>
        </div>
    <?php endif; ?>

    <div class="row g-4">
        <!-- Contact Form Column (Matches Wireframe 7.3) -->
        <div class="col-lg-7">
            <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5">
                <form action="contact.php" method="POST" id="contactForm" novalidate>
                    <!-- Name Input -->
                    <div class="mb-3">
                        <label for="name" class="form-label fw-semibold">Name <span class="text-danger">*</span></label>
                        <input type="text" 
                               class="form-control" 
                               id="name" 
                               name="name" 
                               placeholder="Enter your full name" 
                               value="<?= htmlspecialchars($name) ?>" 
                               required>
                        <div class="invalid-feedback">Please enter your name.</div>
                    </div>

                    <!-- Email Input -->
                    <div class="mb-3">
                        <label for="email" class="form-label fw-semibold">Email Address <span class="text-danger">*</span></label>
                        <input type="email" 
                               class="form-control" 
                               id="email" 
                               name="email" 
                               placeholder="you@example.com" 
                               value="<?= htmlspecialchars($email) ?>" 
                               required>
                        <div class="invalid-feedback">Please enter a valid email address.</div>
                    </div>

                    <!-- Message Textarea -->
                    <div class="mb-4">
                        <label for="message" class="form-label fw-semibold">Message <span class="text-danger">*</span></label>
                        <textarea class="form-control" 
                                  id="message" 
                                  name="message" 
                                  rows="6" 
                                  placeholder="Type your message here..." 
                                  required><?= htmlspecialchars($message) ?></textarea>
                        <div class="invalid-feedback">Please provide a message of at least 10 characters.</div>
                        <div class="form-text small text-muted">* Real-time validation: shows inline error if email format is invalid or a field is empty</div>
                    </div>

                    <button type="submit" class="btn btn-primary px-4 py-2 fw-semibold" id="submitBtn">
                        <i class="bi bi-send-fill me-1"></i> Send Message
                    </button>
                </form>
            </div>
        </div>

        <!-- Get in Touch Info Panel Column (Matches Wireframe 7.3) -->
        <div class="col-lg-5">
            <div class="card border-0 shadow-sm rounded-4 p-4 mb-4">
                <h4 class="fw-bold mb-3">Get in Touch</h4>
                
                <div class="d-flex align-items-start gap-3 mb-3">
                    <div class="bg-primary bg-opacity-10 text-primary p-2 rounded-circle">
                        <i class="bi bi-envelope-at fs-5"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Email Address</div>
                        <a href="mailto:support@yumbook.lk" class="fw-semibold text-decoration-none text-dark">
                            support@yumbook.lk
                        </a>
                    </div>
                </div>

                <div class="d-flex align-items-start gap-3 mb-0">
                    <div class="bg-warning bg-opacity-10 text-warning p-2 rounded-circle">
                        <i class="bi bi-clock-history fs-5 text-dark"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Response Time</div>
                        <div class="fw-semibold text-dark">1–2 business days</div>
                    </div>
                </div>
            </div>

            <!-- Recipe Inquiries & Help Card -->
            <div class="card border-0 bg-light rounded-4 p-4">
                <h6 class="fw-bold mb-2 text-dark">
                    <i class="bi bi-chat-heart text-primary me-2"></i>Recipe Inquiries &amp; Feedback
                </h6>
                <p class="small text-muted mb-0" style="line-height: 1.6;">
                    Have questions about a cooking technique, want to share a family recipe, or have culinary suggestions? We'd love to hear from you! Our team typically responds within 24–48 hours.
                </p>
            </div>
        </div>
    </div>
</div>

<?php require_once __DIR__ . '/includes/footer.php'; ?>
