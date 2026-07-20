class Document < ApplicationRecord
  REPORT_TYPES = %w[triage resident specialist admission progress interconsultation discharge].freeze

  belongs_to :attachable, polymorphic: true
  belongs_to :uploaded_by, class_name: 'User', optional: true

  has_one_attached :file

  validates :file, presence: true
  validates :report_type, inclusion: { in: REPORT_TYPES }, allow_blank: true

  def file_url
    Rails.application.routes.url_helpers.rails_blob_url(file, disposition: 'inline', host: ENV.fetch('HOST', 'http://localhost:3100')) if file.attached?
  end

  def file_name
    file.filename.to_s if file.attached?
  end

  def file_size
    helper = ActionController::Base.helpers
    helper.number_to_human_size(file.byte_size) if file.attached?
  end
end
