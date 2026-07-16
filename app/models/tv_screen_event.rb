class TvScreenEvent < ApplicationRecord
  belongs_to :tv_screen

  validates :event_type, presence: true

  EVENT_TYPES = %w[
    created updated pin_changed
    connected disconnected
    activated deactivated
    error
  ].freeze

  validates :event_type, inclusion: { in: EVENT_TYPES }
end
