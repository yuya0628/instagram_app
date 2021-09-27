class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user) # Login without credentials(認証なしでログインできるsorceryのメソッド。これがないと新規登録と同時にログインを要求される)
      redirect_to root_path,success:"ユーザーを作成しました"
    else
      flash.now[:alert]="ユーザーの作成に失敗しました"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name,:email, :password,:avatar)
  end
end
