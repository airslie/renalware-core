# frozen_string_literal: true

# Some safety-net routes in case we happen to fall through the above routes without a match.
# For example, redirect to the HD dashboard if they hit just /hd/
# In theory we should only ever hit these routes if the user manually edits/enters the URL.
get "/patients/:id/hd", to: redirect("/patients/%{id}/hd/dashboard")
get "/patients/:id/pd", to: redirect("/patients/%{id}/pd/dashboard")
get "/patients/:id/transplants", to: redirect("/patients/%{id}")
get "/patients/:id/transplants/donor",
    to: redirect("/patients/%{id}/transplants/donor/dashboard")
get "/patients/:id/transplants/recipient",
    to: redirect("/patients/%{id}/transplants/recipient/dashboard")
