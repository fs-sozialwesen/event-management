class Category < ApplicationRecord

  include PgSearch

  validates :name, presence: true
  validates :position, uniqueness: { scope: [:year, :parent_id] }
  validate :acyclic_graph

  # belongs_to :catalog, foreign_key: :year, primary_key: :year, inverse_of: :categories
  has_and_belongs_to_many :seminars

  belongs_to :parent, class_name: 'Category', inverse_of: :children
  has_many :children, -> { order :position }, class_name: 'Category', foreign_key: 'parent_id', inverse_of: :parent
  scope :roots, -> { where(parent_id: nil).order(:position) }
  scope :archived, -> { where archived: true }
  scope :published, -> { where archived: false }

  after_save :invalidate_descendants_cache

  has_paper_trail ignore: [:position]

  multisearchable against: [:name]

  def self.tree
    tree_for roots
  end

  def sub_tree
    self.class.tree_for children
  end

  def self.tree_for(categories)
    return nil unless categories.any?
    categories.each_with_object({}) { |cat, res| res[cat.name] = cat.sub_tree }
  end

  def root?
    parent.blank?
  end

  def display_name
    [number, name].select(&:present?).join(' ')
  end

  def all_seminars
    seminar_ids = Category.select(:seminar_id).joins(:categories_seminars).where(id: descendant_ids)
    Seminar.where(id: seminar_ids)
  end

  def to_param
    "#{id}-#{slug}"
  end

  def slug
    s = I18n.transliterate(name.downcase).delete('"').gsub(/[^a-z0-9]+/, '-')
    n = number.delete ' '
    # n = "#{category.number}.#{n}" if category.present?
    "#{n}-#{s}"
  end

  # returns an array of nav entries reflecting the path from the root to this entry
  def path
    (parent&.path || []) + [ self ]
  end

  # returns an array of all children's children including the nav entry itself
  def descendants
    [self] + children.includes(:children).flat_map(&:descendants)
  end

  def move(direction)
    case direction.to_sym
    when :up    then swap_position_with predecessor
    when :down  then swap_position_with successor
    when :left  then set_parent_to parent&.parent&.id
    when :right then predecessor && set_parent_to(predecessor.id)
    else raise 'unknown direction'
    end
  end

  def calculate_position
    self.position = self.class.next_position_for year, parent_id
  end

  def descendants_cache_key
    "#{cache_key}/descendant_ids"
  end

  private

  def descendant_ids
    Rails.cache.fetch(descendants_cache_key) { descendants.flat_map(&:id) }
  end

  def invalidate_descendants_cache
    self.class.find_each { |cat| Rails.cache.clear cat.descendants_cache_key }
  end

  def self.next_position_for(year, parent_id)
    (where(year: year, parent_id: parent_id).maximum(:position) || 0) + 1
  end

  def successor
    siblings.where('position > ?', position).order(:position).first
  end

  def predecessor
    siblings.where('position < ?', position).order(position: :desc).first
  end

  def siblings
    self.class.where(parent_id: parent_id)
  end

  def swap_position_with(other)
    return unless other
    new_position = other.position
    old_position = position
    self.class.transaction do
      other.update! position: 9999
      update! position: new_position
      other.update! position: old_position
    end
  end

  def set_parent_to(new_parent_id)
    position = self.class.next_position_for year, new_parent_id
    update! parent_id: new_parent_id, position: position
  end

  def acyclic_graph
    errors.add(:parent, 'could not be one of the descendants') if parent.in? descendants
  end
end
