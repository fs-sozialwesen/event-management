class Teaching < ApplicationRecord
  belongs_to :seminar
  belongs_to :teacher
end
