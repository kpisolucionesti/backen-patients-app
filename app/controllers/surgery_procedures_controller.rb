class SurgeryProceduresController < ApplicationController
  include Crudable

  PERMITTED_PARAMS = [:code, :name, :category].freeze
end
