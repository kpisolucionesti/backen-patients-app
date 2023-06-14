class Patient < ApplicationRecord
  has_many :diagnostics
  def current_diagnostic
      diagnostics.last
  end
  def current_doctor
      current_diagnostic.doctor
  end
end
