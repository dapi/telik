import * as bootstrap from 'bootstrap'
const onReady = function() {

  var tooltip="Скопировать в буфер";
  var g = `<div class="bd-clipboard"><button type="button" class="btn-clipboard" title="${tooltip}">Копировать</button></div>`;
  document.querySelectorAll('div.highlight').forEach(function(a) {
    a.insertAdjacentHTML('beforebegin', g)
  });
  document.querySelectorAll('.btn-clipboard').forEach(function(a) {
    var b = new bootstrap.Tooltip(a);
    a.addEventListener('mouseleave', function() {
      b.hide()
    })
  });
  var d = new ClipboardJS('.btn-clipboard', {
    target: function(a) {
      return a.parentNode.nextElementSibling
    }
  });
  d.on('success', function(a) {
    var b = bootstrap.Tooltip.getInstance(a.trigger);
    a.trigger.setAttribute('data-bs-original-title', 'Скопировано!'),
      b.show(),
      a.trigger.setAttribute('data-bs-original-title', tooltip),
      a.clearSelection()
  });
  d.on('error', function(a) {
    var b = /mac/i.test(navigator.userAgent) ? '\u2318' : 'Ctrl-',
      c = 'Press ' + b + 'C to copy',
      d = bootstrap.Tooltip.getInstance(a.trigger);
    a.trigger.setAttribute('data-bs-original-title', c),
      d.show(),
      a.trigger.setAttribute('data-bs-original-title', tooltip)
  });
}
document.addEventListener("turbo:load", onReady);
