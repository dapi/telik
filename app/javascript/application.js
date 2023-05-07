// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from 'bootstrap'

const onReady = function() {
  console.log('onReady')
  const option={}
  const toastElList = document.querySelectorAll('.toast')
  const toastList = [...toastElList].map(toastEl => new bootstrap.Toast(toastEl, option))
  toastList.forEach(toastEl => toastEl.show())
}

document.addEventListener("turbo:load", onReady)
