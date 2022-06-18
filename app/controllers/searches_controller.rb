class SearchesController < ApplicationController
  def search
    if params[:name_key]
      @users = User.name('name LIKE?', "%#{params[:name_kye]}%")
    else
      @users = User.all
    end
  end
end
