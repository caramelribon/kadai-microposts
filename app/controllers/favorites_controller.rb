class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    micropost = Micropost.find(params[:micropost_id])
    current_user.favorite(micropost)
    flash[:success] = 'お気に入りにしました。'
    redirect_back fallback_location: root_path
  end

  def destroy
    micropost = current_user.favorites.find_by(params[:id]).micropost
    current_user.unfavorite(micropost)
    flash[:success] = 'お気に入りを解除しました。'
    redirect_back fallback_location: root_path
  end
end
