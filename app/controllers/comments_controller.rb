class CommentsController < ApplicationController
  before_action :find_post
  before_action :find_comment, only: [:destroy, :edit, :update, :comment_owner ]
  before_action :comment_owner, only: [:destroy, :edit , :update]

  def create
    @comment = @post.comments.create(params[:comment].permit(:content, :image, :mp3))
    @comment.user_id = current_user.id
    if @comment.save
      (@post.users.uniq - [current_user]).each do |user|
        Notification.create(recipient: user, actor: current_user, action: "posted", notifiable: @comment)
      end
      redirect_to video_path(@post)
    else
      render 'chatrooms/show'
    end
  end

  def destroy
    @comment.destroy
    redirect_to video_path(@post)
  end

  def edit

  end

  def update
    if @comment.update(params[:comment].permit(:content, :image, :mp3))
      redirect_to pin_path(@post)
    else
      render 'edit'
    end
  end


  private

  def find_post
    @post = Video.find(params[:video_id])
  end
  def find_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_owner
    unless current_user.id == @comment.user_id
      flash[:notice] = "No"
      redirect_to @post
    end
  end
end
