/* TempControl — gráfico ilustrativo do hero: a linha sobe e desce continuamente,
   como uma leitura ao vivo. O valor grande e a mínima/média/máxima acompanham. */
(function () {
  var mock = document.querySelector(".mock");
  if (!mock) return;

  /* Respeita quem prefere menos movimento: o gráfico fica estático. */
  if (window.matchMedia && window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;

  var line = mock.querySelector(".mock__line");
  var area = mock.querySelector(".mock__area");
  var dot = mock.querySelector(".mock__dot");
  var valor = mock.querySelector(".mock__value");
  var stats = {
    min: mock.querySelector('[data-mock="min"]'),
    media: mock.querySelector('[data-mock="media"]'),
    max: mock.querySelector('[data-mock="max"]')
  };
  if (!line || !area || !dot) return;

  /* Pontos originais (coordenada y do SVG) e geometria do gráfico. */
  var BASE = [87.5, 84.5, 90.5, 83, 78.5, 86, 81.5, 75.5, 71, 77, 80, 83];
  var X0 = 20, PASSO_X = 30, FUNDO = 132;
  var AMPLITUDE = 6;           /* quanto cada ponto sobe/desce (unidades do SVG) */
  var Y_MIN = 54, Y_MAX = 106; /* mantém a linha dentro da faixa ideal (50–110) */
  var RAMPA_MS = 2000;         /* entra suavemente depois do desenho inicial */

  /* y = 50 ↔ −2 °C e y = 110 ↔ −6 °C (15 unidades por grau) */
  function paraCelsius(y) { return -2 - (y - 50) / 15; }
  function fmt(c) {
    return (c < 0 ? "\u2212" : "") + Math.abs(c).toFixed(1).replace(".", ",");
  }

  function calcular(t) {
    var k = Math.min(1, t / RAMPA_MS);
    k = k * k * (3 - 2 * k); /* suaviza a entrada */
    return BASE.map(function (b, i) {
      var y = b + k * AMPLITUDE * Math.sin(t * (0.0009 + (i % 4) * 0.00025) + i * 1.3);
      return Math.max(Y_MIN, Math.min(Y_MAX, y));
    });
  }

  function desenhar(ys) {
    var d = ys.map(function (y, i) {
      return (i ? "L" : "M") + (X0 + i * PASSO_X) + " " + y.toFixed(2);
    }).join(" ");
    var ultimo = ys.length - 1;
    line.setAttribute("d", d);
    area.setAttribute("d", d + " L" + (X0 + ultimo * PASSO_X) + " " + FUNDO + " L" + X0 + " " + FUNDO + " Z");
    dot.setAttribute("cy", ys[ultimo].toFixed(2));
  }

  function atualizarTextos(ys) {
    var temps = ys.map(paraCelsius);
    var soma = temps.reduce(function (a, b) { return a + b; }, 0);
    if (valor && valor.firstChild) valor.firstChild.nodeValue = fmt(temps[temps.length - 1]);
    if (stats.min) stats.min.textContent = fmt(Math.min.apply(null, temps)) + " °C";
    if (stats.media) stats.media.textContent = fmt(soma / temps.length) + " °C";
    if (stats.max) stats.max.textContent = fmt(Math.max.apply(null, temps)) + " °C";
  }

  /* Só anima enquanto o painel está na tela. */
  var visivel = true;
  if ("IntersectionObserver" in window) {
    new IntersectionObserver(function (e) {
      visivel = e[0].isIntersecting;
    }).observe(mock);
  }

  var inicio = null, ultimoTexto = 0;
  function quadro(agora) {
    window.requestAnimationFrame(quadro);
    if (!visivel) return;
    if (inicio === null) inicio = agora;

    var t = agora - inicio;
    var ys = calcular(t);
    desenhar(ys);

    /* Textos mudam menos vezes por segundo para ficarem legíveis. */
    if (agora - ultimoTexto > 400) {
      atualizarTextos(ys);
      ultimoTexto = agora;
    }
  }
  window.requestAnimationFrame(quadro);
})();