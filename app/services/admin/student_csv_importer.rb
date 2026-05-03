# frozen_string_literal: true

require "csv"

module Admin
  class StudentCsvImporter
    def initialize(school:, csv_io:)
      @school = school
      @csv_io = csv_io
    end

    def call
      return { created: 0, errors: [ "No file" ] } if @csv_io.blank?

      text = @csv_io.respond_to?(:read) ? @csv_io.read : File.read(@csv_io.path)
      created = 0
      errors = []
      CSV.parse(text, headers: true).each.with_index(2) do |row, line|
        section = Section.unscoped.find_by(id: row["section_id"])
        unless section&.school_id == @school.id
          errors << "Line #{line}: invalid section_id"
          next
        end
        student = Student.new(
          school: @school,
          section: section,
          admission_no: row["admission_no"],
          full_name: row["full_name"],
          gender: row["gender"],
          guardian_name: row["guardian_name"],
          guardian_phone: row["guardian_phone"]
        )
        if student.save
          created += 1
        else
          errors << "Line #{line}: #{student.errors.full_messages.join(', ')}"
        end
      end
      { created: created, errors: errors }
    end
  end
end
