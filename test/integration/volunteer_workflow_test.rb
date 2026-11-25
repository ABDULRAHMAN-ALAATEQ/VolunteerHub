require 'test_helper'
class VolunteerWorkflowTest < ActionDispatch::IntegrationTest
  setup do
    @student = create_user('student')
    @other = create_user('student')
    @org = create_user('organization')
    @another_org = create_user('organization')
    @admin = create_user('deanship')
    @future = create_opportunity(@org, 2.days.from_now, 1)
    @past = create_opportunity(@org, 2.days.ago, 10)
    @registration = Registration.create!(opportunity: @past, student: @student)
  end
  test 'authentication, role access and organization ownership' do
    get root_path
    assert_redirected_to login_path
    post login_path, params: {email: @student.email, password: "incorrect"}
    assert_response :unprocessable_entity
    login(@student)
    get new_opportunity_path
    assert_response :forbidden
    login(@another_org)
    get edit_opportunity_path(@future)
    assert_response :not_found
    patch opportunity_path(@future), params: {opportunity: {title: 'Unauthorised'}}
    assert_response :not_found
    assert_not_equal 'Unauthorised', @future.reload.title
  end
  test 'organization creates edits and filters its own opportunities' do
    login(@org)
    get new_opportunity_path
    assert_response :success
    assert_difference 'Opportunity.count', 1 do
      post opportunities_path, params: {opportunity: {title: 'New workshop', description: 'Help', category: 'Education', location: 'Library', starts_at: 3.days.from_now, ends_at: 3.days.from_now + 2.hours, capacity: 5, status: 'open'}}
    end
    record = Opportunity.find_by!(title: 'New workshop')
    patch opportunity_path(record), params: {opportunity: {title: 'Updated workshop'}}
    assert_equal 'Updated workshop', record.reload.title
    get opportunities_path, params: {q: 'Updated', category: 'Education'}
    assert_response :success
    assert_select 'h3', 'Updated workshop'
  end
  test 'registration prevents duplicate and over-capacity requests' do
    login(@student)
    assert_difference 'Registration.count', 1 do
      post register_opportunity_path(@future)
    end
    assert_no_difference 'Registration.count' do
      post register_opportunity_path(@future)
    end
    login(@other)
    assert_no_difference 'Registration.count' do
      post register_opportunity_path(@future)
      post register_opportunity_path(@past)
    end
  end
  test 'submission rejection correction approval certificate and access' do
    login(@other)
    post submit_hours_path(@registration), params: {hours: 1, activity_note: 'Not mine'}
    assert_response :not_found
    login(@student)
    post submit_hours_path(@registration), params: {hours: 4, activity_note: 'Too many'}
    assert_equal 'registered', @registration.reload.status
    post submit_hours_path(@registration), params: {hours: 2, activity_note: 'Assisted visitors'}
    assert_equal 'submitted', @registration.reload.status
    patch review_registration_path(@registration), params: {decision: 'approved'}
    assert_response :forbidden
    login(@admin)
    assert_no_difference 'Certificate.count' do
      post issue_certificate_path(@registration)
    end
    patch review_registration_path(@registration), params: {decision: 'rejected'}
    assert_equal 'submitted', @registration.reload.status
    patch review_registration_path(@registration), params: {decision: 'rejected', review_note: 'Clarify task'}
    assert_equal 'rejected', @registration.reload.status
    login(@student)
    post submit_hours_path(@registration), params: {hours: 2, activity_note: 'Assisted visitors at entrance'}
    login(@admin)
    patch review_registration_path(@registration), params: {decision: 'approved'}
    assert_equal 'approved', @registration.reload.status
    assert_difference 'Certificate.count', 1 do
      post issue_certificate_path(@registration)
    end
    cert = @registration.reload.certificate
    assert_no_difference 'Certificate.count' do
      post issue_certificate_path(@registration)
    end
    login(@student)
    get certificate_path(cert)
    assert_response :success
    assert_select 'h2', @student.name
    login(@other)
    get certificate_path(cert)
    assert_response :forbidden
  end
  test 'dashboard renders for all roles' do
    [@student,@org,@admin].each do |user|
      login(user)
      get root_path
      assert_response :success
    end
  end
  private
  def create_user(role)
    User.create!(name: "Demo #{role}", email: "#{SecureRandom.hex(6)}@test.example", role: role, password: 'Password123!')
  end
  def create_opportunity(owner, start, capacity)
    owner.opportunities.create!(title: 'Test activity', description: 'Description', category: 'Campus', location: 'Hall', starts_at: start, ends_at: start + 3.hours, capacity: capacity, status: 'open')
  end
  def login(user)
    post login_path, params: {email: user.email, password: 'Password123!'}
    assert_redirected_to root_path
  end
end
