require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username).case_insensitive }
  end

  describe 'associations' do
    it { should belong_to(:profile).optional }
    it { should have_many(:emergencies).with_foreign_key('created_by_id') }
  end

  describe '#admin?' do
    it 'returns true when profile is Administrador' do
      user = build(:user, profile: build(:profile, :admin))
      expect(user.admin?).to be true
    end

    it 'returns false for regular profile' do
      user = build(:user)
      expect(user.admin?).to be false
    end
  end

  describe '#protected?' do
    it 'returns true for admin user' do
      user = build(:user, username: 'admin')
      expect(user.protected?).to be true
    end

    it 'returns false for regular user' do
      user = build(:user)
      expect(user.protected?).to be false
    end
  end
end
