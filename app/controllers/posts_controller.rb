class PostsController < ApplicationController

  before_action :require_login

  def new
    @post=Post.new
  end

  def create
    @post=current_user.posts.new(post_params) # ① @post = Post.new(post_params) ② @post.user_id = current_user.id でもおっけー
    if @post.save
      redirect_to post_path(@post),flash:{notice:"投稿が完了しました"} # flash[:notice]="投稿が完了しました"だとエラー
    else
      render :new
    end
  end

  def index
    @posts=Post.all
  end

  def show
    @post=Post.find(params[:id])
  end

  def edit
    @post=Post.find(params[:id])
  end

  def update
    @post=Post.find(params[:id])
    if @post.update(post_params)
       redirect_to post_path(@post),flash[:notice]="更新しました"
    else
      render :edit
    end
  end

  def destroy
    post=Post.find(params[:id])
    post.destroy!
    redirect_to posts_path,flash[:alert]="投稿を削除しました"
  end

  private

  def post_params
    params.require(:post).permit(:body,{images:[]})
  end

end
