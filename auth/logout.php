<?php
// ==============================================================================
// YumBook - User Logout (auth/logout.php)
// ICT 1209: Web Technologies Mini-Project
// ==============================================================================

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// Clear all session variables
$_SESSION = [];

// Invalidate session cookie if present
if (ini_get("session.use_cookies")) {
    $params = session_get_cookie_params();
    setcookie(
        session_name(),
        '',
        time() - 42000,
        $params["path"],
        $params["domain"],
        $params["secure"],
        $params["httponly"]
    );
}

// Destroy session
session_destroy();

// Start fresh session for the goodbye flash message
session_start();
$_SESSION['flash_message'] = [
    'type' => 'info',
    'text' => 'You have been logged out successfully. Have a wonderful culinary day!'
];

header('Location: ../index.php');
exit;
