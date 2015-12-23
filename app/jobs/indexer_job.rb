class IndexerJob < ActiveJob::Base
  attr_accessor :record
  queue_as :indexer

  Logger = Sidekiq.logger.level == Logger::DEBUG ? Sidekiq.logger : nil
  Client = Elasticsearch::Client.new host: (ENV['ELASTICSEARCH_URL'] || 'http://localhost:9200'), logger: Logger

  def perform(operation, klass, record_id, alert_id, options={})
    logger.debug [operation, ": #{klass}##{record_id} #{options.inspect}"]
    case operation
      when /index|update/
        record = klass.constantize.find(record_id)
        if(record.content.present?)
          record.__elasticsearch__.client = Client
          record.__elasticsearch__.__send__ "#{operation}_document"
        end
      when /delete/
        Client.delete index: klass.constantize.index_name, type: klass.constantize.document_type, id: record_id
      else raise ArgumentError, "Unknown operation '#{operation}'"
    end
  end

end
