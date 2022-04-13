# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "https://ga.jspm.io/npm:@hotwired/stimulus@3.0.1/dist/stimulus.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "trix"
pin "@rails/actiontext", to: "actiontext.js"
pin "stimulus_reflex", to: "https://ga.jspm.io/npm:stimulus_reflex@3.5.0-pre9/dist/stimulus_reflex.min.js"
pin "@rails/actioncable", to: "https://ga.jspm.io/npm:@rails/actioncable@6.1.5/app/assets/javascripts/action_cable.js"
pin "cable_ready", to: "https://ga.jspm.io/npm:cable_ready@5.0.0-pre9/dist/cable_ready.min.js"
pin "morphdom", to: "https://ga.jspm.io/npm:morphdom@2.6.1/dist/morphdom.js"
