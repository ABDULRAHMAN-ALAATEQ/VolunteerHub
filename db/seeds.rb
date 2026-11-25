abort 'Demo seeds are restricted to development/test.' if Rails.env.production?
password = 'Volunteer123!'
accounts = [
   ['Sara Ahmed','student@demo.test','student'],
  ['Campus Community Club','organization@demo.test','organization'],
  ['Student Affairs Deanship','deanship@demo.test','deanship'],
  ['Omar Ali','student2@demo.test','student'],
  ['Green Campus Society','green@demo.test','organization']
]
users = accounts.map do |name,email,role|
  User.find_or_create_by!(email: email) do |u|
    u.name = name
    u.role = role
    u.password = password
    u.password_confirmation = password
  end
end
student, org, deanship, student2, green = users
base = Time.current.beginning_of_day
opportunities = [
  [org,'Campus welcome ambassadors',
  'Campus','Student Centre',
  'Welcome incoming students, help with orientation and direct visitors to campus services.',
  7,9,3,20],
  [green,'Green campus clean-up','Environment',
  'North Campus Garden','Join a community clean-up and help maintain shared green spaces.',
  5,8,3,16],
  [org,'Peer study support',
  'Education','University Library',
  'Support fellow students with study strategies and library resources.',
  9,13,2,12],
  [org,'Community food drive',
  'Community','Community Hall','Sort donations and prepare packages for distribution to local families.',
  -5,9,4,24],
  [green,'Campus recycling workshop',
  'Environment',
  'Activity Room B','Help deliver a workshop on sorting and responsible recycling.',
  -3,10,3,15],
  [org,'Health awareness booth',
  'Health','Main Atrium',
  'Support an awareness campaign and distribute educational materials.',
  -8,10,3,18]
]
records = opportunities.map do |owner,title,category,location,description,days,hour,duration,capacity|
  owner.opportunities.find_or_create_by!(title: title) do |o|
    o.category = category; o.location = location; o.description = description;
    o.starts_at = base + days.days + hour.hours;
    o.ends_at = o.starts_at + duration.hours; o.capacity = capacity;
    o.status = days.negative? ? 'closed' : 'open'
  end
end
[[records[3],student],[records[4],student],[records[5],student2]].each_with_index do |(op,person),i|
  r = Registration.find_or_create_by!(opportunity: op, student: person)
  if i == 1 && r.status == 'registered'
    r.submit!(2,'Helped organise workshop materials and guide participants.')
    r.review!('approved','Activity confirmed.',deanship)
    Certificate.issue!(r,deanship)
  elsif i == 2 && r.status == 'registered'
    r.submit!(2.5,'Prepared information packs and staffed the awareness booth.')
  end
end
puts 'Demo accounts and activities ready.'
