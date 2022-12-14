# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"

# Active Storage https://api.rubyonrails.org/files/activestorage/README_md.html
pin "@rails/activestorage", to: "activestorage.esm.js"

# Custom JS
pin "my_script", to: "my_script.js", preload: true
