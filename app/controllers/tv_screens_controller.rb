class TvScreensController < ApplicationController
  before_action :authenticate_user!, except: [:auth, :list_active]
  before_action :set_tv_screen, only: [:show, :update, :destroy, :regenerate_pin, :revoke_sessions]

  def index
    authorize!('configuraciones.view')
    screens = TvScreen.all.order(:name)
    result = screens.map do |screen|
      rep = TvScreenRepresenter.new(screen)
      rep.to_hash.merge(
        last_session: screen.sessions.active.order(last_seen_at: :desc).first&.as_json(
          only: [:id, :ip_address, :last_seen_at, :revoked_at, :created_at]
        )
      )
    end
    render json: result, status: :ok
  end

  def show
    authorize!('configuraciones.view')
    render json: TvScreenRepresenter.new(@tv_screen), status: :ok
  end

  def create
    authorize!('configuraciones.view')
    screen = TvScreen.new(tv_screen_params)
    screen.pin_digest = TvScreen.pin_digest(params[:pin])

    if screen.save
      screen.events.create!(event_type: 'created', metadata: { by: @current_user&.name })
      render json: TvScreenRepresenter.new(screen), status: :created
    else
      render json: { error: 'No se pudo guardar', errors: screen.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authorize!('configuraciones.view')
    update_attrs = tv_screen_params
    if params[:pin].present?
      update_attrs[:pin_digest] = TvScreen.pin_digest(params[:pin])
      @tv_screen.events.create!(event_type: 'pin_changed', metadata: { by: @current_user&.name })
      @tv_screen.sessions.active.update_all(revoked_at: Time.current)
    end

    if @tv_screen.update(update_attrs)
      render json: TvScreenRepresenter.new(@tv_screen), status: :ok
    else
      render json: { error: 'No se pudo guardar' }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize!('configuraciones.view')
    if @tv_screen.sessions.active.exists?
      render json: { error: 'No se puede eliminar una pantalla con sesiones activas. Desconéctela primero.' }, status: :unprocessable_entity
    else
      @tv_screen.destroy
      render json: { message: 'Pantalla eliminada' }, status: :ok
    end
  end

  def regenerate_pin
    authorize!('configuraciones.view')
    new_pin = rand(1000..9999).to_s
    @tv_screen.update!(pin_digest: TvScreen.pin_digest(new_pin))
    @tv_screen.sessions.active.update_all(revoked_at: Time.current)
    @tv_screen.events.create!(event_type: 'pin_changed', metadata: { by: @current_user&.name, regenerated: true })
    render json: { pin: new_pin, message: 'PIN regenerado exitosamente' }, status: :ok
  end

  def revoke_sessions
    authorize!('configuraciones.view')
    count = @tv_screen.sessions.active.count
    @tv_screen.sessions.active.update_all(revoked_at: Time.current)
    @tv_screen.events.create!(event_type: 'disconnected', metadata: { by: @current_user&.name, sessions_revoked: count })
    render json: { message: "#{count} sesion(es) revocada(s)" }, status: :ok
  end

  def list_active
    screens = TvScreen.where(is_active: true)
    render json: screens.map { |s| { id: s.id, name: s.name, location: s.location, is_active: s.is_active, route: s.route } }, status: :ok
  end

  def auth
    screen = TvScreen.find_by(name: params[:name])

    unless screen
      render json: { error: 'Pantalla no encontrada' }, status: :unauthorized
      return
    end

    unless screen.is_active?
      screen.events.create!(event_type: 'error', metadata: { reason: 'screen_disabled', ip: request.remote_ip })
      render json: { error: 'Pantalla desactivada' }, status: :unauthorized
      return
    end

    unless screen.authenticate_pin(params[:pin])
      screen.events.create!(event_type: 'error', metadata: { reason: 'wrong_pin', ip: request.remote_ip })
      render json: { error: 'PIN incorrecto' }, status: :unauthorized
      return
    end

    session = screen.sessions.create!(
      ip_address: request.remote_ip,
      last_seen_at: Time.current
    )
    screen.events.create!(event_type: 'connected', metadata: { ip: request.remote_ip })

    render json: {
      auth_token: session.auth_token,
      tv_screen: TvScreenRepresenter.new(screen)
    }, status: :ok
  end

  private

  def tv_screen_params
    params.permit(:name, :location, :is_active, :route)
  end

  def set_tv_screen
    @tv_screen = TvScreen.find(params[:id])
  end
end
