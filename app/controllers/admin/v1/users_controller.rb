module Admin::V1
  class UsersController < ApiController
    
    def index
      @users = User.where.not(id: @current_user.id)
    end
  end
end
