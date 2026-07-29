class DiagnosesController < ApplicationController
  include Crudable

  PERMITTED_PARAMS = [:code, :description, :category].freeze
  DEFAULT_ORDER = :code
end
