# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  belongs_to :school
  has_many :sessions, dependent: :destroy
  has_many :teacher_assignments, dependent: :destroy
  has_many :sections_as_class_teacher, class_name: "Section", foreign_key: :class_teacher_id, inverse_of: :class_teacher, dependent: :nullify
  has_many :buses_in_charge, class_name: "Transport::Bus", foreign_key: :in_charge_user_id, inverse_of: :in_charge_user, dependent: :nullify

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  enum :role, { admin: 0, teacher: 1 }, default: :teacher

  validates :email_address, presence: true, uniqueness: { scope: :school_id }
  validates :full_name, presence: true

  generates_token_for :password_reset, expires_in: 15.minutes do
    password_salt&.last(10)
  end

  def inactive?
    !active?
  end
end
