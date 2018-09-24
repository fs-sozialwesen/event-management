class BookingPolicy < ApplicationPolicy
  who_can(:show?)   { editor? || finance? }
  who_can(:create?) { editor? || finance? }
end
