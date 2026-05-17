/**
 * StayEase - Main JavaScript
 * Handles form validation, date pickers, and UI interactions
 */

document.addEventListener('DOMContentLoaded', function () {

    // ========================================
    // Form Validation
    // ========================================
    function validateEmail(email) {
        return /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/.test(email);
    }

    function validatePhone(phone) {
        return /^[+]?[0-9\-\s()]{7,20}$/.test(phone);
    }

    // Login Form Validation
    const loginForm = document.getElementById('loginForm');
    if (loginForm) {
        loginForm.addEventListener('submit', function (e) {
            const email = document.getElementById('email').value.trim();
            const password = document.getElementById('password').value.trim();
            if (!email || !password) {
                e.preventDefault();
                showToast('Please fill in all fields.', 'error');
                return;
            }
            if (!validateEmail(email)) {
                e.preventDefault();
                showToast('Please enter a valid email address.', 'error');
            }
        });
    }

    // Registration Form Validation
    const registerForm = document.getElementById('registerForm');
    if (registerForm) {
        registerForm.addEventListener('submit', function (e) {
            const fullName = document.getElementById('fullName').value.trim();
            const email = document.getElementById('email').value.trim();
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const phone = document.getElementById('phone').value.trim();

            if (!fullName || !email || !password) {
                e.preventDefault();
                showToast('Please fill in all required fields.', 'error');
                return;
            }
            if (!validateEmail(email)) {
                e.preventDefault();
                showToast('Please enter a valid email address.', 'error');
                return;
            }
            if (password.length < 6) {
                e.preventDefault();
                showToast('Password must be at least 6 characters.', 'error');
                return;
            }
            if (password !== confirmPassword) {
                e.preventDefault();
                showToast('Passwords do not match.', 'error');
                return;
            }
            if (phone && !validatePhone(phone)) {
                e.preventDefault();
                showToast('Please enter a valid phone number.', 'error');
            }
        });
    }

    // ========================================
    // Date Validation for Booking
    // ========================================
    const checkInInput = document.getElementById('checkIn');
    const checkOutInput = document.getElementById('checkOut');

    if (checkInInput && checkOutInput) {
        // Set minimum date to today
        const today = new Date().toISOString().split('T')[0];
        checkInInput.setAttribute('min', today);
        checkOutInput.setAttribute('min', today);

        checkInInput.addEventListener('change', function () {
            // Set checkout min to day after checkin
            const checkInDate = new Date(this.value);
            checkInDate.setDate(checkInDate.getDate() + 1);
            const minCheckOut = checkInDate.toISOString().split('T')[0];
            checkOutInput.setAttribute('min', minCheckOut);
            if (checkOutInput.value && checkOutInput.value <= this.value) {
                checkOutInput.value = minCheckOut;
            }
            calculateTotal();
        });

        checkOutInput.addEventListener('change', function () {
            calculateTotal();
        });
    }

    // ========================================
    // Price Calculation
    // ========================================
    function calculateTotal() {
        const checkIn = document.getElementById('checkIn');
        const checkOut = document.getElementById('checkOut');
        const pricePerNight = document.getElementById('pricePerNight');
        const totalDisplay = document.getElementById('totalPrice');
        const nightsDisplay = document.getElementById('numberOfNights');

        if (checkIn && checkOut && pricePerNight && totalDisplay && checkIn.value && checkOut.value) {
            const start = new Date(checkIn.value);
            const end = new Date(checkOut.value);
            const nights = Math.ceil((end - start) / (1000 * 60 * 60 * 24));
            const price = parseFloat(pricePerNight.value);

            if (nights > 0) {
                const total = nights * price;
                totalDisplay.textContent = '$' + total.toFixed(2);
                if (nightsDisplay) nightsDisplay.textContent = nights;
            }
        }
    }

    // ========================================
    // Toast Notifications
    // ========================================
    window.showToast = function (message, type) {
        const container = document.getElementById('toastContainer') || createToastContainer();
        const toast = document.createElement('div');
        toast.className = 'alert alert-' + (type === 'error' ? 'error' : type === 'success' ? 'success' : 'info');
        toast.innerHTML = '<i class="fas fa-' + (type === 'error' ? 'exclamation-circle' : type === 'success' ? 'check-circle' : 'info-circle') + '"></i> ' + message;
        container.appendChild(toast);
        setTimeout(function () {
            toast.style.opacity = '0';
            toast.style.transform = 'translateY(-10px)';
            setTimeout(function () { toast.remove(); }, 300);
        }, 4000);
    };

    function createToastContainer() {
        const container = document.createElement('div');
        container.id = 'toastContainer';
        container.style.cssText = 'position:fixed;top:80px;right:20px;z-index:1000;max-width:400px;';
        document.body.appendChild(container);
        return container;
    }

    // ========================================
    // Mobile Navigation Toggle
    // ========================================
    const mobileMenuBtn = document.getElementById('mobileMenuBtn');
    const mobileMenu = document.getElementById('mobileMenu');
    if (mobileMenuBtn && mobileMenu) {
        mobileMenuBtn.addEventListener('click', function () {
            mobileMenu.classList.toggle('hidden');
        });
    }

    // ========================================
    // Confirm Dialogs
    // ========================================
    window.confirmAction = function (message, form) {
        if (confirm(message)) {
            form.submit();
        }
        return false;
    };

    // ========================================
    // Auto-hide alerts after 5 seconds
    // ========================================
    document.querySelectorAll('.alert').forEach(function (alert) {
        setTimeout(function () {
            alert.style.transition = 'all 0.4s ease';
            alert.style.opacity = '0';
            alert.style.transform = 'translateY(-10px)';
            setTimeout(function () { alert.remove(); }, 400);
        }, 5000);
    });

    // ========================================
    // Room search filters (client-side enhancement)
    // ========================================
    const roomTypeFilter = document.getElementById('roomTypeFilter');
    if (roomTypeFilter) {
        roomTypeFilter.addEventListener('change', function () {
            const selected = this.value;
            document.querySelectorAll('.room-item').forEach(function (card) {
                if (!selected || card.dataset.type === selected) {
                    card.style.display = '';
                } else {
                    card.style.display = 'none';
                }
            });
        });
    }

    // Initial price calculation if fields are pre-filled
    calculateTotal();
});
