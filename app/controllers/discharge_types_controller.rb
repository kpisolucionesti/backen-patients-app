class DischargeTypesController < ApplicationController
  include Crudable

  PERMITTED_PARAMS = [:name, :requires_cause_of_death].freeze
end
