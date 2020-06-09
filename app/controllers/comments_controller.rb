class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    ticket = Ticket.find(params[:ticket_id])
    comment = ticket.comments.build(comment_params)
    comment.user_id = current_user.id
    if comment.save
      ticket.create_notification_comment!(current_user, comment.id)
      flash[:success] = "コメントしました"
      redirect_back(fallback_location: ticket_path(ticket))
    else
      flash[:success] = "コメントできませんでした"
      redirect_back(fallback_location: ticket_path(ticket))
    end
  end

  def destroy
    ticket = Ticket.find(params[:ticket_id])
    comment = ticket.comments.find(params[:id])
    comment.destroy
    redirect_back(fallback_location: ticket_path(ticket))
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
