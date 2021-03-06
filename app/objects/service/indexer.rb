class Indexer
  def self.index_article article
    SearchIndexWorker.perform_async(:article, article.id)
  end

  def self.index_articles article_ids
    article_ids.each do |id|
      SearchIndexWorker.perform_async(:article, id)
    end
  end

  def self.index_mass_upload mass_upload_id
    activation_ids = MassUpload.find(mass_upload_id).articles_for_mass_activation.pluck(:id)
    Indexer.index_articles activation_ids
  end
end
