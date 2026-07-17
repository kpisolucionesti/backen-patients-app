class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: [:show, :update, :destroy, :change_password]

    def index
        authorize!('usuarios.view')
        users = User.all
        render json: users.map { |u| user_response(u) }, status: :ok
    end

    def show
        authorize!('usuarios.view')
        render json: user_response(@user), status: :ok
    end

    def create
        authorize!('usuarios.create')
        user = User.new(user_params)
        user.profile ||= Profile.find_by(name: 'User')
        temp_password = "Emerboard20-"
        user.password = temp_password
        user.password_confirmation = temp_password
        user.skip_confirmation!
        if user.save
            begin
                raw_token = user.set_reset_password_token
                UserMailer.welcome_email(user, raw_token).deliver_now
            rescue => e
                Rails.logger.error("Error enviando correo de bienvenida: #{e.message}")
            end
            render json: user_response(user), status: :created
        else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
        authorize!('usuarios.edit')
        if @user.protected?
            return render json: { error: "No se puede modificar este usuario" }, status: :forbidden
        end
        if @user.update(update_params)
            render json: user_response(@user), status: :ok
        else
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        authorize!('usuarios.suspend')
        if @user.protected?
            return render json: { error: "No se puede eliminar este usuario" }, status: :forbidden
        end
        @user.destroy
        head :no_content
    end

    def change_password
        if params[:current_password].present?
            unless @user.valid_password?(params[:current_password])
                return render json: { errors: ["Contrasena actual incorrecta"] }, status: :unprocessable_entity
            end
        else
            authorize!('usuarios.change_password')
        end
        if @user.update(password: params[:password], password_confirmation: params[:password_confirmation], must_change_password: false)
            render json: { message: "Contrasena actualizada", must_change_password: false }, status: :ok
        else
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update_permissions
        authorize!('usuarios.manage_permissions')
        @user = User.find(params[:id])
        if @user.protected?
            return render json: { error: "No se puede modificar este usuario" }, status: :forbidden
        end
        if @user.update(permissions: params[:permissions], profile_id: params[:profile_id])
            render json: user_response(@user), status: :ok
        else
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def profiles
        authorize!('usuarios.manage_permissions')
        profiles = Profile.all
        render json: profiles.map { |p| { id: p.id, name: p.name, description: p.description, permissions: p.permissions } }, status: :ok
    end

    def emergencies
        authorize!('usuarios.view')
        user = User.find(params[:id])
        user_emergencies = user.emergencies.includes(:patient, :doctors)
        render json: ::EmergencyRepresenter.for_collection.new(user_emergencies), status: :ok
    end

    private

    def user_params
        params.permit(:username, :name, :lastname, :email, :password, :password_confirmation, :status, :profile_id)
    end

    def update_params
        params.permit(:username, :name, :lastname, :email, :status, :profile_id)
    end

    def set_user
        @user = User.find(params[:id])
    end

    def user_response(user)
        {
            id: user.id,
            username: user.username,
            email: user.email,
            name: user.name,
            lastname: user.lastname,
            status: user.status,
            profile_id: user.profile_id,
            profile_name: user.profile&.name,
            permissions: user.effective_permissions,
            is_admin: user.admin?,
            confirmed: user.confirmed?,
            must_change_password: user.must_change_password,
            created_at: user.created_at
        }
    end
end
