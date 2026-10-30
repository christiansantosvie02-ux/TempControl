/* Clientes: fallback de imagem e pop-up de imagem ampliada. */
(function () {
  function fb(img) {
    var f = img.dataset.fallback;
    if (f && img.getAttribute("src") !== f) img.src = f;
  }
  document.addEventListener("error", function (e) {
    if (e.target.tagName === "IMG") fb(e.target);
  }, true);
  document.querySelectorAll(".cliente-imagem img[data-fallback]").forEach(function (img) {
    if (img.complete && img.naturalWidth === 0) fb(img);
  });

  /* Ver mais: mostra N cards e libera +M a cada clique */
  var box = document.querySelector(".clientes-mais");
  var cards = [].slice.call(document.querySelectorAll(".clientes-grid .cliente-card"));
  if (box && cards.length) {
    var inicial = parseInt(box.dataset.inicial, 10) || 6;
    var passo = parseInt(box.dataset.passo, 10) || 3;
    var btn = box.querySelector(".clientes-mais__btn");
    var status = box.querySelector(".clientes-mais__status");
    var visiveis = Math.min(inicial, cards.length);

    function atualizar() {
      status.textContent = "Mostrando " + visiveis + " de " + cards.length + " empresas";
      if (visiveis >= cards.length) box.hidden = true;
    }

    if (cards.length > inicial) {
      cards.forEach(function (c, i) {
        if (i >= inicial) c.classList.add("is-oculto");
      });
      box.hidden = false;
      atualizar();

      btn.addEventListener("click", function () {
        var ate = Math.min(visiveis + passo, cards.length);
        var primeiro = cards[visiveis];
        for (var i = visiveis; i < ate; i++) {
          var c = cards[i];
          c.style.setProperty("--d", (i - visiveis) * 0.08 + "s");
          c.classList.remove("is-oculto");
          c.classList.add("is-novo");
          c.addEventListener("animationend", function (e) {
            e.currentTarget.classList.remove("is-novo");
          }, { once: true });
        }
        visiveis = ate;
        atualizar();
        /* Se o botão sumiu, leva o foco ao primeiro card novo */
        if (box.hidden) {
          var z = primeiro.querySelector(".cliente-zoom");
          if (z) z.focus({ preventScroll: true });
        }
      });
    }
  }

  /* Pop-up */
  var dlg = document.getElementById("lightbox");
  if (!dlg || typeof dlg.showModal !== "function") return;

  var big = dlg.querySelector(".lightbox__img");
  var cap = dlg.querySelector(".lightbox__caption");
  var root = document.documentElement;
  var opener = null;

  function open(btn) {
    var img = btn.querySelector("img");
    if (!img) return;
    opener = btn;
    big.src = img.currentSrc || img.src;
    big.alt = img.alt;
    cap.textContent = img.dataset.nome || "";
    root.classList.add("lightbox-aberto");
    dlg.showModal();
  }

  document.querySelectorAll(".cliente-zoom").forEach(function (btn) {
    btn.addEventListener("click", function () { open(btn); });
  });

  dlg.querySelector(".lightbox__close").addEventListener("click", function () {
    dlg.close();
  });

  /* Clique fora da imagem (no fundo escuro) fecha */
  dlg.addEventListener("click", function (e) {
    if (e.target === dlg) dlg.close();
  });

  dlg.addEventListener("close", function () {
    root.classList.remove("lightbox-aberto");
    big.removeAttribute("src");
    if (opener) opener.focus();
  });
})();