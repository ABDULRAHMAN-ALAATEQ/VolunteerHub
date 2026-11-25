class CertificatesController < ApplicationController
  def show
    @certificate = Certificate.includes(registration: [:student, :opportunity]).find(params[:id])
    head :forbidden unless current_user.role == 'deanship' ||
    @certificate.registration.student_id == current_user.id
  end
end
