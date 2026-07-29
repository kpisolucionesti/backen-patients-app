class MedicationConcentrationsController < ApplicationController
  include Crudable

  PERMITTED_PARAMS = [:name].freeze
end
