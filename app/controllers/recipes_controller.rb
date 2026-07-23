class RecipesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_emergency
  before_action :set_recipe, only: [:update, :destroy]

  def index
    authorize!('emergencia.view')
    recipes = @emergency.recipes.includes(:doctor).order(created_at: :desc)
    render json: ::RecipeRepresenter.for_collection.new(recipes), status: :ok
  end

  def create
    authorize!('emergencia.edit')
    recipe = @emergency.recipes.new(recipe_params)
    recipe.doctor_id = @current_user.doctor_id if recipe.doctor_id.blank?
    if recipe.save
      patient = @emergency.patient
      UserActivityLog.create!(user: @current_user, action: 'create_recipe', description: "Creó receta '#{recipe.medication}' para emergencia #{@emergency.id} del paciente #{patient.name} #{patient.lastname} (CI: #{patient.ci})")
      render json: ::RecipeRepresenter.new(recipe), status: :created
    else
      render json: { error: recipe.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    authorize!('emergencia.edit')
    if @recipe.update(recipe_params)
      patient = @emergency.patient
      UserActivityLog.create!(user: @current_user, action: 'edit_recipe', description: "Editó receta '#{@recipe.medication}' de emergencia #{@emergency.id} del paciente #{patient.name} #{patient.lastname} (CI: #{patient.ci})")
      render json: ::RecipeRepresenter.new(@recipe), status: :ok
    else
      render json: { error: @recipe.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize!('emergencia.edit')
    patient = @emergency.patient
    UserActivityLog.create!(user: @current_user, action: 'delete_recipe', description: "Eliminó receta '#{@recipe.medication}' de emergencia #{@emergency.id} del paciente #{patient.name} #{patient.lastname} (CI: #{patient.ci})")
    @recipe.destroy!
    head :no_content
  end

  private

  def set_emergency
    @emergency = Emergency.find(params[:emergency_id])
  end

  def set_recipe
    @recipe = @emergency.recipes.find(params[:id])
  end

  def recipe_params
    params.permit(:medication, :dosage, :frequency, :duration, :route, :indications, :doctor_id)
  end
end
