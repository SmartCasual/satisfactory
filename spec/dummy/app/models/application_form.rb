class ApplicationForm < ApplicationRecord
  belongs_to :candidate, inverse_of: :application_forms
  has_many :application_choices, inverse_of: :application_form, dependent: :destroy
end
