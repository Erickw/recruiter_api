Rails.application.routes.draw do
  post 'signin', to: 'authentication#signin'
  post 'signup', to: 'authentication#signup'
  post 'reset_password', to: 'authentication#reset_password'

  namespace :recruiter do
    resources :recruiters
    resources :jobs
  end

  namespace :public do
    resources :submissions
    resources :jobs, only: [:index, :show]
  end
end
