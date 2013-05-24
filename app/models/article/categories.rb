module Article::Categories
  extend ActiveSupport::Concern

  included do


    attr_accessible :categories_and_ancestors,:category_proposal
     attr_accessor :category_proposal

    # categories refs #154
    has_and_belongs_to_many :categories
    validates :categories, :size => {
      :in => 1..2,
      :add_errors_to => [:categories, :categories_and_ancestors]
    }
    before_validation :ensure_no_redundant_categories # just store the leafs to avoid inconsistencies


  end

  def categories_and_ancestors
    @categories_and_ancestors ||= (categories && categories.map(&:self_and_ancestors).flatten.uniq) || []
  end

  def categories_and_ancestors=(categories)
    if categories.first.is_a?(String) || categories.first.is_a?(Integer)
      categories = categories.select(&:present?).map(&:to_i)
      categories = Category.where(:id => categories)
    end
    # remove entries which parent is not included in the subtree
    # e.g. you selected Hardware but unselected Computer afterwards
    @categories_and_ancestors = categories.select{|c| c.include_all_ancestors?(categories) }
    # remove all parents
    self.categories = Article::Categories.remove_category_parents(@categories_and_ancestors)
  end

  def self.remove_category_parents(categories)
    # does not hit the database
    categories.reject{|c| categories.any? {|other| c!=nil && other.is_descendant_of?(c) } }
  end


  def ensure_no_redundant_categories
    self.categories = Article::Categories.remove_category_parents(self.categories) if self.categories
    true
  end
  private :ensure_no_redundant_categories

  # For Solr searching we need category ids
  def self.search_categories(categories)
    ids = []
    categories = Article::Categories.remove_category_parents(categories)

    categories.each do |category|
     category.self_and_descendants.each do |fullcategories|
        ids << fullcategories.id
      end
    end
    ids
  end


end
