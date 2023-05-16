# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'test_helper'

class VisitControllerTest < ActionDispatch::IntegrationTest
  test 'create a new visitor_session, setup a cookie, create a visit. Next time use same cookie and just register a new visit' do
    get v_path(pk: projects(:yandex).key)
    assert_redirected_to %r{\Ahttps://t.me}

    saved_cookie = cookies[VisitController::COOKIE_KEY]
    visit_key = response.redirect_url.split('=').last

    visit = Visit.find_by_telegram_key visit_key
    assert visit.present?

    visitor_session = visit.visitor_session
    assert_equal 1, visitor_session.visits.count

    get v_path(pk: projects(:yandex).key)
    assert_redirected_to %r{\Ahttps://t.me}

    assert_equal 2, visitor_session.visits.count

    assert_equal saved_cookie, cookies[VisitController::COOKIE_KEY]
  end
end
