class CatalogPolicy < ApplicationPolicy
  alias catalog record

  who_can(:index?)         { editor? || layouter? }
  who_can(:show?)          { admin? || editor? || layouter? }
  who_can(:make_current?)  { true }
end
