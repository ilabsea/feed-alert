class IndexerJob < ActiveJob::Base
  attr_accessor :record
  queue_as :indexer

  Logger = Sidekiq.logger.level == Logger::DEBUG ? Sidekiq.logger : nil
  Client = Elasticsearch::Client.new host: (ENV['ELASTICSEARCH_URL'] || 'http://localhost:9200'), logger: Logger

  after_perform do |job|
    p "*****************************************"
    p "#{job.arguments}"
    p "#{job.arguments[3]}"
    is_finished = true
    queue = Sidekiq::Queue.new(:indexer)
    p queue
    p "queue size #{queue.size}"
    queue.each do |job|
      p "______________________________________________________________"
      p job.args
      if job.args[3] == job.arguments[3]
        is_finished = false
        break
      end
    end

    if is_finished
      ApplySearch.run
    end
  end

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
