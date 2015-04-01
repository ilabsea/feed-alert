class AlertMailerPreview < ActionMailer::Preview
  def notify_matched
    content =<<-eos
      <p> The disease is transmitted most commonly by an infected female Anopheles mosquito. The mosquito bite introduces the parasites from the mosquito's saliva into a person's blood.[1] The parasites then travel to the liver where they mature and reproduce. Five species of Plasmodium can infect and be spread by humans.</p>

      <p>[2] Most deaths are caused by P. falciparum because P. vivax, P. ovale, and P. malariae generally cause a milder form of malaria.[1][2] The species P. knowlesi rarely causes disease in humans.[1] Malaria is typically diagnosed by the microscopic examination of blood using blood films, or with antigen-based rapid diagnostic tests.[2]</p>

      <p>Methods that use the polymerase chain reaction to detect the parasite's DNA have been developed, but are not widely used in areas where malaria is common due to their cost and complexity.[3]</p>

      <p>The risk of disease can be reduced by preventing mosquito bites by using mosquito nets and insect repellents, or with mosquito-control measures such as spraying insecticides and draining standing water.</p>

      <p>[2] Several medications are available to prevent malaria in travellers to areas where the disease is common. Occasional doses of the medication sulfadoxine/pyrimethamine are recommended in infants and after the first trimester of </p>

      <p> The risk of disease can be reduced by preventing mosquito bites by using mosquito nets and insect repellents, or with mosquito-control measures such as spraying insecticides and draining standing water.[2] Several medications are available to prevent malaria in travellers to areas where the disease is common. Occasional doses of the medication sulfadoxine/pyrimethamine are recommended in infants and after the first trimester of pregnancy in areas with high rates of malaria.</p>

      <p> Despite a need, no effective vaccine exists, although efforts to develop one are ongoing.[1] The recommended treatment for malaria is a combination of antimalarial medications that includes an artemisinin.[1][2] The second medication may be either mefloquine, lumefantrine, or sulfadoxine/pyrimethamine.[4] Quinine along with doxycycline may be used if an artemisinin is not available.</p>
      <p>
      [4] It is recommended that in areas where the disease is common, malaria is confirmed if possible before treatment is started due to concerns of increasing drug resistance. Resistance has developed to several antimalarial medications; for example, chloroquine-resistant P. falciparum has spread to most malarial areas, and resistance to artemisinin has become a problem in some parts of Southeast Asia.</p>

      <p> In drier areas, outbreaks of malaria have been predicted with reasonable accuracy by mapping rainfall.[115] Malaria is more common in rural areas than in cities. For example, several cities in the Greater Mekong Subregion of Southeast Asia are essentially malaria-free, but the disease is prevalent in many rural regions, including along international borders and forest fringes.[116] In contrast, malaria in Africa is present in both rural and urban areas, though the risk is lower in the larger cities.</p>
    eos

    Struct.new("FeedEntry", :title, :url, :content, :keywords)

    url = "http://www.google.com"
    keywords1 = ['disease', 'mosquito', 'malaria', 'blood', 'medications']
    keywords2 = ['insecticides', 'polymerase', 'diagnostic', 'resistance', 'outbreak']
    keywords3 = ['asia', 'drug', 'prevent', 'antimalarial', 'concerns']

    feed_entry_1 = Struct::FeedEntry.new('CDC Malaria', url, content, keywords1)
    feed_entry_2 = Struct::FeedEntry.new('Disease surveilance', url, content, keywords2)
    feed_entry_3 = Struct::FeedEntry.new('Outbreak Asia', url, content, keywords3)

    feed_entries = [feed_entry_1, feed_entry_2, feed_entry_3]

    Struct.new("Alert", :id, :name, :url, :feed_entries ) do
      def matched_in_between(date_range)
        feed_entries
      end
    end

    alert = Struct::Alert.new(1, "CDC Disease Surveilance Report", 'http://www.example.com/rss.xml', feed_entries)

    Struct.new("Group", :name, :description)
    group = Struct::Group.new('Department of Help', "We are a team to monitor all the help related things...")

    emails_to = ['channa.info@gmail.com', 'channa.info+1@gmail.com']
    date_range = DateRange.new(Time.zone.now - 7.days, Time.zone.now)

    AlertMailer.notify_matched(alert, group, emails_to, date_range)
  end



end