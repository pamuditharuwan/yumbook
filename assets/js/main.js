/**
 * YumBook - Vanilla JavaScript (assets/js/main.js)
 * ICT 1209: Web Technologies Mini-Project
 */

document.addEventListener('DOMContentLoaded', () => {
    // -------------------------------------------------------------
    // 1. Interactive Star Rating Widget (Recipe Detail Page)
    // -------------------------------------------------------------
    const ratingWidget = document.getElementById('ratingWidget');
    if (ratingWidget) {
        const stars = ratingWidget.querySelectorAll('.star-btn');
        const ratingInput = document.getElementById('selectedRating');
        const ratingText = document.getElementById('ratingDescription');

        const ratingLabels = {
            1: '1 - Poor',
            2: '2 - Fair',
            3: '3 - Good',
            4: '4 - Very Good',
            5: '5 - Excellent & Delicious!'
        };

        function highlightStars(val) {
            stars.forEach(star => {
                const starVal = parseInt(star.getAttribute('data-value'));
                if (starVal <= val) {
                    star.classList.remove('bi-star', 'text-muted');
                    star.classList.add('bi-star-fill', 'text-warning');
                } else {
                    star.classList.remove('bi-star-fill', 'text-warning');
                    star.classList.add('bi-star', 'text-muted');
                }
            });
        }

        stars.forEach(star => {
            star.addEventListener('mouseenter', () => {
                const hoverVal = parseInt(star.getAttribute('data-value'));
                highlightStars(hoverVal);
                if (ratingText) {
                    ratingText.textContent = ratingLabels[hoverVal] || '';
                }
            });

            star.addEventListener('click', () => {
                const chosenVal = parseInt(star.getAttribute('data-value'));
                ratingInput.value = chosenVal;
                highlightStars(chosenVal);
                if (ratingText) {
                    ratingText.textContent = ratingLabels[chosenVal] || '';
                }
            });
        });

        ratingWidget.addEventListener('mouseleave', () => {
            const currentVal = parseInt(ratingInput.value) || 0;
            highlightStars(currentVal);
            if (ratingText) {
                ratingText.textContent = currentVal > 0 ? ratingLabels[currentVal] : 'Click on a star to rate this recipe';
            }
        });
    }

    // -------------------------------------------------------------
    // 2. Real-time Contact Form Validation (Contact Page)
    // -------------------------------------------------------------
    const contactForm = document.getElementById('contactForm');
    if (contactForm) {
        const nameInput = document.getElementById('name');
        const emailInput = document.getElementById('email');
        const messageInput = document.getElementById('message');

        function validateEmail(email) {
            const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return re.test(String(email).toLowerCase());
        }

        function setValidationState(input, isValid, message) {
            const feedback = input.nextElementSibling;
            if (isValid) {
                input.classList.remove('is-invalid');
                input.classList.add('is-valid');
            } else {
                input.classList.remove('is-valid');
                input.classList.add('is-invalid');
                if (feedback && feedback.classList.contains('invalid-feedback')) {
                    feedback.textContent = message;
                }
            }
        }

        if (nameInput) {
            nameInput.addEventListener('input', () => {
                if (nameInput.value.trim().length >= 2) {
                    setValidationState(nameInput, true, '');
                } else {
                    setValidationState(nameInput, false, 'Please enter your name (at least 2 characters).');
                }
            });
        }

        if (emailInput) {
            emailInput.addEventListener('input', () => {
                if (validateEmail(emailInput.value.trim())) {
                    setValidationState(emailInput, true, '');
                } else {
                    setValidationState(emailInput, false, 'Please enter a valid email address.');
                }
            });
        }

        if (messageInput) {
            messageInput.addEventListener('input', () => {
                if (messageInput.value.trim().length >= 10) {
                    setValidationState(messageInput, true, '');
                } else {
                    setValidationState(messageInput, false, 'Message must be at least 10 characters long.');
                }
            });
        }

        contactForm.addEventListener('submit', (e) => {
            let isFormValid = true;

            if (nameInput.value.trim().length < 2) {
                setValidationState(nameInput, false, 'Name is required.');
                isFormValid = false;
            }
            if (!validateEmail(emailInput.value.trim())) {
                setValidationState(emailInput, false, 'A valid email address is required.');
                isFormValid = false;
            }
            if (messageInput.value.trim().length < 10) {
                setValidationState(messageInput, false, 'Message must be at least 10 characters.');
                isFormValid = false;
            }

            if (!isFormValid) {
                e.preventDefault();
            }
        });
    }

    // -------------------------------------------------------------
    // 3. Interactive Ingredient Checkboxes on Recipe Detail Page
    // -------------------------------------------------------------
    const ingredientItems = document.querySelectorAll('.ingredient-checkbox-item');
    ingredientItems.forEach(item => {
        const checkbox = item.querySelector('input[type="checkbox"]');
        if (checkbox) {
            checkbox.addEventListener('change', () => {
                if (checkbox.checked) {
                    item.classList.add('text-decoration-line-through', 'text-muted');
                } else {
                    item.classList.remove('text-decoration-line-through', 'text-muted');
                }
            });
        }
    });

    // -------------------------------------------------------------
    // 4. Dynamic Floating Back-to-Top Button
    // -------------------------------------------------------------
    const floatingBackToTop = document.getElementById('floatingBackToTop');
    if (floatingBackToTop) {
        const toggleBackToTop = () => {
            if (window.scrollY > 280) {
                floatingBackToTop.classList.add('show');
            } else {
                floatingBackToTop.classList.remove('show');
            }
        };

        window.addEventListener('scroll', toggleBackToTop, { passive: true });
        toggleBackToTop();

        floatingBackToTop.addEventListener('click', () => {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
    }

    // -------------------------------------------------------------
    // 5. Bootstrap 5 Recipe Quick View Modal Handler
    // -------------------------------------------------------------
    const quickViewModal = document.getElementById('quickViewModal');
    if (quickViewModal) {
        quickViewModal.addEventListener('show.bs.modal', (event) => {
            const button = event.relatedTarget;
            if (!button) return;

            const title = button.getAttribute('data-title') || 'Delicious Recipe';
            const category = button.getAttribute('data-category') || 'Main';
            const origin = button.getAttribute('data-origin') || 'Global';
            const time = button.getAttribute('data-time') || '30';
            const image = button.getAttribute('data-image') || '';
            const ingredients = button.getAttribute('data-ingredients') || '';
            const url = button.getAttribute('data-url') || '#';

            const titleEl = document.getElementById('quickViewModalTitle');
            const categoryEl = document.getElementById('quickViewModalCategory');
            const originEl = document.getElementById('quickViewModalOrigin');
            const timeEl = document.getElementById('quickViewModalTime');
            const imageEl = document.getElementById('quickViewModalImage');
            const ingredientsEl = document.getElementById('quickViewModalIngredients');
            const linkEl = document.getElementById('quickViewModalLink');

            if (titleEl) titleEl.textContent = title;
            if (categoryEl) categoryEl.textContent = category;
            if (originEl) originEl.textContent = origin;
            if (timeEl) timeEl.textContent = time;
            if (imageEl) {
                imageEl.src = image;
                imageEl.alt = title;
            }
            if (ingredientsEl) {
                const items = ingredients.split(/\n|,/).map(s => s.trim()).filter(Boolean).slice(0, 5);
                ingredientsEl.innerHTML = '<ul class="mb-0 ps-3">' + items.map(i => `<li>${i}</li>`).join('') + (items.length >= 5 ? '<li class="text-primary small mt-1">+ more in full recipe</li>' : '') + '</ul>';
            }
            if (linkEl) linkEl.href = url;
        });
    }
});

// -------------------------------------------------------------
// 4. Global Newsletter Subscription Handler
// -------------------------------------------------------------
window.handleNewsletterSubmit = function(form) {
    const feedback = form.querySelector('.newsletter-feedback');
    const input = form.querySelector('input[type="email"]');
    const btn = form.querySelector('button[type="submit"]');
    if (input && input.value) {
        btn.disabled = true;
        btn.innerHTML = '<i class="bi bi-check2"></i>';
        if (feedback) feedback.style.display = 'block';
        input.value = '';
        setTimeout(() => {
            btn.disabled = false;
            btn.textContent = 'Join';
            if (feedback) feedback.style.display = 'none';
        }, 4000);
    }
};

// -------------------------------------------------------------
// 5. Safe Image Resolver Helper
// -------------------------------------------------------------
window.getRecipeImage = function(recipe) {
    if (!recipe) return 'assets/images/recipes/recipe-placeholder.jpg';
    return recipe.image_url || 'assets/images/recipes/recipe-placeholder.jpg';
};

// -------------------------------------------------------------
// 6. Client-Side Authentication & Dynamic Navbar State
// -------------------------------------------------------------
window.getCurrentUser = function() {
    try {
        const u = localStorage.getItem('yumbook_user');
        return u ? JSON.parse(u) : null;
    } catch (e) {
        return null;
    }
};

window.setCurrentUser = function(user) {
    localStorage.setItem('yumbook_user', JSON.stringify(user));
    window.updateNavAuth();
};

window.handleLogout = function() {
    localStorage.removeItem('yumbook_user');
    localStorage.removeItem('yumbook_registered_users');
    const isAuthDir = window.location.pathname.includes('/auth/');
    window.location.href = isAuthDir ? '../index.html' : 'index.html';
};

window.updateNavAuth = function() {
    const navList = document.querySelector('.navbar-nav');
    if (!navList) return;

    let authContainer = document.getElementById('navAuthItem');
    if (!authContainer) {
        authContainer = document.createElement('li');
        authContainer.id = 'navAuthItem';
        authContainer.className = 'nav-item d-flex align-items-center gap-2';
        navList.appendChild(authContainer);
    }

    const user = window.getCurrentUser();
    const pathParts = window.location.pathname.split('/');
    const currentPage = pathParts.pop() || 'index.html';
    const isAuthDir = window.location.pathname.includes('/auth/');
    const basePath = isAuthDir ? '../' : '';

    if (user) {
        authContainer.innerHTML = `
            <div class="dropdown">
                <a class="nav-link dropdown-toggle d-flex align-items-center fw-semibold text-primary" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="bi bi-person-circle fs-5 me-1"></i>
                    <span>${user.name || user.username}</span>
                </a>
                <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0" aria-labelledby="userDropdown">
                    <li>
                        <a class="dropdown-item py-2" href="${basePath}dashboard.html">
                            <i class="bi bi-speedometer2 text-primary me-2"></i> Dashboard
                        </a>
                    </li>
                    <li><hr class="dropdown-divider"></li>
                    <li>
                        <a class="dropdown-item py-2 text-danger" href="javascript:void(0)" onclick="handleLogout()">
                            <i class="bi bi-box-arrow-right me-2"></i> Logout
                        </a>
                    </li>
                </ul>
            </div>
        `;
    } else {
        authContainer.innerHTML = `
            <a class="nav-link ${currentPage === 'login.html' ? 'active fw-bold' : ''}" href="${basePath}login.html">
                <i class="bi bi-box-arrow-in-right me-1"></i> Login
            </a>
            <a class="btn btn-primary btn-sm px-3 rounded-pill text-white fw-medium shadow-sm" href="${basePath}register.html">
                <i class="bi bi-person-plus me-1"></i> Sign Up
            </a>
        `;
    }
};

document.addEventListener('DOMContentLoaded', () => {
    window.updateNavAuth();
});


