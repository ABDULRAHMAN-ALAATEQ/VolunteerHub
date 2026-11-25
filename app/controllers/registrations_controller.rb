class RegistrationsController < ApplicationController
  def submit_hours
    return unless require_role('student')
    registration = current_user.registrations.find(params[:id])
    registration.submit!(params[:hours], params[:activity_note])
    redirect_to root_path, notice: 'Hours submitted for review.'
  rescue ArgumentError, ActiveRecord::RecordInvalid => e
    redirect_to root_path, alert: e.message
  end
  def review
    return unless require_role('deanship')
    Registration.find(params[:id]).review!(params[:decision], params[:review_note], current_user)
    redirect_to root_path, status: :see_other, notice: 'Review saved.'
  rescue ArgumentError, ActiveRecord::RecordInvalid => e
    redirect_to root_path, alert: e.message
  end
  def issue
    return unless require_role('deanship')
    certificate = Certificate.issue!(Registration.find(params[:id]), current_user)
    redirect_to certificate_path(certificate), notice: 'Certificate available.'
  rescue ArgumentError, ActiveRecord::RecordInvalid => e
    redirect_to root_path, alert: e.message
  end
end
