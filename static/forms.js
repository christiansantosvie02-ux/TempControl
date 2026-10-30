/* TempControl — foco em mensagens e estado de envio. */
(function () {
  var msg = document.getElementById("msg");
  if (msg) {
    msg.scrollIntoView({ block: "center" });
    msg.focus({ preventScroll: true });
  }

  document.querySelectorAll("form").forEach(function (f) {
    f.addEventListener("submit", function (e) {
      if (e.defaultPrevented) return;
      var b = f.querySelector("[type=submit]");
      if (!b || b.disabled) return;
      b.dataset.t = b.innerHTML;
      setTimeout(function () {
        b.disabled = true;
        b.textContent = "Enviando…";
      }, 0);
    });
  });

  /* Restaura o botão ao voltar pelo histórico (bfcache) */
  window.addEventListener("pageshow", function (e) {
    if (!e.persisted) return;
    document.querySelectorAll("[type=submit][data-t]").forEach(function (b) {
      b.disabled = false;
      b.innerHTML = b.dataset.t;
    });
  });
})();
