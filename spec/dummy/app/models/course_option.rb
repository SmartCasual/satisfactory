class CourseOption < ApplicationRecord
  has_many :application_choices, inverse_of: :course_option, dependent: :destroy

  def full_time?
    !part_time?
  end
end
