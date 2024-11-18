# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "lucide", to: "https://ga.jspm.io/npm:lucide@0.263.0/dist/esm/lucide.js"
pin_all_from "app/javascript/custom", under: "custom"