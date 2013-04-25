# enable :sessions

get '/' do
  puts session[:user]
  if session[:user]
    redirect to '/secret'
  end
  erb :index
end

post '/secret' do  
  session[:user] ||= nil
  user = User.authenticate(params[:email], params[:password])

  if user
    session[:user] = user.name
    @name = session[:user]
    erb :secret
  else
    @error_message = "Oops, you didn't enter the right password or email"  
    erb :index
  end
end

get '/secret' do
  @name = session[:user] 
  if @name
    erb :secret
  else
    redirect to '/'
  end
end

get '/create' do
  erb :create
end

post '/new_account' do
  user = User.create(params)
  if user.valid?
    erb :secret
  else
    @error_message = "You fucked up!"
    erb :create
  end
end

get '/logout' do
  session[:user] = nil
  redirect to '/'
end