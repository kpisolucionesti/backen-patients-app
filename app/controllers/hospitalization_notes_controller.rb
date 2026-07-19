class HospitalizationNotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_hospitalization
  before_action :set_note, only: [:update, :destroy]

  def index
    authorize!('hospitalizacion.view')
    notes = @hospitalization.hospitalization_notes.includes(:created_by).order(recorded_at: :desc)
    render json: ::HospitalizationNoteRepresenter.for_collection.new(notes), status: :ok
  end

  def create
    authorize!('hospitalizacion.edit')
    note = @hospitalization.hospitalization_notes.new(note_params)
    note.created_by = @current_user
    note.recorded_at ||= Time.current

    if note.save
      render json: ::HospitalizationNoteRepresenter.new(note), status: :created
    else
      render json: { error: note.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    authorize!('hospitalizacion.edit')
    unless @current_user.admin? || @note.created_by_id == @current_user.id
      render json: { error: 'No autorizado: solo el creador puede editar esta nota' }, status: :forbidden
      return
    end
    if @note.update(note_params)
      render json: ::HospitalizationNoteRepresenter.new(@note), status: :ok
    else
      render json: { error: @note.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize!('hospitalizacion.edit')
    unless @current_user.admin? || @note.created_by_id == @current_user.id
      render json: { error: 'No autorizado: solo el creador puede eliminar esta nota' }, status: :forbidden
      return
    end
    @note.destroy!
    head :no_content
  end

  private

  def set_hospitalization
    @hospitalization = Hospitalization.find(params[:hospitalization_id])
  end

  def set_note
    @note = @hospitalization.hospitalization_notes.find(params[:id])
  end

  def note_params
    params.permit(:note_type, :shift, :subjective, :objective, :assessment, :plan, :recorded_at)
  end
end
