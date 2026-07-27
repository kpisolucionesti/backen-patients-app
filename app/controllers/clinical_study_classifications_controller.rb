class ClinicalStudyClassificationsController < ApplicationController
      before_action :authenticate_user!
      before_action :authorize_view, only: [:index]
      before_action :authorize_edit, only: [:create, :update, :destroy, :restore]
      before_action :set_classification, only: [:update, :destroy, :restore]

      def index
        classifications = if params[:include_inactive] == 'true'
          ClinicalStudyClassification.ordered
        else
          ClinicalStudyClassification.active.ordered
        end
        render json: classifications.map { |c| ClinicalStudyClassificationRepresenter.new(c).to_json }
      end

      def create
        classification = ClinicalStudyClassification.new(classification_params)
        if classification.save
          render json: ClinicalStudyClassificationRepresenter.new(classification).to_json, status: :created
        else
          render json: { errors: classification.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @classification.update(classification_params)
          render json: ClinicalStudyClassificationRepresenter.new(@classification).to_json
        else
          render json: { errors: @classification.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        active_params = @classification.lab_parameters.where(is_active: true)
        if active_params.any?
          render json: { error: "No se puede suspender la clasificación porque tiene #{active_params.count} parámetros activos asociados. Suspenda o reasigne los parámetros primero." }, status: :unprocessable_entity
          return
        end
        @classification.update!(is_active: false)
        render json: ClinicalStudyClassificationRepresenter.new(@classification).to_json
      end

      def restore
        @classification.update!(is_active: true)
        render json: ClinicalStudyClassificationRepresenter.new(@classification).to_json
      end

      private

      def set_classification
        @classification = ClinicalStudyClassification.find(params[:id])
      end

      def classification_params
        params.permit(:name, :key, :color, :sort_order)
      end

      def authorize_view
        authorize!('lab_params.view')
      end

      def authorize_edit
        authorize!('lab_params.edit')
      end
end
