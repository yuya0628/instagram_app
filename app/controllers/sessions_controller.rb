class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new; end

  def create
    @user = login(params[:email], params[:password])

    if @user
      redirect_to(root_path, flash: { notice: 'ログインしました' })
    else
      flash[:alert] = 'ログイン失敗'
      render :new
    end
  end

  def destroy
    logout
    redirect_to(login_path, flash: { alert: 'ログアウトしました' })
  end
end
