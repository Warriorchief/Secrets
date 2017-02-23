class UserController < ApplicationController
  def index
    flash.clear
  end

  def already
    render('already.html.erb')
  end

  def register
      @new_user = User.new(name:params[:name],email:params[:email],password:params[:password])
      if @new_user.save
        session[:user_id]=@new_user.id
        flash[:success]=["Successfully registered, now please sign in!"]
        redirect_to('/already')
      else
        flash[:error]=@new_user.errors.full_messages
        redirect_to '/'
      end
  end

  def login
    @new_guy=User.find_by_email(params[:email])
    if @new_guy and @new_guy.authenticate(params[:logpass])
      session[:user_id]=@new_guy.id
      flash[:success]=["Successfully logged in!"]
      redirect_to("/profile/#{@new_guy.id}")
    else
      #flash[:error]=["Invalid credentials!"] #DON'T validate login info!
      redirect_to('/already')
    end
  end

  def display
    @user_id = session[:user_id]
    @secrets = Secret.all
    render 'display.html.erb'
  end

  def profile
    @user = User.find(params[:id])
    @my_secrets = @user.secrets
    @secrets_liked_by_me=@user.secrets_liked
    render 'profile.html.erb'
  end

  def edit_profile
    @user = User.find(session[:user_id])
    render 'editprofile.html.erb'
  end

  def update_profile
    @user = User.find(params[:id])
    if @user.update user_params # Check out user_params private method below
      flash[:success] = ["Updated the information of user with the id #{params[:id]}"]
      redirect_to("/profile/#{@user.id}")
    else
      flash[:error] = @user.errors.full_messages # This will show all the errors
      redirect_to("/edit_profile/#{@user.id}")
    end
  end

  def new_secret
    @user_id=session[:user_id]
    @new_secret=Secret.new(content:params[:content],user_id:session[:user_id])
    if @new_secret.save
      flash[:success]=["Secret created!"]
      redirect_to("/profile/#{@user_id}")
    else
      flash[:error]=@new_secret.errors.full_messages
      redirect_to("/profile/#{@user_id}")
    end
  end

  def delete_secret
    @user_id=session[:user_id]
    Secret.destroy(params[:id])
    flash[:success]=["Secret destroyed!"]
    redirect_to("/profile/#{@user_id}")
  end

  def like
    @user_id=session[:user_id]
    Like.create(secret_id:params[:id],user_id:@user_id)
    flash[:success]=["New Like created!"]
    redirect_to("/display/#{@user_id}")
  end

  def unlike
    @user_id=session[:user_id]
    Like.where(secret_id:params[:id],user_id:@user_id)[0].destroy
    flash[:success]=["Like changed to an UNLIKE!"]
    redirect_to("/display/#{@user_id}")
  end

  def logout
    reset_session
    redirect_to('/')
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

end
