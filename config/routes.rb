Rails.application.routes.draw do

  get '/' => 'user#index'

  get '/already' => 'user#already'

  post '/register' => 'user#register'

  post '/login' => 'user#login'

  get '/profile/:id' => 'user#profile'

  get '/display/:id' => 'user#display'

  post '/new_secret' => 'user#new_secret'

  post '/delete/:id' => 'user#delete_secret'

  get '/logout' => 'user#logout'

  post '/like/:id' => 'user#like'

  post '/unlike/:id' => 'user#unlike'

  get '/edit_profile/:id' => 'user#edit_profile'

  post '/update_profile/:id' => 'user#update_profile'

end
