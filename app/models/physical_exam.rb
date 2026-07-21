class PhysicalExam < ApplicationRecord
  belongs_to :emergency

  validates :emergency, presence: true
  validates :cabeza, length: { maximum: 5000 }, allow_blank: true
  validates :ojo, length: { maximum: 5000 }, allow_blank: true
  validates :cuello, length: { maximum: 5000 }, allow_blank: true
  validates :orl, length: { maximum: 5000 }, allow_blank: true
  validates :torax, length: { maximum: 5000 }, allow_blank: true
  validates :cardiovascular, length: { maximum: 5000 }, allow_blank: true
  validates :abdomen, length: { maximum: 5000 }, allow_blank: true
  validates :genitales, length: { maximum: 5000 }, allow_blank: true
  validates :extremidades, length: { maximum: 5000 }, allow_blank: true
  validates :neurologico, length: { maximum: 5000 }, allow_blank: true
end
