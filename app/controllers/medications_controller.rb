class MedicationsController < ApplicationController
  include Crudable

  PERMITTED_PARAMS = [:name, :generic_name, :presentation, :concentration, :medication_route].freeze
end
