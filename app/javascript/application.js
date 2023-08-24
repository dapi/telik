// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "channels"
import "./clipboard"
import * as bootstrap from 'bootstrap'

//import hljs from 'highlightjs/lib/core';
//import html from 'highlightjs/lib/languages/html';

//// Then register the languages you need
//hljs.registerLanguage('html', html);

//= stylesheet_link_tag 'https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.8.0/styles/default.min.css'
//= javascript_include_tag 'https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.8.0/highlight.min.js'
//= javascript_include_tag 'https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.8.0/languages/html.min.js'
//javascript:
  //hljs.highlightAll();

const onReady = function() {
  var option = { delay: 3000 }
  var toastElList = [].slice.call(document.querySelectorAll('.toast'))
  var toastList = toastElList.map(function (toastEl) {
    var toast = new bootstrap.Toast(toastEl, option)
    toast.show()
  })

  var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
  var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl)
  })

}

document.addEventListener("turbo:load", onReady);

// Вынужден добавить из-за глюка в popper
window.process = { env: { NODE_ENV: 'production' } };
