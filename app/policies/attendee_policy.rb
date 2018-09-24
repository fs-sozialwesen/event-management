class AttendeePolicy < ApplicationPolicy

  who_can(:index?)   { editor? || finance? }
  who_can(:show?)    { editor? || finance? }
  who_can(:destroy?) { editor? || finance? }
  who_can(:cancel?)  { destroy? || finance? }
  who_can(:update?)  { editor? || finance? }
  who_can(:company?) { editor? || finance? }

end
