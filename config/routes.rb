EnvelopeBudgeter::Application.routes.draw do
  devise_for :users, controllers: { 
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  root to: "users#show"
end
