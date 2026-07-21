class Doctor < ApplicationRecord
    belongs_to :specialty, optional: true
    has_many :emergency_doctors, dependent: :destroy
    has_many :emergencies, through: :emergency_doctors
    has_many :schedules, class_name: 'DoctorSchedule', dependent: :destroy

    has_one_attached :signature
    has_one_attached :stamp

    validates :name, presence: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
    validates :phone, length: { maximum: 20 }, allow_blank: true
    validates :ci, length: { maximum: 20 }, allow_blank: true
    validates :doctor_code, length: { maximum: 20 }, allow_blank: true
    validates :sanidad_number, length: { maximum: 20 }, allow_blank: true

    scope :active, -> { where(status: 'active') }
    scope :suspended, -> { where(status: 'suspended') }

    def speciality
      specialty&.name
    end

    def signature_url
      Rails.application.routes.url_helpers.rails_blob_url(signature, disposition: 'inline', host: ENV.fetch('HOST', 'http://localhost:3100')) if signature.attached?
    end

    def stamp_url
      Rails.application.routes.url_helpers.rails_blob_url(stamp, disposition: 'inline', host: ENV.fetch('HOST', 'http://localhost:3100')) if stamp.attached?
    end

    def has_signature
      signature.attached?
    end

    def has_stamp
      stamp.attached?
    end
end
