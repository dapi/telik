module VisitsHelper
  def telegram_link
    link_to v_url do
      image_tag 'telegram_logo.png',
        class: 'img-responsive',
        width: 50,
        height: 50,
        style: 'position:fixed;bottom:0;margin:1em;background:none;z-index:9999',
        skip_pipeline: true,
        target: '_blank'
    end
  end
end
