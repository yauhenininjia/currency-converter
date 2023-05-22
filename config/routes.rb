Rails.application.routes.draw do
  get :convert, to: 'converter#convert'
end
