class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password]) #⓵userのメールとパスワードが一致する場合 =  一致するユーザーが存在する場合
      log_in user   # session[:user_id] = 1 → user_id = 1 の情報をブラウザに保存させる (sessionに代入された値はブラウザに保存される) 
                    # session[:user_id] = user.id
                    # ⓶その存在するユーザーのid!?を変数sessionに代入する事で、ログインユーザーの情報が保持され続ける
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      flash[:success] = 'ログインしました。'
      redirect_to user
    else
      flash.now[:danger] = 'メールアドレスとパスワードの情報が一致しませんでした。'
      render 'new'
    end
  end
  
  def destroy
    # ログイン中の場合のみログアウト処理を実行します。
    log_out if logged_in?
    flash[:success] = 'ログアウトしました。'
    redirect_to root_url
  end
  
end
