class ApplicationPolicy
  attr_reader :user, :record
  delegate :admin?, to: :user

  def self.who_can(action, &block)
    define_method action, &block
  end

  def initialize(user, record)
    @user = user
    @record = record
  end

  who_can(:index?)    { editor? }
  who_can(:show?)     { editor? }
  who_can(:create?)   { admin?  }
  who_can(:new?)      { create? }
  who_can(:update?)   { admin?  }
  who_can(:edit?)     { update? }
  who_can(:destroy?)  { admin?  }

  def editor?
    admin? || user.editor?
  end

  def layouter?
    admin? || user.layouter?
  end

  def finance?
    admin? || user.finance?
  end

  def trainee?
    admin? || user.trainee?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
