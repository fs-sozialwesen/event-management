class TeacherPolicy < ApplicationPolicy
  who_can(:index?)    { editor? || trainee? }
  who_can(:show?)     { editor? || trainee? }
  who_can(:create?)   { editor? || trainee? }
  who_can(:update?)   { editor? || trainee? }
  who_can(:seminars?) { editor? || trainee? }
end
