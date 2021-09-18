class ApplicationController < ActionController::Base

  protect_from_forgery with: :null_session #CSRF保護が有効になってるらしくてログインできずにエラー。CSRF保護を無効にする記述

  before_action :require_login # sorceryが作成するメソッド。ログインしてない時not_authenticatedメソッドを発火する

  protected

  def not_authenticated
    redirect_to login_url
  end
end
