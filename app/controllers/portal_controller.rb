class PortalController < ApplicationController
  def index
    case current_user.role
    when 'student'
      @registrations = current_user.registrations.includes(:opportunity, :certificate)
      .order(created_at: :desc)

    when 'organization'
      @opportunities = current_user.opportunities.order(:starts_at)

      @registrations = Registration.joins(:opportunity)
      .where(opportunities: { organization_id: current_user.id })
      .includes(:student, :opportunity, :certificate).order(created_at: :desc)
      
    when 'deanship'
      @registrations = Registration.includes(:student, :opportunity, :certificate)
      .order(created_at: :desc)

      @organizations = User.where(role: 'organization')
      .order(:name)

      @opportunities = Opportunity.all
    end
  end
end
