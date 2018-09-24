class User < ApplicationRecord

  ROLES = %i(admin user editor layouter cms_admin finance trainee).freeze
  has_many :edited_seminars, class_name: 'Seminar', foreign_key: :editor_id

  ROLES.each do |role|
    scope role.to_s.pluralize, -> { where("'#{role}' = ANY(roles)") }

    define_method("#{role}?") { has_role? role }
    define_method("#{role}!") do
      roles << role
      save
    end
  end

  after_initialize { self.roles ||= [] }
  before_save      { self.roles = roles.select(&:present?) }

  # enum role: { user: 0, admin: 1, editor: 2, layouter: 3 }
  after_initialize :set_default_role, if: :new_record?

  validates :email, :username, presence: true

  has_paper_trail
  acts_as_taggable
  acts_as_tagger

  def set_default_role
    roles << 'user' if roles.blank?
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def alchemy_roles
    # member, author, editor, admin
    cms_admin? || admin? ? %w(admin) : []
  end

  def has_role?(role)
    role.to_s.in? roles
  end

end
