# YumBook – Digital Recipe Book 🍳📖

**Course:** ICT 1209 – Web Technologies Mini-Project  
**Institution:** Rajarata University of Sri Lanka (Faculty of Technology, Department of ICT)  
**Academic Year:** 2024 / 2026  
**Group Members:**
- S. H. M. P. R. Sooryarathna – `ITT/2024/104`
- M. M. R. T. Abeywickrama – `ITT/2024/006`

---

## 🌟 Project Overview
**YumBook** is an interactive, responsive digital recipe book web application designed and built for home cooks, food enthusiasts, and students. Users can discover authentic regional and international dishes, explore detailed step-by-step cooking methods, filter by cooking time and categories, submit their own recipes, and interact through ratings and contact messaging.

The project strictly fulfills all requirements of the ICT 1209 Mini-Project specification, including secure authentication, session management, PDO prepared statements, and Bootstrap 5 UI components.

---

## 🛠️ Technology Stack
- **Frontend:** Semantic HTML5, CSS3, Bootstrap 5.3 (CDN), Bootstrap Icons, Vanilla JavaScript (ES6+)
- **Backend:** PHP 8.x (Clean, modular architecture with PDO database layer)
- **Database:** MySQL / MariaDB (`yumbook_db`)
- **Security:** `PASSWORD_BCRYPT` hashing, `session_regenerate_id(true)` protection, PDO parameter binding (SQL injection prevention), HTML entity escaping (XSS prevention)
- **Deployment Compatibility:** Dual-mode execution:
  - **Local Development / University Evaluation:** Apache + MySQL (XAMPP / WAMP)
  - **Cloud Hosting:** 100% Vercel Drop compatible static build

---

## 📁 Project Structure (Section 6 Compliance)

```
yumbook/
├── auth/                       # User Authentication Module
│   ├── login.php               # Login form with session fixation prevention
│   ├── logout.php              # Session destruction & cookie invalidation
│   └── register.php            # User registration with password_hash(PASSWORD_BCRYPT)
├── includes/                   # Reusable Backend Modules
│   ├── db.php                  # PDO database connection & error handling
│   ├── functions.php           # Helper functions (auth, sanitization, flash msgs, badges)
│   ├── header.php              # Global navigation bar with dynamic auth state
│   └── footer.php              # Global footer with Quick View Modal & Back-to-Top
├── assets/                     # Frontend Assets
│   ├── css/style.css           # Custom styling, color variables & animations
│   ├── js/main.js              # Vanilla JS for ratings, form validation & Quick View modal
│   ├── js/app-store.js         # Client-side recipe repository (for static hosting)
│   └── images/                 # Optimized local photography & brand assets
├── contact.php                 # Contact page storing entries in `messages` table
├── dashboard.php               # Protected creator dashboard for recipe submissions
├── database.sql                # Complete MySQL schema & seed script (Root level)
├── index.php                   # Homepage with Bootstrap Carousel & featured recipes
├── recipes.php                 # Search, category & time filters, pagination & Quick View
├── recipe-detail.php           # Detailed recipe view with ingredients checklist & ratings
├── README.md                   # Project documentation & setup instructions
├── vercel.json                 # Vercel deployment configuration
└── sql/
    └── database.sql            # Secondary copy of database script
```

---

## 🗄️ Database Setup & Configuration

### 1. Database Specifications
- **Database Name:** `yumbook_db`
- **Host:** `localhost`
- **Username:** `root`
- **Password:** ` ` *(empty by default in XAMPP)*

### 2. Import Instructions
1. Open **XAMPP Control Panel** and start **Apache** and **MySQL**.
2. Navigate to [http://localhost/phpmyadmin](http://localhost/phpmyadmin).
3. Create a new database named `yumbook_db` with collation `utf8mb4_unicode_ci`.
4. Click on the **Import** tab.
5. Select `database.sql` from the root of this project and click **Import**.

### 3. Database Schema
- **`users`** (`id`, `username`, `name`, `email`, `password`, `created_at`)
- **`recipes`** (`id`, `user_id`, `title`, `category`, `origin`, `cooking_time`, `ingredients`, `steps`, `instructions`, `image_url`, `created_at`)
- **`ratings`** (`id`, `recipe_id`, `user_ip_or_id`, `rating`, `created_at`)
- **`messages`** (`id`, `name`, `email`, `message`, `created_at`)

---

## 🔑 User Authentication
Users can register a user account directly via the **Sign Up** page (`auth/register.php` or `register.html`) with secure `PASSWORD_BCRYPT` password hashing, log in, and manage their personal recipe contributions via the **Dashboard**.

---

## 🧩 Key Features & Phase 2 Components

### 1. Bootstrap 5 Carousel
- Located on the homepage hero section (`index.php` and `index.html`).
- Displays animated cross-fading slides showcasing signature dishes (Sri Lankan Lamprais, Buttermilk Pancakes, Pan-Seared Salmon) with custom captions.

### 2. Bootstrap 5 Quick View Modal
- Accessible across all recipe listings (`index.php`, `recipes.php`, `index.html`, `recipes.html`).
- Allows users to preview recipe images, preparation time, origins, and ingredient snippets without navigating away from the catalog.

### 3. Secure Authentication & Session Security
- Registration uses `password_hash($pass, PASSWORD_BCRYPT)`.
- Login validates via `password_verify()` and invokes `session_regenerate_id(true)` to protect against session hijacking and fixation attacks.
- Complete logout wipes `$_SESSION`, destroys cookies, and invalidates session files.

### 4. Protected User Dashboard (`dashboard.php`)
- Restricted to logged-in users.
- Profile summary with account metrics and joined date.
- Recipe creator form allowing users to publish custom dishes stored directly in the `recipes` table linked to their `user_id`.
- User recipe listing showing all dishes submitted by the current authenticated account.

### 5. Contact Query Storage
- Validates user input on both client-side and server-side.
- Securely logs inquiries into the `messages` table via prepared statements.

---

## 🚀 Deployment Instructions

### Local XAMPP Setup
1. Move or clone the project folder into your XAMPP web root:  
   `C:\xampp\htdocs\yumbook`
2. Ensure Apache and MySQL are running in XAMPP.
3. Access the web app in your browser:  
   `http://localhost/yumbook/index.php`

### Cloud Hosting (Vercel)
1. The project includes static mirror files (`index.html`, `recipes.html`, `contact.html`, `recipe-detail.html`) powered by `assets/js/app-store.js`.
2. Connect your GitHub repository to **[Vercel](https://vercel.com/)** or drag-and-drop the directory into Vercel Drop for instant global deployment.
