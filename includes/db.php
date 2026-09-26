<?php
// ==============================================================================
// YumBook - Database Connection (includes/db.php)
// ICT 1209: Web Technologies Mini-Project
// ==============================================================================

$db_host = 'localhost';
$db_name = 'yumbook_db';
$db_user = 'root';
$db_pass = ''; // Default XAMPP password is empty

try {
    $dsn = "mysql:host={$db_host};dbname={$db_name};charset=utf8mb4";
    $options = [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES   => true,
    ];
    $pdo = new PDO($dsn, $db_user, $db_pass, $options);
} catch (PDOException $e) {
    // Beginner-friendly error display for university evaluation
    $error_msg = $e->getMessage();
    ?>
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Database Connection Error - YumBook</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light d-flex align-items-center min-vh-100">
        <div class="container py-5">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="card shadow border-danger">
                        <div class="card-header bg-danger text-white">
                            <h4 class="mb-0">⚠️ Database Connection Error</h4>
                        </div>
                        <div class="card-body p-4">
                            <p class="lead">Could not connect to MySQL database <strong>yumbook_db</strong>.</p>
                            <div class="alert alert-secondary font-monospace small">
                                <?= htmlspecialchars($error_msg) ?>
                            </div>
                            <h5 class="mt-4">How to fix this in XAMPP:</h5>
                            <ol class="mb-4">
                                <li>Open <strong>XAMPP Control Panel</strong> and ensure <strong>Apache</strong> and <strong>MySQL</strong> are started (green).</li>
                                <li>Open your browser and navigate to <a href="http://localhost/phpmyadmin" target="_blank" class="text-primary">http://localhost/phpmyadmin</a>.</li>
                                <li>Create a new database named <code>yumbook_db</code>.</li>
                                <li>Click on the <strong>Import</strong> tab and upload the <code>sql/database.sql</code> file located inside this project folder.</li>
                                <li>Refresh this page.</li>
                            </ol>
                            <a href="index.php" class="btn btn-outline-danger">Retry Connection</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
    </html>
    <?php
    exit;
}
