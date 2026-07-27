class NotesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_note, only: [:update, :destroy, :show]

    def index
        authorize!('notes.view')
        note = Note.all.includes(:patient, :created_by)
        note = note.where(patient_id: params[:patient_id]) if params[:patient_id].present?
        note = note.where(emergency_id: params[:emergency_id]) if params[:emergency_id].present?
        render json: ::NoteRepresenter.for_collection.new(note),status: :ok
    end

    def create
        authorize!('notes.create')
        note = Note.new(note_params)
        note.created_by = @current_user
        if note.save
            patient_name = note.patient ? "#{note.patient.name} #{note.patient.lastname}" : "ID #{note.patient_id}"
            UserActivityLog.create!(user: @current_user, action: 'create_note', description: "Creó nota para paciente #{patient_name}")
            render json: ::NoteRepresenter.new(note),status: :created
        else
            render json: {error: "No se pudo guardar"},status: :unprocessable_entity
        end
    end

    def update
        authorize!('notes.edit')
        if @note.update(note_params)
            patient_name = @note.patient ? "#{@note.patient.name} #{@note.patient.lastname}" : "ID #{@note.patient_id}"
            UserActivityLog.create!(user: @current_user, action: 'edit_note', description: "Editó nota para paciente #{patient_name}")
            render json: ::NoteRepresenter.new(@note),status: :ok
        else
            render json: {error: "No se pudo guardar"},status: :unprocessable_entity
        end
    end

    def destroy
        authorize!('notes.delete')
        patient_name = @note.patient ? "#{@note.patient.name} #{@note.patient.lastname}" : "ID #{@note.patient_id}"
        UserActivityLog.create!(user: @current_user, action: 'delete_note', description: "Eliminó nota para paciente #{patient_name}")
        @note.destroy
        render json: {message: "Eliminado"}, status: :ok
    end

    private
    def note_params
        params.permit(:note, :patient_id, :emergency_id, :note_type)
    end

    def set_note
        @note = Note.find(params[:id])
    end
end
