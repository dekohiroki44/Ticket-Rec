class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  
  def  create
    event = Event.find(params[:event_id])
    comment = event.comments.build(comment_params)
    comment.user_id = current_user.id
    if comment.save
      flash[:success] = "コメントしました"
      redirect_back(fallback_location: event_path(event))
    else
      flash[:success] = "コメントできませんでした"
      redirect_back(fallback_location: event_path(event))
    end
  end

  def destroy
    event = Event.find(params[:event_id])
    comment = event.comments.find(params[:id])
    comment.destroy
    redirect_back(fallback_location: event_path(event))
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
