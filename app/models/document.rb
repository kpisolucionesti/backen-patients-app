class Document < ApplicationRecord
  VALID_CONTENT_TYPES = %w[application/pdf].freeze
  MAX_FILE_SIZE = 10.megabytes

  belongs_to :attachable, polymorphic: true
  belongs_to :uploaded_by, class_name: 'User', optional: true
  belongs_to :study_classification, class_name: 'ClinicalStudyClassification', optional: true

  has_one_attached :file

  before_create :generate_order_number, if: -> { study_classification_id.present? }

  validates :file, presence: true, unless: :system_report?
  validates :attachable_type, presence: true
  validates :attachable_id, presence: true
  validate :validate_file_content_type, if: -> { file.attached? }
  validate :validate_file_size, if: -> { file.attached? }

  scope :system_reports, -> { where.not(report_type: nil) }
  scope :user_uploads, -> { where(report_type: nil) }
  scope :service_orders, -> { where.not(order_number: nil) }
  scope :by_classification, ->(id) { where(study_classification_id: id) }

  STATUSES = %w[pending in_progress completed delivered cancelled].freeze

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

  def classification_name
    I18n.t("clinical_study_classifications.#{study_classification&.key}", default: study_classification&.name) if study_classification
  end

  def system_report?
    report_type.present?
  end

  private

  def generate_order_number
    year = Time.current.year
    last = Document.where('order_number LIKE ?', "SO-#{year}%").order(order_number: :desc).first
    seq = last ? last.order_number.split('-').last.to_i + 1 : 1
    self.order_number = "SO-#{year}#{seq.to_s.rjust(4, '0')}"
  end

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
