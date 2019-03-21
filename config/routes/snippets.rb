# frozen_string_literal: true

resources :snippets, controller: "snippets/snippets", except: :show do
  resources :snippet_clones,
            controller: "snippets/snippet_clones",
            only: :create, as: :clones
  resources :snippet_invocations,
            controller: "snippets/snippet_invocations",
            only: :create,
            as: :invocations
end
