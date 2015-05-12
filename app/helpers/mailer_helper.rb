module MailerHelper
  def mailer_image_tag(url, html_options={})
    html_options[:src] = mailer_asset(url)
    tag(:img, html_options)
  end

  def mailer_asset(url)
    "#{asset_host}#{asset_path(url)}"
  end

  def asset_host
    host_url = ENV['ASSET_HOST_URL']

    if host_url && host_url.start_with?("//")
      "http:#{host_url}"
    else
      host_url
    end
  end
end