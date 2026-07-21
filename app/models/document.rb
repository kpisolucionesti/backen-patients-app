class Document < ApplicationRecord
  VALID_CONTENT_TYPES = %w[application/pdf].freeze
  MAX_FILE_SIZE = 10.megabytes

  belongs_to :attachable, polymorphic: true
  belongs_to :uploaded_by, class_name: 'User', optional: true

  has_one_attached :file

  validates :file, presence: true
  validates :attachable_type, presence: true
  validates :attachable_id, presence: true
  validate :validate_file_content_type, if: -> { file.attached? }
  validate :validate_file_size, if: -> { file.attached? }

  scope :system_reports, -> { where.not(report_type: nil) }
  scope :user_uploads, -> { where(report_type: nil) }

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

  def report_label
    case report_type
    when 'informe_medico' then 'Informe Médico'
    when 'evolucion_medica' then 'Evolución Médica'
    when 'indicaciones_medicas' then 'Indicaciones Médicas'
    when 'reporte_enfermeria' then 'Reporte de Enfermería'
    else report_type&.humanize || 'Documento'
    end
  end

  private

  def validate_file_content_type
    unless file.content_type.in?(VALID_CONTENT_TYPES)
      errors.add(:file, 'debe ser un archivo PDF')
    end
  end

  def validate_file_size
    if file.byte_size > MAX_FILE_SIZE
      errors.add(:file, "no debe exceder los 10 MB")
    end
  end
end
