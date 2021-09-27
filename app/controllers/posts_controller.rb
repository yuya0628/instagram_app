class PostsController < ApplicationController

  before_action :require_login, only: %i[new create edit update destroy]

  def new
    @post=Post.new
  end

  def create
    @post=current_user.posts.new(post_params) # ① @post = Post.new(post_params) ② @post.user_id = current_user.id でもおっけー
    if @post.save
      redirect_to post_path(@post),success:"投稿が完了しました" # flash[:notice]="投稿が完了しました"だとエラー
    else
      flash.now[:danger] = '投稿の更新に失敗しました'
      render :new
    end
  end

  def index
    @posts=Post.includes(:user).page(params[:page]).per(15).order(created_at: :desc)
  end

  def show
    @post=Post.find(params[:id])
    @comments = @post.comments.includes(:user).order(created_at: :desc)
    @comment = Comment.new

  end

  def edit
    @post=Post.find(params[:id])
  end

  def update
    @post=Post.find(params[:id])
    if @post.update(post_params)
       redirect_to post_path(@post),success:"更新しました"
    else
      flash.now[:danger] = '投稿の更新に失敗しました'
      render :edit
    end
  end

  def destroy
    post=Post.find(params[:id])
    post.destroy!
    redirect_to posts_path,success:"投稿を削除しました"
  end

  private

  def post_params
    params.require(:post).permit(:body,{images:[]})
  end

end
