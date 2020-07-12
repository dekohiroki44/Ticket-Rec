class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :destroy, :following, :followers]
  before_action :set_user
  before_action :admin_user, only: :destroy

  def show
    gon.map_data = @user.prefecture_data
    @done_tickets = @user.tickets.done.page(params[:page]).
      with_attached_images.includes([:like_users])
    @upcomming_tickets = @user.tickets.upcomming.page(params[:page]).
      with_attached_images.includes([:like_users])
    @unsolved_tickets = @user.tickets.unsolved.page(params[:page]).
      with_attached_images.includes([:like_users])
    if current_user != @user
      @done_tickets = @done_tickets.release
      @upcomming_tickets = @upcomming_tickets.release
      @unsolved_tickets = @unsolved_tickets.release
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    flash[:success] = "#{user.naem}を削除しました"
    redirect_to root_url
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

  private

  def set_user
    @user = User.find(params[:id])
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
