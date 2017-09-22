class PhantomDcController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def retrieve_form_elements
    proxy_action params.slice(:bio_ids)
  end

  def fill_out_form
    proxy_action params.slice(:bio_id, :fields, :campaign_tag)
  end

  def fill_out_captcha
    proxy_action params.slice(:answer, :uid)
  end

  def recent_fill_image
    proxy_action
  end

  def recent_fill_status
    proxy_action
  end

  def recent_statuses_detailed
    proxy_action
  end

  def list_actions
    proxy_action
  end

  def list_congress_members
    proxy_action
  end

  def successful_fills_by_date
    proxy_action
  end

  def successful_fills_by_member
    proxy_action
  end

  private

  def proxy_action(params={})
    congressforms = Rails.application.config.congress_forms_url
    route = request.path.sub("/phantomdc/", "")
    url = "#{congressforms}/#{route}"

    if request.post?
      response = RestClient.post(url, params)
    else
      response = RestClient.get(url, params)
    end

    send_data response.body, status: response.code,
                             type: response.headers[:content_type],
                             disposition: "inline"
  end
end
