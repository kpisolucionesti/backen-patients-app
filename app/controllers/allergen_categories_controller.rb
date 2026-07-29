class AllergenCategoriesController < ApplicationController
  include Crudable

  PERMITTED_PARAMS = [:name].freeze
end
