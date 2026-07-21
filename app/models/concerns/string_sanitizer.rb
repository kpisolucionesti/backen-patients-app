module StringSanitizer
  extend ActiveSupport::Concern

  included do
    before_validation :sanitize_string_fields
  end

  private

  def sanitize_string_fields
    self.class.columns.each do |column|
      next unless column.type.in?(%i[string text])
      next unless respond_to?(column.name)
      value = send(column.name)
      next unless value.is_a?(String)
      sanitized = strip_html_and_control(value)
      send(:"#{column.name}=", sanitized) if sanitized != value
    end
  end

  def strip_html_and_control(str)
    s = str.dup
    s.gsub!(/<[^>]*>/, '')
    s.gsub!(/[\x00-\x08\x0B\x0C\x0E-\x1F]/, '')
    s.strip!
    s
  end
end
