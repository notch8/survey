class Survey::Question < ActiveRecord::Base

  extend Enumerize
  
  QUESTION_TYPES = { text: 1, radio: 2, checkboxes: 3 }.freeze
  
  enumerize :question_type, in: QUESTION_TYPES 
  
  self.table_name = "survey_questions"

  acceptable_attributes :text, :survey, :question_type, :options_attributes => Survey::Option::AccessibleAttributes

  # relations
  belongs_to :survey
  has_many   :options, :dependent => :destroy
  accepts_nested_attributes_for :options,
    :reject_if => ->(a) { a[:text].blank? },
    :allow_destroy => true

  # validations
  validates :question_type, presence: true
  validates :text, :presence => true, :allow_blank => false

  def correct_options
    return options.correct
  end

  def incorrect_options
    return options.incorrect
  end
end
