class UsersController < ApplicationController
    before_action :ensure_admin, only: [:index]
    before_action :ensure_user, only: [:show]
    def index
        @users = User.all
    end
    def new
        @user = User.new
    end
    def password
        @user = User.find(params[:id])
    end
    def update
        @user = User.find(params[:id])
        if (@user.update(user_params))
            flash[:success] = "The password was updated. "
            redirect_to user_path(@user)
        else
            render :new
        end
    end
    def create
        @user = User.new(user_params)
        @user.level = 1
        if(@user.save)
            log_in(@user)
            flash[:success] = "Welcome to Matt's Movies!"
            redirect_to user_path(@user)
        else
            render :new
        end
    end

    def show
        @user = User.find(params[:id])
    end

    private

    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    def ensure_admin
        if logged_in?
            if current_user.level == 3
            else
                 flash[:success] =  'You are not an Admin User'
                redirect_to user_path(current_user.id)
            end
        else
                flash[:success] =  'You are not an Admin User, please log in.'
                redirect_to login_path
        end
    end
    def ensure_user
        if logged_in?
            if current_user.id == params[:id].to_i || current_user.level == 3
            else
                 flash[:success] =  'That was not your account.'
                redirect_to user_path(current_user.id)
            end
        else
            redirect_to login_path
        end
    end
end
