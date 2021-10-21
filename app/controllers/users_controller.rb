class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :followings, :followers]
  
  def index
    @pagy, @users = pagy(User.order(id: :desc), items: 25)
  end

  def show
    @user = User.find(params[:id])
    @pagy, @microposts = pagy(@user.microposts.order(id: :desc))
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = "ユーザを登録しました。"
      redirect_to @user
    else
      flash.now[:danger] = "ユーザの登録に失敗しました。"
      render :new
    end
  end
  
  #routes.rbで作成したfollowingsとfollowersのアクション
  def followings
    #loginしているuserのidを取得
    @user = User.find(params[:id])
    #そのuserがフォローしている人達を取得して、一覧表示
    @pagy, @followings = pagy(@user.followings)
    #フォローしている人たちの人数をカウント
    counts(@user)
  end
  
  def followers
    #loginしているuserのidを取得
    @user = User.find(params[:id])
    #そのuserがフォローしている人たちを取得して、一覧表示
    @pagy,@followers = pagy(@user.followers)
    #フォローしている人たちの人数をカウント
    counts(@user)
  end
  
  def likes
    #loginしているuserのidを取得
    @user = User.find(params[:id])
    #そのuserがフォローしている人たちを取得して、一覧表示
    @pagy,@likes = pagy(@user.favorited_micropsts.order(created_at: :desc))
    #フォローしている人たちの人数をカウント
    counts(@user)
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
