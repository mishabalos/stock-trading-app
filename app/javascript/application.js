// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import { createIcons, icons } from 'lucide'

// This creates all icons after the page loads
document.addEventListener('turbo:load', () => {
  createIcons({icons})
})