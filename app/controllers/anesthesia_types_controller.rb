class AnesthesiaTypesController < ApplicationController
  include Crudable

  PERMITTED_PARAMS = [:name].freeze
end
