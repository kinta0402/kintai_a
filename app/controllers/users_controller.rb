class UsersController < ApplicationController
  
  # beforeアクション = Usersコントローラー内で定義されている全てのアクションが実行される前にbefore_actionが実行される
  # なぜbefore_actionするのか？ ⇒ログインしていないユーザーが、ユーザー情報編集や、更新を出来ないようにする為！！
  before_action :logged_in_user, only: [:index, :edit, :update]
  # editアクションとupdateアクションが実行される直前のみ、logged_in_userを実行する
  
  before_action :correct_user,   only: [:edit, :update]
  
  before_action:admin_user,      only: [:destroy, :edit_basic_infodestroy, :edit_basic_info, :update_basic_info, :index]
  
  def index # 全てのユーザーを表示する
    @users = User.paginate(page: params[:page]).search(params[:search])
  end
  
  def show
    # 例) /users/1 でｱｸｾｽ時、params[:id] は 1 に置き換わる/User.find(1)になる
    @user = User.find(params[:id])
    # URLから直接ページ移動するのを防止
    redirect_to(root_url) unless @user == current_user or current_user.admin?
    @first_day = first_day(params[:first_day])
    @last_day = @first_day.end_of_month
    (@first_day..@last_day).each do |day|
      unless @user.attendances.any? {|attendance| attendance.worked_on == day}
        record = @user.attendances.build(worked_on: day)
        record.save
      end
    end
    @dates = user_attendances_month_date
    @worked_sum = @dates.where.not(started_at: nil).count
  end
  
  def new
    @user = User.new #新規作成されたUserオブジェクトをインスタンス変数に代入します
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "ユーザーの新規作成に成功しました"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    # @user = User.find(params[:id])  ※before_actionにてeditアクションが実行される前に@userを定義してる為、削除
  end
  
  def update
    # @user = User.find(params[:id]) ※before_actionにてudpateアクションが実行される前に@userを定義してる為、削除
    if @user.update_attributes(user_params)
          #trueの場合、属性をアップデートする = ユーザー情報を更新する
      flash[:success] = "ユーザー情報を更新しました"
      redirect_to @user
    else
      render 'edit' # falseの場合、編集ページを再度表示する
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "削除しました。"
    redirect_to users_url
  end
  
  def edit_basic_info
    @user = User.find(params[:id])
  end
  
  def update_basic_info
    @user = User.find(params[:id])
    if @user.update_attributes(basic_info_params)
      flash[:success] = "基本情報を更新しました。"
      redirect_to @user
    else
      render 'edit_basic_info'
    end
  end
  
  def base_edit
  end
  
  
  private
  
  
    def user_params
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
    end
    
    def basic_info_params
      params.require(:user).permit(:basic_time, :work_time)
    end


    # beforeアクション
    
    # ログイン済みユーザーか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end
    
    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless @user == current_user #or current_user.admin?
    end
    
    
     # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
