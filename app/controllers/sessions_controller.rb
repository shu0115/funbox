class SessionsController < ApplicationController
  skip_before_action :authenticate

  # ログイン
  def callback
    ActiveRecord::Base.transaction do
      auth = request.env['omniauth.auth']
      authentication = Authentication.find_by(provider: auth['provider'], uid: auth['uid']) || Authentication.create_with_omniauth!(auth)
      authentication.auth_update(auth)

      # ユーザ取得or作成
      user = User.find_by(id: authentication.user_id) || User.create_with_auth!(authentication)

      session[:user_id] = user.id
    end

    # 保管URLへリダイレクト
    unless session[:request_url].blank?
      redirect_to session[:request_url]
      session[:request_url] = nil
      return
    end

    # redirect_to :root and return
    redirect_to playlists_path and return
  end

  # ログアウト
  def destroy
    session[:user_id] = nil

    redirect_to :root and return
  end

  # ログインエラー
  def failure
    flash[:alert] = 'Auth Failure'

    redirect_to :root and return
  end
end
