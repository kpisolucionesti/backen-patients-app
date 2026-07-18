class FluidBalancesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_hospitalization
  before_action :set_balance, only: [:update, :destroy]

  def index
    authorize!('hospitalizacion.view')
    balances = @hospitalization.fluid_balances.includes(:recorded_by).order(recorded_at: :desc)
    render json: ::FluidBalanceRepresenter.for_collection.new(balances), status: :ok
  end

  def create
    authorize!('hospitalizacion.nursing')
    balance = @hospitalization.fluid_balances.new(balance_params)
    balance.recorded_by = @current_user
    balance.recorded_at ||= Time.current

    if balance.save
      render json: ::FluidBalanceRepresenter.new(balance), status: :created
    else
      render json: { error: balance.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    authorize!('hospitalizacion.edit')
    if @balance.update(balance_params)
      render json: ::FluidBalanceRepresenter.new(@balance), status: :ok
    else
      render json: { error: @balance.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize!('hospitalizacion.edit')
    @balance.destroy!
    head :no_content
  end

  def summary
    authorize!('hospitalizacion.view')
    today_start = Date.current.beginning_of_day
    today_end = Date.current.end_of_day

    today_intake = @hospitalization.fluid_balances
      .where(balance_type: 'intake', recorded_at: today_start..today_end).sum(:amount)
    today_output = @hospitalization.fluid_balances
      .where(balance_type: 'output', recorded_at: today_start..today_end).sum(:amount)

    render json: {
      today_intake: today_intake,
      today_output: today_output,
      today_net: today_intake - today_output,
      total_intake: @hospitalization.total_fluid_intake,
      total_output: @hospitalization.total_fluid_output,
      total_net: @hospitalization.net_fluid_balance
    }, status: :ok
  end

  private

  def set_hospitalization
    @hospitalization = Hospitalization.find(params[:hospitalization_id])
  end

  def set_balance
    @balance = @hospitalization.fluid_balances.find(params[:id])
  end

  def balance_params
    params.permit(:balance_type, :fluid_type, :amount, :unit, :recorded_at)
  end
end
