# frozen_string_literal: true

# Azure health-check sends requests like '/robots3455.txt' and if we raise an error it pollutes the
# logs so instead handle these by redirecting to the errors controller which will return
# a 404 (and display a 404 page)
get "/robots:id.txt", to: "system/errors#not_found", constraints: { id: /\d+/ }
