Rails.application.routes.draw do
  root 'searches#display'
  get 'api/v1', to: 'api/v1/api#search', defaults: { format: :json }
end
