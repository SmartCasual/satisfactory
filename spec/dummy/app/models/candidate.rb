class Candidate < ApplicationRecord
  has_many :application_forms, dependent: :destroy, inverse_of: :candidate
end
