class NotesController < ApplicationController
    before_action :set_note, only: [:update, :destroy, :show]

    def index
        note = Note.all
        render json: ::NoteRepresenter.for_collection.new(note),status: :ok
    end

    def create
        note = Note.new(note_params)
        if note.save
            render json: ::NoteRepresenter.new(note),status: :created
        else
            render json: {error: "No se pudo guardar"},status: :unprocessable_entity
        end
    end

    def update
        if @note.update(note_params)
            render json: ::NoteRepresenter.new(@note),status: :ok
        else
            render json: {error: "No se pudo guardar"},status: :unprocessable_entity
        end    
    end

    private
    def note_params
        params.permit(:note, :patient_id)
    end

    def set_note
        @note = Note.find(params[:id])
    end 
end
