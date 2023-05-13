// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "channels"
import * as bootstrap from 'bootstrap'

const onReady = function() {
  var option = { delay: 3000 }
  var toastElList = [].slice.call(document.querySelectorAll('.toast'))
  var toastList = toastElList.map(function (toastEl) {
    var toast = new bootstrap.Toast(toastEl, option)
    toast.show()
  })
}

document.addEventListener("turbo:load", onReady)
