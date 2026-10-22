/* ==========================================================================
   Laura Crowley - Portfolio
   Plain JavaScript, no libraries. Replaces Brizy's scripts.
   Contents
   1. Setup
   2. Mobile slide-in menu
   3. Hero fade slider
   4. Project flip cards (tap to flip on touch screens)
   5. Scroll-reveal animation
   6. Contact form
   ========================================================================== */

(function () {
  "use strict";

  /* ------------------------------------------------------------------
     1. SETUP
     ------------------------------------------------------------------ */
  document.documentElement.classList.add("js");
  var reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;


  /* ------------------------------------------------------------------
     2. MOBILE SLIDE-IN MENU
     Hamburger opens a panel from the left; closes on link click,
     backdrop click, Escape, or when the screen grows to desktop size.
     ------------------------------------------------------------------ */
  var toggle = document.querySelector(".nav-toggle");
  var menu = document.getElementById("mobile-menu");
  var backdrop = document.querySelector(".mobile-menu-backdrop");

  function setMenu(open) {
    if (!toggle || !menu) return;
    toggle.setAttribute("aria-expanded", String(open));
    toggle.setAttribute("aria-label", open ? "Close navigation menu" : "Open navigation menu");
    menu.classList.toggle("is-open", open);
    menu.setAttribute("aria-hidden", String(!open));
    backdrop.hidden = !open;
    document.body.style.overflow = open ? "hidden" : "";
    if (open) menu.querySelector("a").focus(); else if (document.activeElement && menu.contains(document.activeElement)) toggle.focus();
  }

  if (toggle && menu && backdrop) {
    toggle.addEventListener("click", function () {
      setMenu(toggle.getAttribute("aria-expanded") !== "true");
    });
    backdrop.addEventListener("click", function () { setMenu(false); });
    menu.addEventListener("click", function (e) { if (e.target.closest("a")) setMenu(false); });
    document.addEventListener("keydown", function (e) { if (e.key === "Escape") setMenu(false); });
    window.matchMedia("(min-width: 992px)").addEventListener("change", function (e) {
      if (e.matches) setMenu(false);
    });
  }


  /* ------------------------------------------------------------------
     3. HERO FADE SLIDER
     Same settings as the original: fades, auto-plays every 3 seconds,
     no arrows or dots. Pauses when the tab is hidden.
     ------------------------------------------------------------------ */
  var slider = document.querySelector(".slider");
  if (slider) {
    var slides = Array.prototype.slice.call(slider.querySelectorAll(".slide"));
    var current = 0;
    var timer = null;

    var show = function (i) {
      current = (i + slides.length) % slides.length;
      slides.forEach(function (s, n) { s.classList.toggle("is-active", n === current); });
    };
    var start = function () {
      if (reduceMotion || slides.length < 2 || timer) return;
      timer = setInterval(function () { show(current + 1); }, 3000);
    };
    var stop = function () { clearInterval(timer); timer = null; };

    slides.forEach(function (s) { s.loading = "eager"; }); // preload so the fade is smooth
    document.addEventListener("visibilitychange", function () { if (document.hidden) stop(); else start(); });
    start();
  }


  /* ------------------------------------------------------------------
     4. PROJECT FLIP CARDS
     On desktop the back slides up on hover/focus (pure CSS). On touch
     screens there is no hover, so a tap toggles the card instead.
     Links inside the card still work normally.
     ------------------------------------------------------------------ */
  var cards = document.querySelectorAll(".project-card");
  var canHover = window.matchMedia("(hover: hover)").matches;

  if (!canHover) {
    cards.forEach(function (card) {
      card.addEventListener("click", function (e) {
        if (e.target.closest("a")) return;
        var willOpen = !card.classList.contains("is-flipped");
        cards.forEach(function (c) { c.classList.remove("is-flipped"); });
        card.classList.toggle("is-flipped", willOpen);
      });
    });
  }
  // Keyboard: Enter / Space also flips the card
  cards.forEach(function (card) {
    card.addEventListener("keydown", function (e) {
      if ((e.key === "Enter" || e.key === " ") && e.target === card) {
        e.preventDefault();
        card.classList.toggle("is-flipped");
      }
    });
  });


  /* ------------------------------------------------------------------
     5. SCROLL-REVEAL ANIMATION
     Anything with class="reveal" fades up the first time it is seen.
     ------------------------------------------------------------------ */
  var items = document.querySelectorAll(".reveal");
  if ("IntersectionObserver" in window && !reduceMotion) {
    var io = new IntersectionObserver(function (entries, obs) {
      entries.forEach(function (en) {
        if (en.isIntersecting) { en.target.classList.add("is-visible"); obs.unobserve(en.target); }
      });
    }, { threshold: 0.08 });
    items.forEach(function (el, i) {
      el.style.transitionDelay = (i % 3) * 80 + "ms";
      io.observe(el);
    });
  } else {
    items.forEach(function (el) { el.classList.add("is-visible"); });
  }


  /* ------------------------------------------------------------------
     6. CONTACT FORM
     Sends the message to lauramcrowley00@gmail.com via Web3Forms
     (a free form-to-email service) without leaving the page.

     The access key below is meant to be public; it can only be used to
     send email to your own address. If sending fails or takes longer
     than 20 seconds, a pre-filled "email me directly" link is shown so
     no message is lost. Messages match the original Brizy form.
     ------------------------------------------------------------------ */
  var ACCESS_KEY = "3f9b6e0a-a0d4-462b-ab7f-48bd919bf64d";
  var RECIPIENT = "lauramcrowley00@gmail.com"; // only used for the "email me directly" fallback
  var form = document.getElementById("contact-form");
  var statusEl = document.getElementById("form-status");

  function showStatus(type, html) {
    statusEl.className = "form-status" + (type ? " is-" + type : "");
    statusEl.innerHTML = html;
  }
  function esc(s) {
    return s.replace(/[&<>"']/g, function (c) {
      return { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c];
    });
  }

  if (form && statusEl) {
    form.addEventListener("submit", function (e) {
      e.preventDefault();
      if (form.elements["botcheck"].checked) return; // spam trap: bots tick the hidden box

      var email = form.elements["email"].value.trim();
      var message = form.elements["message"].value.trim();
      if (!email || !message) { showStatus("error", "Please fill in the required fields"); return; }
      if (!form.elements["email"].checkValidity()) {
        showStatus("error", "Please enter a valid email address (e.g., name@example.com)");
        return;
      }

      var button = form.querySelector("button[type='submit']");
      var data = {
        access_key: ACCESS_KEY,
        subject: form.elements["subject"].value,
        from_name: form.elements["from_name"].value,
        name: form.elements["name"].value.trim(),
        email: email,
        message: message
      };

      button.disabled = true;
      button.textContent = "Sending…";
      showStatus("", "");

      // Give up after 20 seconds so the button can never stay stuck on "Sending…"
      var controller = new AbortController();
      var timeout = setTimeout(function () { controller.abort(); }, 20000);

      fetch("https://api.web3forms.com/submit", {
        method: "POST",
        headers: { "Content-Type": "application/json", "Accept": "application/json" },
        body: JSON.stringify(data),
        signal: controller.signal
      })
        .then(function (res) { return res.json(); })
        .then(function (r) {
          if (!r.success) {
            console.warn("Web3Forms said:", r.message || r); // visible in the browser console (F12)
            throw new Error("rejected");
          }
          form.reset();
          showStatus("success", "Your email was sent successfully");
        })
        .catch(function (err) {
          console.warn("Contact form error:", err);
          var mailto = "mailto:" + RECIPIENT +
            "?subject=" + encodeURIComponent("Message from " + (data.name || "website visitor")) +
            "&body=" + encodeURIComponent(data.message + "\n\n" + data.name + "\n" + data.email);
          showStatus("error", "Your email was not sent. <a href=\"" + esc(mailto) + "\">Click here to email me directly</a>.");
        })
        .finally(function () { clearTimeout(timeout); button.disabled = false; button.textContent = "Send"; });
    });
  }
})();
