class ApplicationController < ActionController::Base

  before_action :set_search_posts_form

  protect_from_forgery with: :null_session #CSRF保護が有効になってるらしくてログインできずにエラー。CSRF保護を無効にする記述

  before_action :require_login # sorceryが作成するメソッド。ログインしてない時not_authenticatedメソッドを発火する

  add_flash_types :success, :info, :warning, :danger



  private

  def not_authenticated
    redirect_to login_url, warning: 'ログインしてください'
  end

  # ヘッダー部分（=共通部分）に検索フォームを置くのでApplicationControllerに実装する
  def set_search_posts_form
    @search_form = SearchPostsForm.new(search_post_params)
  end

  def search_post_params
    params.fetch(:q,{}).permit(:body, :comment_body, :username)
  end


end
