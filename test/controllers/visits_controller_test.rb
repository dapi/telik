# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'test_helper'

class VisitsControllerTest < ActionDispatch::IntegrationTest
  fixtures :projects

  test 'create a new visitor, setup a cookie, register a visit. Next time use same cookie and just register a new visit' do
    get v_path(pk: projects(:yandex).key)
    assert_redirected_to %r{\Ahttps://t.me}

    saved_cookie = cookies[:telik_visitor_id]
    visit_key = response.redirect_url.split('=').last

    visit = Visit.includes(:visitor).find_by telegram_key: visit_key
    assert visit.present?

    visitor = visit.visitor
    assert_equal 1, visitor.visits.count

    get v_path(pk: projects(:yandex).key)
    assert_redirected_to %r{\Ahttps://t.me}

    assert_equal 2, visitor.visits.count

    assert_equal saved_cookie, cookies[:telik_visitor_id]
  end
end
