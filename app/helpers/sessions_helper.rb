module SessionsHelper
  
  # 引数に渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # 現在ログイン中のユーザーを返す(ただし、いる場合のみ)
  def current_user #訳：現在のユーザー
    if session[:user_id] #セッションに(ブラウザに保存された!?)ユーザーIDが存在するかどうか？(ログイン中のユーザー) →trueなら下へ、nilならﾒｿｯﾄﾞは終了しnilを返す
      @current_user ||= User.find_by(id: session[:user_id])
                      #  ↓            ↓            ↓
                      #usersﾃｰﾌﾞﾙの  idｶﾗﾑから  ﾛｸﾞｲﾝ中のﾕｰｻﾞｰidと等しいidを取得する
    end
  end
  
  # 渡されたユーザーがログイン済みユーザーであればtrueを返す
  def current_user?(user)
    user == current_user
  end
  
  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
    #否定演算子!を使ってる(trueならfalseに、falseならtrueになる)
    #訳)ﾛｸﾞｲﾝ中のﾕｰｻﾞｰは存在しませんか?
    #存在しない=trueがfalseに、存在する=falseがtrueに
  end
  
  def log_out
    session.delete(:user_id) #セッションからユーザーidを削除
    @current_user = nil #上記でセッションから削除しても、current_userメソッドによって@current_userに代入されたユーザーオブジェクトは削除されてない為、これで削除
  end
  
  # 記憶しているURL(もしくはﾃﾞﾌｫﾙﾄ値)にリダイレクトする
  def redirect_back_or(default)
    redirect_to(session[:fowarding_url] || default) # fowarding = 転送
    session.delete(:forwarding_url)
  end
  
  # アクセスしようとしたURLを記憶する
  def store_location # アクセスした場所(location)を格納(store)する
    session[:forwarding_url] = request.original_url if request.get?
  end
  
end