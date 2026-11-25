class OpportunitiesController < ApplicationController
  before_action :organization_only, only: [:new, :create, :edit, :update]
  def index
    @opportunities = scope.includes(:organization).order(:starts_at)
    if params[:q].present?
      term = "%#{ActiveRecord::Base.sanitize_sql_like(params[:q].to_s.strip)}%"
      @opportunities = @opportunities.where(
        'title LIKE ? OR location LIKE ? OR description LIKE ?',
        term, term, term
      )
    end
    if Opportunity::CATEGORIES.include?(params[:category])
      @opportunities = @opportunities.where(category: params[:category])
    end
  end

  def show
    @opportunity = scope.find(params[:id])
    if current_user.role == 'student'
      @registration = @opportunity.registrations.find_by(student: current_user)
    end
  end

  def new
    @opportunity = current_user.opportunities.new(
      starts_at: 1.week.from_now.change(hour: 9, min: 0),
      ends_at: 1.week.from_now.change(hour: 12, min: 0)
    )
  end

  def create
    @opportunity = current_user.opportunities.new(opportunity_params)
    if @opportunity.save
      redirect_to @opportunity, notice: 'Opportunity created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @opportunity = current_user.opportunities.find(params[:id])
  end

  def update
    @opportunity = current_user.opportunities.find(params[:id])
    saved = @opportunity.with_lock { @opportunity.update(opportunity_params) }
    if saved
      redirect_to @opportunity, status: :see_other, notice: 'Opportunity updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def register
    return unless require_role('student')
    opportunity = Opportunity.find(params[:id])
    opportunity.register_student!(current_user)
    redirect_to opportunity, notice: 'You are registered.'
  rescue ArgumentError, ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique,
    ActiveRecord::StatementInvalid => e
    if e.is_a?(ActiveRecord::StatementInvalid) &&
       !e.is_a?(ActiveRecord::RecordNotUnique) &&
       !e.cause.class.name.include?('Busy')
      raise e
    end

    message = if e.is_a?(ArgumentError) || e.is_a?(ActiveRecord::RecordInvalid)
                e.message
              else
                'Please retry; the record may have changed.'
              end
    redirect_to opportunity, alert: 'Registration failed: ' + message
  end

  private
  def scope
    current_user.role == 'organization' ? current_user.opportunities : Opportunity.all
  end

  def organization_only
    require_role('organization')
  end

  def opportunity_params
    params.require(:opportunity).permit(:title, :description, :category, :location, :starts_at, :ends_at, :capacity, :status)
  end

end
