class UsersController < ApplicationController
  before_action :set_user

  def show
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
    @title = "#{@user.name}がフォローしているユーザー"
    @users = @user.following.page(params[:page]).with_attached_image
    render 'show_follow'
  end

  def followers
    @title = "#{@user.name}のフォロワー"
    @users = @user.followers.page(params[:page]).with_attached_image
    render 'show_follow'
  end

  def map
    prefectures = ["都道府県"]
    @user.events.done.each do |event|
      prefectures << event.prefecture
    end
    gon.prefectures = prefectures.group_by(&:itself).map{ |key, value| [key, value.count] }
    gon.prefectures[0][1] = "回数" 
  end

  private

  def set_user
    @user  = User.find(params[:id])
  end
end
