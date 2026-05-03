# frozen_string_literal: true

module Transport
  class BusStop < ApplicationRecord
    include SchoolScoped

    self.table_name = "bus_stops"

    belongs_to :bus, class_name: "Transport::Bus"
    has_many :bus_stop_progresses, class_name: "Transport::BusStopProgress", foreign_key: :bus_stop_id,
      inverse_of: :bus_stop, dependent: :destroy

    validates :name, presence: true
    validates :position, uniqueness: { scope: :bus_id }

    scope :by_position, -> { order(:position, :id) }
  end
end
