class AllergensController < ApplicationController
  include Crudable

  PERMITTED_PARAMS = [:name, :category].freeze
end
