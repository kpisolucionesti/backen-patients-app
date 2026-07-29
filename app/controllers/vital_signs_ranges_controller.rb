class VitalSignsRangesController < ApplicationController
  include Crudable

  PERMITTED_PARAMS = [:parameter, :sex, :age_min, :age_max, :min_normal, :max_normal, :min_alert, :max_alert].freeze
  DEFAULT_ORDER = :parameter
end
