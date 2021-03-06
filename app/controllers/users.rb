class Chitter < Sinatra::Base

  get '/users/new' do
    @user = User.new
    erb :'users/new'
  end

  post '/users' do
    @user = User.new(email: params[:email],
      password: params[:password],
      password_confirmation: params[:password_confirmation])
    if @user.save
      session[:user_id] = @user.id
      redirect to('/')
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :'users/new'
    end
  end

  get '/users/recover' do
    erb :'users/recover'
  end

  post '/users/recover' do
  user = User.first(email: params[:email])
  if user
    user.generate_token
    # SendRecoverLink.call(user) cant get this token to work
  end
  erb :'users/acknowledgment'
end

  get '/users/reset_password' do
    @user = User.find_by_valid_token(params[:token])
    if(@user)
      erb :'users/reset_password'
    else
      "Your token is invalid"
    end
  end

  patch '/users' do
   user = User.find_by_valid_token(params[:token])
   if user.update(password: params[:password], password_confirmation: params[:password_confirmation])
     redirect "/sessions/new"
   else
     flash.now[:errors] = user.errors.full_messages
     erb :'users/reset_password'
   end
 end

end
