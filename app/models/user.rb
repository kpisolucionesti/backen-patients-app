class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  belongs_to :profile, optional: true

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

  ALL_PERMISSIONS = [
    'emergencia.view', 'emergencia.create', 'emergencia.edit',
    'emergencia.triage', 'emergencia.discharge',
    'historial.view', 'historial.export',
    'configuraciones.view',
    'pacientes.view', 'pacientes.edit',
    'medicos.view', 'medicos.create', 'medicos.edit', 'medicos.suspend',
    'usuarios.view', 'usuarios.create', 'usuarios.edit',
    'usuarios.suspend', 'usuarios.manage_permissions', 'usuarios.change_password',
    'perfiles.view', 'perfiles.create', 'perfiles.edit', 'perfiles.delete',
    'rooms.view',
    'notes.view', 'notes.create', 'notes.edit', 'notes.delete',
    'emergencia.assign_room',
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
    admin? || email == 'admin@emerboard.com'
  end

  private

  def generate_authentication_token
    loop do
      token = SecureRandom.hex(32)
      break token unless User.exists?(authentication_token: token)
    end
  end
end
