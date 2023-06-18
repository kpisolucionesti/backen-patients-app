class EmergenciesController < ApplicationController
        before_action :set_emergency, only: [:update, :destroy, :show]
        
        def index
            emergency = Emergency.all
            render json: ::EmergencyRepresenter.for_collection.new(emergency),status: :ok
        end
    
        def create
            emergency = Emergency.new(emergency_params)
            if emergency.save
                render json: ::EmergencyRepresenter.new(emergency),status: :created
            else
                render json: {error: "No se pudo guardar"},status: :unprocessable_entity
            end
        end
    
        def update
            if @emergency.update(emergency_params)
                render json: ::EmergencyRepresenter.new(@emergency),status: :ok
            else
                render json: {error: "No se pudo guardar"},status: :unprocessable_entity
            end    
        end
    
        private
        def emergency_params
            params.permit(:doctor_id, :patient_id, :ingress_date, :status, :medical_exit, :diagnostic, :treatment)
        end
    
        def set_emergency
            @emergency = Emergency.find(params[:id])
        end 
end
