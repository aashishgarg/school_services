# frozen_string_literal: true

module Transport
  class Bus < ApplicationRecord
    include SchoolScoped

    self.table_name = "buses"

    belongs_to :in_charge_user, class_name: "User", optional: true
    has_many :bus_stops, class_name: "Transport::BusStop", foreign_key: :bus_id, inverse_of: :bus, dependent: :destroy
    has_many :bus_trips, class_name: "Transport::BusTrip", foreign_key: :bus_id, inverse_of: :bus, dependent: :destroy
    has_many :students, class_name: "Student", foreign_key: :bus_id, inverse_of: :bus, dependent: :nullify

    validates :name, :plate_no, presence: true
    validates :plate_no, uniqueness: { scope: :school_id }
  end
end
