/* TempControl — "Ver mais": exibição gradual de listas (cartões ou linhas de tabela).
 *
 * Uso no HTML:
 *   - contêiner da lista:  id="minha-lista" data-passo="5"
 *   - cada item:           data-item  (itens extras já vêm com a classe is-oculta)
 *   - botão:               data-ver-mais="minha-lista"
 *   - contador (opcional): .ver-mais__status, irmão do botão
 */
(function () {
  var botoes = document.querySelectorAll("[data-ver-mais]");

  Array.prototype.forEach.call(botoes, function (botao) {
    var lista = document.getElementById(botao.getAttribute("data-ver-mais"));
    if (!lista) return;

    var passo = parseInt(lista.getAttribute("data-passo"), 10) || 5;
    var itens = Array.prototype.slice.call(lista.querySelectorAll("[data-item]"));
    var area = botao.closest(".ver-mais");
    var status = area ? area.querySelector(".ver-mais__status") : null;

    var visiveis = itens.filter(function (el) {
      return !el.classList.contains("is-oculta");
    }).length;

    function atualizar() {
      var total = itens.length;
      if (status) status.textContent = "Mostrando " + visiveis + " de " + total;
      botao.hidden = visiveis >= total; /* sem mais itens: esconde o botão */
    }

    botao.addEventListener("click", function () {
      var primeiroNovo = itens[visiveis];
      var limite = Math.min(visiveis + passo, itens.length);

      for (var i = visiveis; i < limite; i++) {
        itens[i].classList.remove("is-oculta");
      }
      visiveis = limite;
      atualizar();

      /* Leva o foco ao primeiro item novo (teclado e leitor de tela),
         inclusive quando o botão desaparece ao fim da lista. */
      if (primeiroNovo) {
        primeiroNovo.setAttribute("tabindex", "-1");
        primeiroNovo.focus();
      }
    });

    atualizar();
  });
})();