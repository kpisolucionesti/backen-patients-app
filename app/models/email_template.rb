class EmailTemplate < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :subject, presence: true
  scope :active, -> { where(is_active: true) }
  scope :of_type, ->(type) { where(template_type: type) }

  def render_body(vars = {})
    result = body_html.to_s
    variables.each { |v| result = result.gsub("{{#{v}}}", vars[v.to_sym]&.to_s || '') }
    result
  end

  def render_subject(vars = {})
    result = subject.to_s
    variables.each { |v| result = result.gsub("{{#{v}}}", vars[v.to_sym]&.to_s || '') }
    result
  end

  def available_variables
    variables.map { |v| "{{#{v}}}" }
  end
end
