class SearchPolicy < ApplicationPolicy

  who_can(:index?) { editor? || layouter? || finance? || trainee? }

end
