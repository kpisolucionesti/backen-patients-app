module Crudable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :set_record, only: [:show, :update, :destroy]
  end

  def index
    order_col = self.class.const_defined?(:DEFAULT_ORDER) ? self.class::DEFAULT_ORDER : :name
    records = model_class.order(order_col)
    render json: records, status: :ok
  end

  def show
    render json: @record, status: :ok
  end

  def create
    record = model_class.create!(record_params)
    render json: record, status: :created
  end

  def update
    @record.update!(record_params)
    render json: @record, status: :ok
  end

  def destroy
    @record.destroy!
    head :no_content
  end

  private

  def set_record
    @record = model_class.find(params[:id])
  end

  def model_class
    controller_name.classify.constantize
  end

  def record_params
    permitted = self.class.const_get(:PERMITTED_PARAMS)
    params.permit(permitted)
  end
end
