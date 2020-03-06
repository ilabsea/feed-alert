class MigrateKeywordsToKeywordSets < ActiveRecord::Migration
  def up
    Project.find_each do |project|
      user_id = project.user_id

      project.alerts.each do |alert|
        keywords = alert.keywords.map {|k| k.name.strip }.sort_by(&:downcase).join(',')
        keyword_set = KeywordSet.find_by(keyword: keywords, user_id: user_id)

        if keyword_set.nil?
          name = "default-#{SecureRandom.hex(4)}"
          keyword_set = KeywordSet.create(name: name, keyword: keywords, user_id: user_id)
        end

        AlertKeywordSet.create(alert_id: alert.id, keyword_set_id: keyword_set.id)
      end
    end
  end
end
