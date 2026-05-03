# frozen_string_literal: true

module Admin
  class UsersController < BaseController
    before_action :set_user, only: %i[ show edit update ]

    def index
      authorize User
      @users = policy_scope(User).order(:role, :full_name)
    end

    def show
      authorize @user
    end

    def new
      @user = User.new(school: Current.school)
      authorize @user
    end

    def create
      @user = User.new(user_params.merge(school: Current.school))
      authorize @user
      generated = SecureRandom.alphanumeric(12)
      @user.password = generated
      @user.password_confirmation = generated
      if @user.save
        redirect_to admin_user_path(@user), notice: "User created. One-time password: #{generated}"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize @user
    end

    def update
      authorize @user
      if demoting_last_admin?
        redirect_to edit_admin_user_path(@user), alert: "Cannot demote the last admin."
        return
      end
      permitted = user_params
      permitted = permitted.except(:password, :password_confirmation) if permitted[:password].blank?
      if @user.update(permitted)
        redirect_to admin_users_path, notice: "User updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_user
      @user = policy_scope(User).find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email_address, :full_name, :role, :active, :password, :password_confirmation)
    end

    def demoting_last_admin?
      return false unless @user.admin?
      return false if user_params[:role].blank?
      return false if user_params[:role].to_s == "admin"

      User.where(school_id: Current.school.id, role: :admin).where.not(id: @user.id).none?
    end
  end
end
