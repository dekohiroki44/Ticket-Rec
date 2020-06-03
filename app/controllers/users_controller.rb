class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @done_events = @user.events.done.page(params[:page]).with_attached_images.includes([:like_users])
    @upcomming_events = @user.events.upcomming.page(params[:page]).with_attached_images.includes([:like_users])
    @unsolved_events = @user.events.unsolved.page(params[:page]).with_attached_images.includes([:like_users])
    if current_user != @user
      @done_events = @done_events.release
      @upcomming_events = @upcomming_events.release
      @unsolved_events = @unsolved_events.release
    end
  end

  def following
    @user  = User.find(params[:id])
    @title = "#{@user.name}がフォローしているユーザー"
    @users = @user.following.page(params[:page]).with_attached_image
    render 'show_follow'
  end

  def followers
    @user  = User.find(params[:id])
    @title = "#{@user.name}のフォロワー"
    @users = @user.followers.page(params[:page]).with_attached_image
    render 'show_follow'
  end

  def map
    @user = User.find(params[:id])
    places = @user.events.pluck(:place)
    places.each do |place|
      
  end
end
