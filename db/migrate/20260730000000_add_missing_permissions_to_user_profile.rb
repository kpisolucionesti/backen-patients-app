class AddMissingPermissionsToUserProfile < ActiveRecord::Migration[7.0]
  REQUIRED = ['emergencia.assign_room', 'pacientes.edit']

  def up
    profile = Profile.find_by(name: 'User')
    return unless profile

    current = profile.permissions || []
    missing = REQUIRED - current
    return if missing.empty?

    profile.update(permissions: current + missing)
  end

  def down
    profile = Profile.find_by(name: 'User')
    return unless profile

    profile.update(permissions: profile.permissions - REQUIRED)
  end
end
