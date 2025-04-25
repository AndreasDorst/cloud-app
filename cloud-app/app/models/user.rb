class User < ApplicationRecord
  has_many :orders
  has_one :passport_data
  scope :long_name_short_surname, -> { where("LENGTH(first_name) > 5 AND LENGTH(last_name) < 6") }
  # validates :first_name,
  #           length: { minimum: 3 },
  #           format: { with: /\A[А-Я][а-я]*\z/, message: "must contain only Russian letters and start with a capital letter" }
  # validates :last_name,
  #           length: { minimum: 3 },
  #           format: { with: /\A[А-Я][а-я]*\z/, message: "must contain only Russian letters and start with a capital letter" }
end
