/* TempControl — menu hambúrguer. */
(function () {
  var toggle = document.querySelector(".menu-toggle");
  var panel = document.getElementById("menu-paginas");
  if (!toggle || !panel) return;

  function setOpen(open) {
    panel.hidden = !open;
    toggle.setAttribute("aria-expanded", open ? "true" : "false");
  }

  toggle.addEventListener("click", function () {
    setOpen(panel.hidden);
  });

  panel.addEventListener("click", function (e) {
    if (e.target.closest("a")) setOpen(false);
  });

  document.addEventListener("click", function (e) {
    if (!panel.hidden && !panel.contains(e.target) && !toggle.contains(e.target)) {
      setOpen(false);
    }
  });

  document.addEventListener("keydown", function (e) {
    if (e.key === "Escape" && !panel.hidden) {
      setOpen(false);
      toggle.focus();
    }
  });

  /* Fecha quando o foco sai do menu (Tab) */
  document.querySelector(".site-header").addEventListener("focusout", function (e) {
    if (panel.hidden) return;
    var next = e.relatedTarget;
    if (next && !panel.contains(next) && !toggle.contains(next)) setOpen(false);
  });
})();
