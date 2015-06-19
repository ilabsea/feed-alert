module NuntiumConnector
  extend ActiveSupport::Concern


  included do
    before_create :random_password, unless: :global_setup?

    after_create  :register_nuntium_channel, unless: :global_setup?
    after_update  :update_nuntium_channel, unless: :global_setup?
    after_destroy :delete_nuntium_channel, unless: :global_setup?
  end


  module ClassMethods
    def nuntium
      # @@nuntium ||= Nuntium.new ENV['NUNTIUM_HOST'], ENV['NUNTIUM_ACCOUNT'], ENV['NUNTIUM_APP'], ENV['NUNTIUM_APP_PWD']
      Sms.instance.nuntium
    end

    def end_point
      ENV['NUNTIUM_HOST'] + '/' + ENV['NUNTIUM_ACCOUNT'] + '/qst'
    end

    def global_sms_channel
      [ { name: 'International Gateway(clickatell)', code: 'clickatell44911'},
       { name: 'Lao National Gateway(etl)', code: 'etl' },
       { name: 'Cambodia National Gateway(smart)', code: 'smart'},
       { name: "Cambodia National Gateway(mobitel)",code: 'camgsm'} ].map{|c| [c[:name], c[:code] ]}
    end
  end

  def random_password
    self.password = SecureRandom.base64(6) if self.password.blank?
  end

  def nuntium
    self.class.nuntium
  end

  def nuntium_channel_name
    global_setup? ? self.name : "#{self.name}-#{self.id}"
  end

  def handle_nuntium_channel_response(response)
    raise get_error_from_nuntium_response(response) if not response['name'] == self.nuntium_channel_name
    response
  end

  def register_nuntium_channel
    config = {
      :name => self.nuntium_channel_name, 
      :kind => 'qst_server',
      :protocol => 'sms',
      :direction => 'bidirectional',
      :enabled => true,
      :restrictions => '',
      :priority => 50,
      :configuration => { 
        :password => self.password,
        :friendly_name => self.name
      }
    }
    
    basic_options = { ticket_code: self.ticket_code,
                      ticket_message: "This phone will be used for as SMS gateway for #{ENV['APP_NAME']}." }

    config.merge!(basic_options) if basic_setup?
    response = nuntium.create_channel(config)
    handle_nuntium_channel_response response
  end

  def update_nuntium_channel
    config_options = { name: self.nuntium_channel_name,
                       enabled: true,
                       restrictions: '',
                       configuration: { 
                        friendly_name: self.name,
                        password: self.password
                       }
                     }
    response = nuntium.update_channel(config_options)
    handle_nuntium_channel_response response
  end

  def get_error_from_nuntium_response(response)
    return "Error processing nuntium channel" if not response['summary']
    error = response['summary'].to_s
    unless response['properties'].blank?
      error << ': '
      error << response['properties'].map do |dict|
        dict.map{|k,v| "#{k} #{v}"}.join('; ')
      end.join('; ')
    end
    error
  end

  def delete_nuntium_channel
    nuntium.delete_channel(self.nuntium_channel_name)
    true
  end

  def nuntium_info
    response = nuntium.channel(self.nuntium_channel_name)
    @nuntium_info ||= handle_nuntium_channel_response(response)
  end

  def client_connected
    nuntium_info['connected'] rescue nil
  end
end