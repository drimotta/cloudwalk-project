Rails.application.routes.draw do
  resources :gh_users, only: %i[index show], param: :name do
    put :fetch_repos, on: :member
  end
end
