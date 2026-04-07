(function () {
  function initMobileMenu() {
    console.log("mobile menu init");
    var openButton = document.querySelector("[data-mobile-menu-open]");
    var closeButton = document.querySelector("[data-mobile-menu-close]");
    var overlay = document.querySelector("[data-mobile-menu-overlay]");
    var panel = document.querySelector("[data-mobile-menu-panel]");
    console.log("openButton found:", openButton);
    if (!openButton || !closeButton || !overlay || !panel) return;
    if (openButton.dataset.mobileMenuBound === "true") return;

    function openMenu() {
      overlay.classList.remove("hidden");
      panel.classList.remove("hidden");

      requestAnimationFrame(function () {
        overlay.classList.remove("opacity-0");
        overlay.classList.add("opacity-100");

        panel.classList.remove("opacity-0", "scale-95", "-translate-y-2");
        panel.classList.add("opacity-100", "scale-100", "translate-y-0");
      });

      document.body.classList.add("overflow-hidden");
    }

    function closeMenu() {
      overlay.classList.remove("opacity-100");
      overlay.classList.add("opacity-0");

      panel.classList.remove("opacity-100", "scale-100", "translate-y-0");
      panel.classList.add("opacity-0", "scale-95", "-translate-y-2");

      setTimeout(function () {
        overlay.classList.add("hidden");
        panel.classList.add("hidden");
      }, 200);

      document.body.classList.remove("overflow-hidden");
    }

    openButton.addEventListener("click", openMenu);
    closeButton.addEventListener("click", closeMenu);
    overlay.addEventListener("click", closeMenu);

    document.addEventListener("keydown", function (event) {
      if (event.key === "Escape") {
        closeMenu();
      }
    });

    var menuLinks = document.querySelectorAll("[data-mobile-menu-link]");
    menuLinks.forEach(function (link) {
      link.addEventListener("click", closeMenu);
    });

    openButton.dataset.mobileMenuBound = "true";
  }

  document.addEventListener("DOMContentLoaded", initMobileMenu);
  document.addEventListener("turbolinks:load", initMobileMenu);
  document.addEventListener("turbo:load", initMobileMenu);
})();
