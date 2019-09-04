Rails.application.routes.draw do
  root 'static_pages#home'
  get  '/signup',   to: 'users#new'
  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/edit-basic-info/:id', to: 'users#edit_basic_info', as: :basic_info
  patch 'update-basic-info',  to: 'users#update_basic_info'
  get 'users/:id/attendances/:date/edit', to: 'attendances#edit', as: :edit_attendances #勤怠情報を編集するページ
  patch 'users/:id/attendances/:date/update', to: 'attendances#update', as: :update_attendances #勤怠情報を更新するページ
  resources :users do
    resources :attendances, only: :create
  end
  
  get '/base_edit', to: 'users#base_edit'
  get '/basic_infomation', to: 'users#basic_infomation'
  get '/working_users', to: 'users#working_users'
end