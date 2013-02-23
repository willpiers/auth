class SessionsController < ApplicationController
  def new
      if @code = params[:code]
        url = "https://graph.facebook.com/oauth/access_token?client_id=341074429336009&redirect_uri=http://localhost:3000/&client_secret=3ff6a4c21bfa861b9343a3e80428cbf6&code=#{@code}"
        a = open(url).read
        @access_token = a[13..-1] || a
        session[:access_token] = @access_token
      end
      if session[:access_token]
        @token = session[:access_token]
        @me = JSON.parse(open("https://graph.facebook.com/me?access_token=#{@token}").read) || {key: 'value'}
        @friends_hash = JSON.parse(open("https://graph.facebook.com/me/friends?access_token=#{@token}").read)
        @names = []
        @friends_hash['data'].each do |friend|
          @names << friend['name']
        end
      end
  end

  def create
  	user = User.authenticate(params[:email], params[:password])
  	if user
  		session[:user_id] = user.id
  		flash[:success] = "Signed In!"
  		redirect_to root_url
  	else
  		flash[:error] = "The Email or Password supplied is incorrect."
  		render 'new'
  	end
  end

  def destroy
  	reset_session
  	flash[:success] = "Signed Out"
  	redirect_to root_url
  end
end
