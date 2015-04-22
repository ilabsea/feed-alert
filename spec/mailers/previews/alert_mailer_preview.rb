class AlertMailerPreview < ActionMailer::Preview
  def notify_matched
    search_highligh = [
      {"_source"=>
         {"id"=>1489,
          "title"=>"Delayed-Onset Hemolytic Anemia in Patients with Travel-Associated Severe Malaria Treated with Artesunate, France, 2011–2013",
          "keywords"=>["malaria", "surveilance", "HIN5", "Disease", "patient", "hiv", "aid"],
          "created_at"=>"2015-04-09T04:45:49.000Z",
          "url"=>"http://wwwnc.cdc.gov/eid/article/21/5/14-1171",
          "alert_id"=>1
        },

        "highlight"=>
         {"content"=> ["Emerging Infectious <em class='highlight'>Disease</em> journal\n    ISSN: 1080-6059\ ",
            "Ahead of Print / In Press\tDelayed-Onset Hemolytic Anemia in Patients with Travel-Associated Severe <em class='highlight'>Malaria</em> Treated with Artesunate, France, 2011–2013\n\n\n\tAuthor Resource Center\tTypes of Articles\n\tTypeface",
            "Health Days\tWorld AIDS Day\n\tWorld Health Day\n\tWorld Hepatitis Day\n\tWorld Immunization Week\n\tWorld <em class='highlight'>Malaria</em> Day\n\tWorld Pneumonia Day\n\tWorld Rabies Day\n\tWorld TB Day\n\n\n\n\n\tSocial Media\tRSS Feeds\tRSS Help\n\n\n",
            "Public Health Image Library (PHIL)and" ]}},

 {"_source"=>
   {"id"=>1473,
    "title"=>"Chikungunya, Dengue, and Malaria Co-Infection after Travel to Nigeria, India",
    "keywords"=>["malaria", "surveilance", "HIN5", "Disease", "patient", "hiv", "aid"],
    "created_at"=>"2015-04-09T04:45:48.000Z",
    "url"=>"http://wwwnc.cdc.gov/eid/article/21/5/14-1804",
    "alert_id"=>1},

  "highlight"=>
   {"content"=> ["India Public Health Image Library (PHIL tion after Travel to Nigeria, India\n\n\n \n On This Page\n\n\t\t\t\t\tLetter\n\tSuggested"],
    "title"=>["Chikungunya, Dengue, and <em class='highlight'>Malaria</em> Co-Infection after Travel to Nigeria, India"]}},

 {"_source"=>
   {"id"=>1491,
    "title"=>"Molecular Epidemiology of Malaria Outbreak, Tumbes, Peru, 2010–2012",
    "keywords"=>["malaria", "surveilance", "HIN5", "Disease", "patient", "hiv", "aid"],
    "created_at"=>"2015-04-09T04:45:49.000Z",
    "url"=>"http://wwwnc.cdc.gov/eid/article/21/5/14-1427",
    "alert_id"=>1},

  "highlight"=>
   {"content"=>["Tumbes, Peru, 2010–2012\n\n\n\tAuthor Resource Center\tTypes of Articles\n\tTypeface\n\tManuscript",
    "ld Pneumonia Day\n\tWorld Rabies Day\n\tWorld TB Day Social Media\tRSS Feeds\tRSS Help\n\n\n",
    "CDC Vital Signs Public Health Image Library (PHIL)\n\tOn This Page\n\n\t\t\t\t\tMaterials and Methods"],
    "title"=>["Molecular Epidemiology of <em class='highlight'>Malaria</em> Outbreak, Tumbes, Peru, 2010–2012"]}},

 {"_source"=>
   {"id"=>1458,
    "title"=>"Evaluation of Patients under Investigation for MERS-CoV Infection, United States, January 2013–October 2014",
    "keywords"=>["malaria", "surveilance", "HIN5", "Disease", "patient", "hiv", "aid"],
    "created_at"=>"2015-04-09T04:45:48.000Z",
    "url"=>"http://wwwnc.cdc.gov/eid/article/21/7/14-1888",
    "alert_id"=>1},
  "highlight"=>
   {"content"=>["al\n    ISSN: 1080-6059\n\n\n                    \n\n                    \n                    \n  ",
      "ld Pneumonia Day\n\tWorld Rabies Day\n\tWorld TB Day\n\n\n\n\n\tSocial Media\tRSS Feeds\tRSS Help\n\n\n",
      "l\n\t\n\t\t\tCDC Vital Signs\n\t\n\t\t\tPublic Health Image Library (PHIL)\n\n\n\n\n\n\t\n\t\t\n\n\n\n\n\n\n\n\n\n\n\n\n    \n",
      "ol and Prevention, Atlanta, Georgia, USA\n\t\t\t\n\n\t\t\tSuggested citation for this article\n\n     ",
      "in Saudi Arabia (1). Subsequent investigation showed that earlier MERS-CoV infection"],
    "title"=>["Evaluation of <em class='highlight'>Patients</em> under Investigation for MERS-CoV Infection, United States, January 2013–October 2014"]}}]

    alert = FactoryGirl.create(:alert, name: 'High Response Disease Response/Alert')
    alert.total_match = 4

    group_name = 'Department of Help'

    emails_to = ['channa.info@gmail.com', 'channa.info+1@gmail.com']
    date_range = DateRange.new(Time.zone.now - 7.days, Time.zone.now)

    AlertMailer.notify_matched(search_highligh, alert.id, group_name, emails_to, date_range)
  end



end