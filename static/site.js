/* TempControl — microinterações: sombra do cabeçalho, revelar ao rolar e destaque da seção atual. */
(function () {
  var header = document.querySelector(".site-header");
  function onScroll() {
    if (header) header.classList.toggle("is-scrolled", window.scrollY > 8);
  }
  onScroll();
  window.addEventListener("scroll", onScroll, { passive: true });

  var els = [].slice.call(document.querySelectorAll(".reveal"));
  function show(el) { el.classList.add("is-visible"); }

  if (!("IntersectionObserver" in window)) {
    els.forEach(show);
    return;
  }

  var reveal = new IntersectionObserver(function (entries) {
    entries.forEach(function (e) {
      if (e.isIntersecting) { show(e.target); reveal.unobserve(e.target); }
    });
  }, { rootMargin: "0px 0px -8% 0px", threshold: 0.08 });
  els.forEach(function (el) { reveal.observe(el); });

  /* Destaca no menu a seção que está na tela (home) */
  var links = [].slice.call(document.querySelectorAll('.site-nav a[href*="#"]'));
  if (!links.length) return;

  var map = {};
  links.forEach(function (a) { map[a.hash.slice(1)] = a; });

  var spy = new IntersectionObserver(function (entries) {
    entries.forEach(function (e) {
      if (!e.isIntersecting) return;
      links.forEach(function (a) { a.removeAttribute("aria-current"); });
      var a = map[e.target.id];
      if (a) a.setAttribute("aria-current", "location");
    });
  }, { rootMargin: "-45% 0px -50% 0px" });

  Object.keys(map).forEach(function (id) {
    var s = document.getElementById(id);
    if (s) spy.observe(s);
  });
})();