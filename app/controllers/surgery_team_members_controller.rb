class SurgeryTeamMembersController < ApplicationController
  before_action :authenticate_user!

  def create
    authorize!('quirofano.edit')
    member = SurgeryTeamMember.new(member_params)
    if member.save
      render json: ::SurgeryTeamMemberRepresenter.new(member), status: :created
    else
      render json: { error: member.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize!('quirofano.edit')
    member = SurgeryTeamMember.find(params[:id])
    member.destroy!
    head :no_content
  end

  private

  def member_params
    params.permit(:surgery_id, :doctor_id, :role)
  end
end
