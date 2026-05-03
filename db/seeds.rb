# frozen_string_literal: true

school = School.find_or_initialize_by(slug: "demo")
school.assign_attributes(
  name: "Demo School",
  time_zone: "Asia/Kolkata",
  settings: { "attendance_halves_enabled" => true, "any_teacher_can_mark_bus" => false }
)
school.save!

admin = User.find_or_initialize_by(school: school, email_address: "admin@demo.test")
admin.assign_attributes(full_name: "Demo Admin", role: :admin, active: true)
admin.password = "password123"
admin.password_confirmation = "password123"
admin.save!

teacher = User.find_or_initialize_by(school: school, email_address: "teacher@demo.test")
teacher.assign_attributes(full_name: "Demo Teacher", role: :teacher, active: true)
teacher.password = "password123"
teacher.password_confirmation = "password123"
teacher.save!

Current.session = admin.sessions.create!(user_agent: "seed", ip_address: "127.0.0.1")

ay = AcademicYear.find_or_create_by!(school: school, name: "2025-26") do |y|
  y.starts_on = Date.new(2025, 4, 1)
  y.ends_on = Date.new(2026, 3, 31)
  y.current = true
end
AcademicYear.where(school: school).where.not(id: ay.id).update_all(current: false)

sc = SchoolClass.find_or_create_by!(school: school, name: "Class 5") { |c| c.position = 5 }

section = Section.find_or_create_by!(school: school, school_class: sc, academic_year: ay, name: "A") do |s|
  s.class_teacher = teacher
end

TeacherAssignment.find_or_create_by!(user: teacher, section: section, role: :class_teacher) do |a|
  a.school = school
end

5.times do |i|
  Student.find_or_create_by!(school: school, admission_no: "DEMO-#{i + 1}") do |st|
    st.section = section
    st.full_name = "Student #{i + 1}"
    st.gender = "other"
  end
end

bus = Transport::Bus.find_or_create_by!(school: school, plate_no: "KA-01-AB-1234") do |b|
  b.name = "Bus 1"
  b.capacity = 40
  b.in_charge_user = teacher
end

[ "Stop A", "Stop B", "Stop C" ].each_with_index do |name, idx|
  Transport::BusStop.find_or_create_by!(bus: bus, position: idx + 1) do |stop|
    stop.school = school
    stop.name = name
  end
end

Current.session = nil

puts "Seeded Demo School. admin@demo.test / teacher@demo.test — password: password123"
