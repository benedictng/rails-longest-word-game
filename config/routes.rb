Rails.application.routes.draw do
  get 'game/new', to: "game#new"
  post 'game/score', to: "game#score"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
