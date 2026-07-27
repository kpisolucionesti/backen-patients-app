class User < ApplicationRecord
  SESSION_IDLE_TIMEOUT = 15.minutes
  MAX_FAILED_ATTEMPTS = 5
  MAX_LOCKS = 3

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable,
         authentication_keys: [:username]

  belongs_to :profile, optional: true
  belongs_to :doctor, optional: true
  has_many :emergencies, foreign_key: 'created_by_id'

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  validate :password_complexity

  before_save :ensure_authentication_token

  def ensure_authentication_token
    self.authentication_token ||= generate_authentication_token
  end

  def regenerate_authentication_token
    update!(authentication_token: generate_authentication_token)
  end

  def invalidate_authentication_token
    update!(authentication_token: nil)
  end

  def session_expired?
    return false if last_activity_at.nil?
    last_activity_at < SESSION_IDLE_TIMEOUT.ago
  end

  def update_last_activity!
    update!(last_activity_at: Time.current)
  end

  def locked?
    locked_at.present? || (failed_attempts.to_i >= MAX_FAILED_ATTEMPTS)
  end

  def blocked?
    blocked_at.present?
  end

  def accessible?
    status == 'active' && !locked? && !blocked?
  end

  def auto_unlock_if_expired!
    return unless locked_at.present? && locked_at < 30.minutes.ago
    update!(locked_at: nil, failed_attempts: 0)
  end

  ALL_PERMISSIONS = [
    'emergencia.view', 'emergencia.create', 'emergencia.edit',
    'emergencia.anular', 'emergencia.triage', 'emergencia.discharge',
    'emergencia.assign_room', 'emergencia.cargar_laboratorios',
    'emergencia.modificar_antecedentes', 'emergencia.reportes', 'emergencia.documentos',
    'evaluaciones.view', 'evaluaciones.create', 'evaluaciones.edit', 'evaluaciones.delete',
    'planes.view', 'planes.create', 'planes.edit', 'planes.delete',
    'historial.view', 'historial.export',
    'configuraciones.view',
    'pacientes.view', 'pacientes.edit',
    'pacientes.cargar_laboratorios', 'pacientes.modificar_antecedentes',
    'pacientes.documentos',
    'medicos.view', 'medicos.create', 'medicos.edit', 'medicos.suspend',
    'usuarios.view', 'usuarios.create', 'usuarios.edit',
    'usuarios.suspend', 'usuarios.block', 'usuarios.manage_permissions', 'usuarios.change_password',
    'perfiles.view', 'perfiles.create', 'perfiles.edit', 'perfiles.delete',
    'areas.view', 'areas.create', 'areas.edit', 'areas.delete',
    'rooms.view', 'rooms.create', 'rooms.edit', 'rooms.delete',
    'notes.view', 'notes.create', 'notes.edit', 'notes.delete',
    'lab_params.view', 'lab_params.edit',
    'hospitalizacion.view', 'hospitalizacion.edit', 'hospitalizacion.nursing',
    'hospitalizacion.reportes', 'hospitalizacion.documentos',
    'quirofano.view', 'quirofano.schedule', 'quirofano.edit',
    'quirofano.reportes', 'quirofano.documentos',
    'uci.view', 'uci.edit', 'uci.nursing',
    'especialidades.view', 'especialidades.create', 'especialidades.edit', 'especialidades.delete',
    'agenda.edit',
    'enfermeria.view', 'enfermeria.create', 'enfermeria.edit', 'enfermeria.delete',
    'citas.view', 'citas.create', 'citas.edit', 'citas.delete', 'citas.attend',
  ].freeze

  def effective_permissions
    return ALL_PERMISSIONS if admin?
    base = profile&.permissions || []
    extra = self.permissions || []
    (base + extra).uniq
  end

  def admin?
    profile&.admin? || false
  end

  def protected?
    admin? || username == 'admin'
  end

  private

  def password_complexity
    return if password.blank?
    errors.add :password, 'debe tener al menos 8 caracteres' if password.length < 8
    errors.add :password, 'debe incluir al menos una mayúscula' unless password.match?(/[A-Z]/)
    errors.add :password, 'debe incluir al menos una minúscula' unless password.match?(/[a-z]/)
    errors.add :password, 'debe incluir al menos un número' unless password.match?(/\d/)
    errors.add :password, 'debe incluir al menos un carácter especial' unless password.match?(/[^A-Za-z0-9]/)
  end

  def generate_authentication_token
    loop do
      token = SecureRandom.hex(32)
      break token unless User.exists?(authentication_token: token)
    end
  end
end
