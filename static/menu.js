/* TempControl — menu hambúrguer (abre/fecha o painel de páginas). */
(function () {
  var toggle = document.querySelector(".menu-toggle");
  var panel = document.getElementById("menu-paginas");
  if (!toggle || !panel) return;

  function setOpen(open) {
    panel.hidden = !open;
    toggle.setAttribute("aria-expanded", open ? "true" : "false");
    toggle.setAttribute("aria-label", open ? "Fechar menu" : "Abrir menu");
  }

  toggle.addEventListener("click", function () {
    setOpen(panel.hidden);
  });

  /* Fecha ao clicar em um link do painel */
  panel.addEventListener("click", function (e) {
    if (e.target.closest("a")) setOpen(false);
  });

  /* Fecha ao clicar fora */
  document.addEventListener("click", function (e) {
    if (!panel.hidden && !panel.contains(e.target) && !toggle.contains(e.target)) {
      setOpen(false);
    }
  });

  /* Fecha com Esc e devolve o foco ao botão */
  document.addEventListener("keydown", function (e) {
    if (e.key === "Escape" && !panel.hidden) {
      setOpen(false);
      toggle.focus();
    }
  });
})();