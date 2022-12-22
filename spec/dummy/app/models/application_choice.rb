class ApplicationChoice < ApplicationRecord
  belongs_to :application_form, inverse_of: :application_choices
  belongs_to :course_option, class_name: 'CourseOption', inverse_of: :application_choices
end
