class Routine < ApplicationRecord
  belongs_to :user
  has_many :notifications, dependent: :destroy
end
