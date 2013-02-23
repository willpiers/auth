class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
  		flash[:success] = "Signed In!"
  		redirect_to root_url
  	else
  		flash[:error] = "bad things happened"
  		render "new"
  	end
  end
end
