class UsersController < ApplicationController
    before_action :set_user, only: [:edit, :update, :show]
    before_action :require_same_user, only: [:edit, :update, :destroy]
    before_action :require_admin, only: [:destroy]

    def index
        @users = User.paginate(page: params[:page], per_page: 5)
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            session[:user_id] = @user.id
            flash[:success] = "Welcome to the Alpha Blog #{@user.username}"
            redirect_to user_path(@user)
        else
            render 'new'
        end
    end

    def edit
    end

    def update
        if @user.update(user_params)
            flash[:success] = "Your Account was successfully edited"
            redirect_to articles_path
        else
            render 'new'
        end
    end

    def show
        @user_articles =@user.articles.paginate(page: params[:page], per_page: 5)
    end

    def destroy
        @user = User.find(params[:id])
        @user.destroy
        flash[:danger] = "User and Article was successfully deleted"
        redirect_to users_path
    end

    private

    def set_user
         @user = User.find(params[:id])
    end

    def require_admin
        if current_user != @user and !current_user.admin?
            flash[:danger] = "Only admins canperform that action"
        redirect_to root_path
        end
    end

    def user_params
        params.require(:user).permit(:username, :email, :password)
    end

    def require_same_user
        if current_user != @user and !current_user.admin?
            flash[:danger] = "You can only edit your own information"
        redirect_to root_path
        end
    end
end
