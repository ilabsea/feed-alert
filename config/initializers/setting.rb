SETTING = YAML.load_file('config/application.yml')[Rails.env] rescue {}

class Setting
  def self.nuntium_admin?
    SETTING["IS_NUNTIUM_ADMIN"] === 'true' || SETTING["IS_NUNTIUM_ADMIN"] === '1'
  end
end
