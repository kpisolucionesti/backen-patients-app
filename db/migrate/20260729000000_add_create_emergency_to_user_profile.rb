class AddCreateEmergencyToUserProfile < ActiveRecord::Migration[7.0]
  def up
    profile = Profile.find_by(name: 'User')
    if profile
      current_permissions = profile.permissions || []
      unless current_permissions.include?('emergencia.create')
        profile.update(permissions: current_permissions + ['emergencia.create'])
      end
    end
  end

  def down
    profile = Profile.find_by(name: 'User')
    if profile
      current_permissions = profile.permissions || []
      profile.update(permissions: current_permissions - ['emergencia.create'])
    end
  end
end
