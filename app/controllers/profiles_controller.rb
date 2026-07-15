class ProfilesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_profile, only: [:show, :update, :destroy]

    def index
        authorize!('perfiles.view')
        profiles = Profile.all.order(:name)
        render json: profiles.map { |p| profile_response(p) }, status: :ok
    end

    def show
        authorize!('perfiles.view')
        render json: profile_response(@profile), status: :ok
    end

    def create
        authorize!('perfiles.create')
        profile = Profile.create!(profile_params)
        render json: profile_response(profile), status: :created
    end

    def update
        authorize!('perfiles.edit')
        @profile.update!(profile_params)
        render json: profile_response(@profile), status: :ok
    end

    def destroy
        authorize!('perfiles.delete')
        if @profile.protected?
            return render json: { error: "No se puede eliminar el perfil #{@profile.name}" }, status: :forbidden
        end
        if @profile.users.any?
            return render json: { error: "No se puede eliminar un perfil con usuarios asignados" }, status: :unprocessable_entity
        end
        @profile.destroy!
        head :no_content
    end

    def users
        authorize!('perfiles.view')
        profile = Profile.find(params[:id])
        users = profile.users
        render json: users.map { |u| { id: u.id, name: u.name, email: u.email, status: u.status } }, status: :ok
    end

    private

    def profile_params
        params.permit(:name, :description, permissions: [])
    end

    def set_profile
        @profile = Profile.find(params[:id])
    end

    def profile_response(profile)
        {
            id: profile.id,
            name: profile.name,
            description: profile.description,
            permissions: profile.permissions,
            users_count: profile.users.count,
            created_at: profile.created_at
        }
    end
end
