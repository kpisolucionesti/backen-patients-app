class CompanySettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  def show
    settings = CompanySetting.first_or_initialize
    render json: format_settings(settings)
  end

  def update
    settings = CompanySetting.first_or_initialize
    if settings.update(company_settings_params)
      UserActivityLog.create!(user: @current_user, action: 'update_company_settings', description: "Actualizó configuración de la empresa")
      render json: format_settings(settings), status: :ok
    else
      render json: { error: settings.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def require_admin!
    unless @current_user&.admin?
      render json: { error: "No autorizado" }, status: :forbidden
    end
  end

  def company_settings_params
    params.permit(:company_name, :rif, :address, :city, :state, :country, :phone, :email, :website)
  end

  def format_settings(s)
    {
      id: s.id,
      company_name: s.company_name,
      rif: s.rif,
      address: s.address,
      city: s.city,
      state: s.state,
      country: s.country,
      phone: s.phone,
      email: s.email,
      website: s.website,
      logo_url: s.logo.attached? ? url_for(s.logo) : nil,
    }
  end
end
