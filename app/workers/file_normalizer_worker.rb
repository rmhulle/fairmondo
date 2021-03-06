class FileNormalizerWorker
  include Sidekiq::Worker

  sidekiq_options queue: :file_normalizer,
                  retry: 5,
                  backtrace: true

  def perform article_id
    article = Article.unscoped.find article_id

    article.images.each do |image|
      # get the path to the image
      path = "/var/www/fairnopoly/shared/#{image.image.path(:cut_here)}"

      # get the filename of the image as referenced in image object
      orig_filename = path[path.rindex('/') + 1..-1]

      # get the base directory before the style directories
      index = path.index('cut_here') - 1
      path = path[0..index]

      # get the paths to the image files in the style directories
      files = Dir.glob("#{path}original/*")

      old_filepath = files.first
      old_filename = old_filepath[old_filepath.rindex('/') + 1..-1]

      unless orig_filename == old_filename
        image.update_column :image_file_name, old_filename
      end
      # files.each do |file|
      #   File.rename(file, file[0..file.rindex('/')] + orig_filename)
      # end
      # # index changed articles
      # Indexer.index_article(article)
    end
  end
end
