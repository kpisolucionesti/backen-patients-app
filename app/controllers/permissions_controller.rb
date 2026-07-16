class PermissionsController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize!('usuarios.manage_permissions')
    render json: YAML.load_file(Rails.root.join('config/permissions.yml'))
  end
end
