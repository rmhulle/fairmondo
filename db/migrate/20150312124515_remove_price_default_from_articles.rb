class RemovePriceDefaultFromArticles < ActiveRecord::Migration
  def up
    change_column_default(:articles, :price_cents, nil)
  end

  def down
    change_column_default(:articles, :price_cents, 100)
  end
end
