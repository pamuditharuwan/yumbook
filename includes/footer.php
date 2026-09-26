    </main>

    <!-- Enhanced Modern Footer -->
    <footer class="site-footer border-top">
        <div class="container">
            <div class="row g-4 justify-content-between">
                <!-- Brand & Description -->
                <div class="col-lg-5 col-md-6 text-center text-md-start">
                    <a href="<?= $basePath ?>index.php" class="d-inline-block mb-3 text-decoration-none">
                        <img src="<?= $basePath ?>assets/images/logo-clean.png" alt="YumBook Logo" class="footer-brand-logo">
                    </a>
                    <p class="footer-brand-desc mb-0">
                        Your trusted culinary companion for discovering, cooking, and sharing authentic global recipes. Explore delicious step-by-step dishes crafted for food lovers and home cooks everywhere.
                    </p>
                </div>

                <!-- Navigation Links: Quick Links -->
                <div class="col-lg-3 col-md-4 text-center text-md-start ms-md-auto">
                    <h6 class="footer-section-title">Quick Links</h6>
                    <ul class="footer-nav-links list-unstyled mb-0">
                        <li>
                            <a href="<?= $basePath ?>index.php" class="footer-link">
                                <i class="bi bi-chevron-right small me-1"></i>Home
                            </a>
                        </li>
                        <li>
                            <a href="<?= $basePath ?>recipes.php" class="footer-link">
                                <i class="bi bi-chevron-right small me-1"></i>Browse Recipes
                            </a>
                        </li>
                        <li>
                            <a href="<?= $basePath ?>contact.php" class="footer-link">
                                <i class="bi bi-chevron-right small me-1"></i>Contact Us
                            </a>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- Copyright Section -->
            <div class="footer-bottom text-center">
                <p class="text-muted small mb-0">
                    &copy; 2026 <strong>YumBook</strong>. All Rights Reserved.
                </p>
            </div>
        </div>
    </footer>

    <!-- Recipe Quick View Modal (Bootstrap 5 Component) -->
    <div class="modal fade" id="quickViewModal" tabindex="-1" aria-labelledby="quickViewModalTitle" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content rounded-4 border-0 shadow">
                <div class="modal-header border-0 pb-0">
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4 pt-0">
                    <div class="row g-4 align-items-center">
                        <div class="col-md-5">
                            <img id="quickViewModalImage" src="" alt="Recipe Image" class="img-fluid rounded-4 object-fit-cover shadow-sm w-100" style="height: 260px;">
                        </div>
                        <div class="col-md-7">
                            <div class="d-flex align-items-center gap-2 mb-2 flex-wrap">
                                <span id="quickViewModalCategory" class="badge bg-primary rounded-pill"></span>
                                <span class="text-muted small"><i class="bi bi-clock me-1"></i><span id="quickViewModalTime"></span> mins</span>
                                <span class="text-muted small"><i class="bi bi-geo-alt me-1"></i><span id="quickViewModalOrigin"></span></span>
                            </div>
                            <h3 id="quickViewModalTitle" class="h4 fw-bold mb-3"></h3>
                            <h6 class="fw-semibold text-muted small text-uppercase mb-2">Ingredients Preview:</h6>
                            <div id="quickViewModalIngredients" class="small text-muted mb-4" style="max-height: 100px; overflow-y: auto;"></div>
                            <div class="d-flex gap-2">
                                <a id="quickViewModalLink" href="#" class="btn btn-primary rounded-pill px-4 fw-semibold shadow-sm">
                                    <i class="bi bi-book-half me-1"></i> View Full Recipe
                                </a>
                                <button type="button" class="btn btn-outline-secondary rounded-pill px-3" data-bs-dismiss="modal">Close</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Floating Scroll-to-Top Button -->
    <button type="button" id="floatingBackToTop" class="floating-back-to-top" aria-label="Scroll to top">
        <i class="bi bi-arrow-up"></i>
    </button>

    <!-- Bootstrap 5 Bundle JS (Includes Popper) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom Application JS -->
    <script src="<?= $basePath ?>assets/js/main.js"></script>
</body>
</html>
